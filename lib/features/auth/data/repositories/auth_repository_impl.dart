import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/otp_session.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';
import '../datasources/firestore_user_data_source.dart';
import '../services/auth_logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _authDataSource;
  final FirestoreUserDataSource _userDataSource;
  final AuthLogger _logger;

  AuthRepositoryImpl(
    this._authDataSource,
    this._userDataSource,
    this._logger,
  );

  @override
  Stream<AuthUser?> userChanges() {
    return _authDataSource.userChanges().map(_mapUser);
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    final credential = await _authDataSource.getGoogleCredential();
    if (credential == null) {
      _logger.logLoginFailure('Google sign-in cancelled');
      throw const AuthException('Google sign-in cancelled');
    }

    final userCredential = await _linkOrSignIn(credential);
    final user = _requireUser(userCredential.user);

    await _userDataSource.upsertUserProfile(
      user: user,
      providers: _providerIds(user),
    );

    _logger.logLoginSuccess('google');
    debugPrint('[Auth] Google sign-in success: ${user.uid}');
    return _mapUser(user)!;
  }

  @override
  Future<OtpSession> sendOtp(String phoneNumber, {bool isLinking = false}) async {
    final result = await _authDataSource.sendOtp(phoneNumber, isLinking: isLinking);

    if (result.isAutoVerified) {
      final credential = result.credential;
      if (credential == null) {
        throw const AuthException('OTP credential missing');
      }

      final userCredential = await _linkOrSignIn(credential);
      final user = _requireUser(userCredential.user);

      await _userDataSource.upsertUserProfile(
        user: user,
        providers: _providerIds(user),
      );

      if (isLinking) {
        _logger.logLinkingResult(success: true);
      } else {
        _logger.logLoginSuccess('phone');
      }
      debugPrint('[Auth] OTP auto-verified: ${user.uid}');
      return OtpSession.autoVerified(_mapUser(user)!);
    }

    if (result.verificationId == null) {
      throw const AuthException('OTP session missing verification ID');
    }

    debugPrint('[Auth] OTP code sent');
    return OtpSession.codeSent(result.verificationId!);
  }

  @override
  Future<AuthUser> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    final userCredential = await _linkOrSignIn(credential);
    final user = _requireUser(userCredential.user);

    await _userDataSource.upsertUserProfile(
      user: user,
      providers: _providerIds(user),
    );

    _logger.logLoginSuccess('phone');
    debugPrint('[Auth] OTP verified: ${user.uid}');
    return _mapUser(user)!;
  }

  @override
  Future<AuthUser> linkPhone({
    required String verificationId,
    required String otp,
  }) async {
    final currentUser = _authDataSource.currentUser;
    if (currentUser == null) {
      _logger.logLinkingResult(success: false, reason: 'No authenticated user');
      throw const AuthException('No authenticated user to link');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    UserCredential userCredential;
    try {
      userCredential = await _authDataSource.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        userCredential = await _authDataSource.signInWithCredential(credential);
      } else {
        _logger.logLinkingResult(success: false, reason: e.code);
        rethrow;
      }
    }

    final linkedUser = _requireUser(userCredential.user);
    final refreshedUser = await _reloadUser(linkedUser);
    if (refreshedUser.uid != currentUser.uid) {
      await _userDataSource.mergeUserProfiles(
        fromUid: currentUser.uid,
        toUid: refreshedUser.uid,
      );
    }

    await _userDataSource.upsertUserProfile(
      user: refreshedUser,
      providers: _providerIds(refreshedUser),
    );

    _logger.logLinkingResult(success: true);
    debugPrint('[Auth] Phone linked: ${refreshedUser.uid}');
    return _mapUser(refreshedUser)!;
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) {
    return _userDataSource.getUserProfile(uid);
  }

  @override
  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String? photoUrl
  }) async {
    await _userDataSource.saveUserProfile(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
    );

    await _authDataSource.updateProfile(
      displayName: name,
      photoUrl: photoUrl,
    );
  }

  @override
  Future<void> logout() async {
    await _authDataSource.signOut();
    debugPrint('[Auth] Signed out');
  }

  Future<UserCredential> _linkOrSignIn(AuthCredential credential) async {
    final currentUser = _authDataSource.currentUser;
    if (currentUser != null) {
      try {
        return await _authDataSource.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use' ||
            e.code == 'provider-already-linked') {
          final userCredential =
              await _authDataSource.signInWithCredential(credential);
          final signedInUser = _requireUser(userCredential.user);
          if (signedInUser.uid != currentUser.uid) {
            await _userDataSource.mergeUserProfiles(
              fromUid: currentUser.uid,
              toUid: signedInUser.uid,
            );
          }
          return userCredential;
        }
        rethrow;
      }
    }

    return _authDataSource.signInWithCredential(credential);
  }

  Future<User> _reloadUser(User user) async {
    await user.reload();
    return _authDataSource.currentUser ?? user;
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }

    return AuthUser(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      providers: _providerIds(user),
    );
  }

  User _requireUser(User? user) {
    if (user == null) {
      throw const AuthException('No authenticated user');
    }
    return user;
  }

  List<String> _providerIds(User user) {
    final providers = user.providerData
        .map((provider) => _normalizeProvider(provider.providerId))
        .toSet()
        .toList();
    return providers;
  }

  String _normalizeProvider(String providerId) {
    if (providerId == 'google.com') {
      return 'google';
    }
    if (providerId == 'phone') {
      return 'phone';
    }
    if (providerId == 'password') {
      return 'email';
    }
    return providerId;
  }
}
