import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/services/auth_cooldown_storage.dart';
import '../data/services/auth_logger.dart';
import '../domain/entities/auth_exception.dart';
import '../domain/entities/auth_state.dart';
import '../domain/entities/auth_user.dart';
import '../domain/entities/otp_session.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/link_phone_use_case.dart';
import '../domain/usecases/logout_use_case.dart';
import '../domain/usecases/send_otp_use_case.dart';
import '../domain/usecases/sign_in_with_google_use_case.dart';
import '../domain/usecases/verify_otp_use_case.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SendOtpUseCase _sendOtp;
  final VerifyOtpUseCase _verifyOtp;
  final LinkPhoneUseCase _linkPhone;
  final LogoutUseCase _logout;
  final AuthLogger _logger;
  final AuthCooldownStorage _cooldownStorage;

  late final StreamSubscription<AuthUser?> _authSubscription;
  Timer? _resendTimer;
  int _resendSecondsRemaining = 0;
  String? _lastPhoneNumber;

  AuthState _state = const AuthInitial();
  String? _verificationId;
  AuthUser? _currentUser;

  AuthViewModel({
    required AuthRepository authRepository,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SendOtpUseCase sendOtp,
    required VerifyOtpUseCase verifyOtp,
    required LinkPhoneUseCase linkPhone,
    required LogoutUseCase logout,
    required AuthLogger logger,
    required AuthCooldownStorage cooldownStorage,
  })  : _authRepository = authRepository,
        _signInWithGoogle = signInWithGoogle,
        _sendOtp = sendOtp,
        _verifyOtp = verifyOtp,
        _linkPhone = linkPhone,
        _logout = logout,
        _logger = logger,
        _cooldownStorage = cooldownStorage {
    _authSubscription = _authRepository.userChanges().listen(
      _handleAuthUser,
      onError: (error) {
        _setState(AuthError(_mapError(error)));
      },
    );
    _restoreCooldown();
  }

  AuthState get state => _state;

  bool get isLoading => _state is AuthLoading;

  String? get errorMessage =>
      _state is AuthError ? (_state as AuthError).message : null;

  String? get verificationId => _verificationId;

  bool get canResendOtp => _resendSecondsRemaining == 0 && !isLoading;

  int get resendSecondsRemaining => _resendSecondsRemaining;

  AuthUser? get currentUser => _currentUser;

  String get resolvedName {
    final value = _currentUser?.displayName ?? '';
    return value.trim();
  }

  String get resolvedEmail {
    final value = _currentUser?.email ?? '';
    return value.trim();
  }

  String get resolvedPhone {
    final value = _currentUser?.phoneNumber ?? '';
    return value.trim();
  }

  String? get resolvedPhotoUrl => _currentUser?.photoUrl;

  Future<bool> signInWithGoogle() async {
    try {
      _setState(const AuthLoading());
      await _signInWithGoogle();
      return true;
    } on PlatformException catch (e) {
      final message = _formatPlatformError(e);
      _logger.logLoginFailure(message);
      _setState(AuthError(message));
      return false;
    } on FirebaseAuthException catch (e) {
      final message = _formatAuthError(e);
      _logger.logLoginFailure(message);
      _setState(AuthError(message));
      return false;
    } catch (e) {
      _logger.logLoginFailure(_mapError(e));
      _setState(AuthError(_mapError(e)));
      return false;
    }
  }

  Future<OtpSendStatus?> sendOtp(String phoneNumber) async {
    _lastPhoneNumber = phoneNumber;
    _setState(const AuthLoading());

    try {
      final session = await _sendOtpWithRetry(phoneNumber, isLinking: false);
      if (session.isAutoVerified && session.user != null) {
        _currentUser = session.user;
        _setState(AuthAuthenticated(session.user!));
        return OtpSendStatus.autoVerified;
      }

      _verificationId = session.verificationId;
      await _startResendCooldown(phoneNumber);
      _setState(const AuthUnauthenticated());
      return OtpSendStatus.codeSent;
    } on FirebaseAuthException catch (e) {
      final message = _formatAuthError(e);
      _logger.logOtpFailure(message);
      _setState(AuthError(message));
      return null;
    } catch (e) {
      _logger.logOtpFailure(_mapError(e));
      _setState(AuthError(_mapError(e)));
      return null;
    }
  }

  Future<OtpSendStatus?> sendOtpForLink(String phoneNumber) async {
    _lastPhoneNumber = phoneNumber;
    final previousState = _state;
    _setState(const AuthLoading());

    try {
      final session = await _sendOtpWithRetry(phoneNumber, isLinking: true);
      if (session.isAutoVerified && session.user != null) {
        _currentUser = session.user;
        _setState(AuthAuthenticated(session.user!));
        return OtpSendStatus.autoVerified;
      }

      _verificationId = session.verificationId;
      await _startResendCooldown(phoneNumber);
      _setState(previousState);
      return OtpSendStatus.codeSent;
    } on FirebaseAuthException catch (e) {
      final message = _formatAuthError(e);
      _logger.logOtpFailure(message);
      _setState(AuthError(message));
      return null;
    } catch (e) {
      _logger.logOtpFailure(_mapError(e));
      _setState(AuthError(_mapError(e)));
      return null;
    }
  }

  Future<OtpSession> _sendOtpWithRetry(
    String phoneNumber, {
    required bool isLinking,
  }) async {
    const maxAttempts = 2;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await _sendOtp(phoneNumber, isLinking: isLinking)
            .timeout(const Duration(seconds: 30));
      } on FirebaseAuthException catch (e) {
        if (!_isRetryable(e) || attempt == maxAttempts) {
          rethrow;
        }
        _logger.logOtpFailure('Retry $attempt due to ${e.code}');
      } on TimeoutException {
        if (attempt == maxAttempts) {
          throw const AuthException('OTP send timed out');
        }
        _logger.logOtpFailure('Retry $attempt due to timeout');
      }

      await Future.delayed(Duration(milliseconds: 400 * attempt));
    }

    throw const AuthException('OTP send failed');
  }

  bool _isRetryable(FirebaseAuthException exception) {
    return exception.code == 'network-request-failed';
  }

  Future<bool> verifyOtp(String otp) async {
    if (_verificationId == null) {
      _setState(const AuthError('Invalid session. Try again.'));
      return false;
    }

    _setState(const AuthLoading());

    try {
      final user = await _verifyOtp(
        verificationId: _verificationId!,
        otp: otp,
      );
      _currentUser = user;
      _setState(AuthAuthenticated(user));
      return true;
    } on FirebaseAuthException catch (e) {
      final message = _formatAuthError(e);
      _logger.logOtpFailure(message);
      _setState(AuthError(message));
      return false;
    } catch (e) {
      _logger.logOtpFailure(_mapError(e));
      _setState(AuthError(_mapError(e)));
      return false;
    }
  }

  Future<bool> linkPhone(String otp) async {
    if (_verificationId == null) {
      _setState(const AuthError('Invalid session. Try again.'));
      return false;
    }

    _setState(const AuthLoading());

    try {
      final user = await _linkPhone(
        verificationId: _verificationId!,
        otp: otp,
      );
      _currentUser = user;
      _setState(AuthAuthenticated(user));
      return true;
    } on FirebaseAuthException catch (e) {
      final message = _formatAuthError(e);
      _logger.logLinkingResult(success: false, reason: message);
      _setState(AuthError(message));
      return false;
    } catch (e) {
      _logger.logLinkingResult(success: false, reason: _mapError(e));
      _setState(AuthError(_mapError(e)));
      return false;
    }
  }

  Future<void> logout() async {
    _setState(const AuthLoading());
    await _logout();
  }

  void _handleAuthUser(AuthUser? user) {
    if (user == null) {
      _currentUser = null;
      _setState(const AuthUnauthenticated());
      return;
    }

    _currentUser = user;
    _setState(AuthAuthenticated(user));
  }


  void _setState(AuthState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> _startResendCooldown(String phoneNumber) async {
    _resendTimer?.cancel();

    final cooldownEndMs =
        DateTime.now().add(const Duration(seconds: 30)).millisecondsSinceEpoch;
    await _cooldownStorage.saveCooldown(
      cooldownEndMs: cooldownEndMs,
      phoneNumber: phoneNumber,
    );

    _setCooldownFromEnd(cooldownEndMs);
  }

  Future<void> _restoreCooldown() async {
    final cooldownEndMs = await _cooldownStorage.getCooldownEndMs();
    final phoneNumber = await _cooldownStorage.getLastPhoneNumber();

    if (cooldownEndMs == null || phoneNumber == null) {
      return;
    }

    _lastPhoneNumber = phoneNumber;
    _setCooldownFromEnd(cooldownEndMs);
  }
  Future<OtpSendStatus?> resendOtp({bool isLinking = false}) async {
    if (_lastPhoneNumber == null) return null;

    if (isLinking) {
      return await sendOtpForLink(_lastPhoneNumber!);
    } else {
      return await sendOtp(_lastPhoneNumber!);
    }
  }


  void _setCooldownFromEnd(int cooldownEndMs) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final remainingMs = cooldownEndMs - nowMs;

    if (remainingMs <= 0) {
      _resendSecondsRemaining = 0;
      _cooldownStorage.clearCooldown();
      notifyListeners();
      return;
    }

    _resendSecondsRemaining = (remainingMs / 1000).ceil();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSecondsRemaining <= 1) {
        _resendSecondsRemaining = 0;
        _cooldownStorage.clearCooldown();
        timer.cancel();
        notifyListeners();
        return;
      }
      _resendSecondsRemaining -= 1;
      notifyListeners();
    });
  }

  String _mapError(Object error) {
    if (error is AuthException) {
      return error.message;
    }
    if (error is FirebaseAuthException) {
      return _formatAuthError(error);
    }
    return 'Something went wrong';
  }

  String _formatAuthError(FirebaseAuthException error) {
    final message = error.message ?? 'Authentication failed';
    return '[${error.code}] $message';
  }

  String _formatPlatformError(PlatformException error) {
    final message = error.message ?? 'Platform sign-in failed';
    return '[${error.code}] $message';
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _resendTimer?.cancel();
    super.dispose();
  }
}

enum OtpSendStatus {
  codeSent,
  autoVerified,
}