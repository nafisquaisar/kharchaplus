import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:expense_tracker/features/auth/domain/entities/auth_exception.dart';
import 'package:expense_tracker/features/auth/domain/entities/auth_state.dart';
import 'package:expense_tracker/features/auth/domain/entities/auth_user.dart';
import 'package:expense_tracker/features/auth/domain/entities/otp_session.dart';
import 'package:expense_tracker/features/auth/domain/entities/user_profile.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/features/auth/domain/usecases/link_email_password_use_case.dart';
import 'package:expense_tracker/features/auth/domain/usecases/link_phone_use_case.dart';
import 'package:expense_tracker/features/auth/domain/usecases/logout_use_case.dart';
import 'package:expense_tracker/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_with_email_password_use_case.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_with_google_use_case.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_with_email_password_use_case.dart';
import 'package:expense_tracker/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:expense_tracker/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:expense_tracker/features/auth/data/services/auth_logger.dart';
import 'package:expense_tracker/features/auth/data/services/auth_cooldown_storage.dart';
import 'package:expense_tracker/features/auth/domain/usecases/get_user_profile_use_case.dart';
import 'package:expense_tracker/features/auth/domain/usecases/save_user_profile_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSignInWithGoogleUseCase extends Mock
    implements SignInWithGoogleUseCase {}

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class MockLinkPhoneUseCase extends Mock implements LinkPhoneUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAuthLogger extends Mock implements AuthLogger {}

class MockCooldownStorage extends Mock implements AuthCooldownStorage {}

class MockSignInWithEmailPasswordUseCase extends Mock
    implements SignInWithEmailPasswordUseCase {}

class MockSignUpWithEmailPasswordUseCase extends Mock
    implements SignUpWithEmailPasswordUseCase {}

class MockLinkEmailPasswordUseCase extends Mock
    implements LinkEmailPasswordUseCase {}

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockSaveUserProfileUseCase extends Mock implements SaveUserProfileUseCase {}

void main() {
  late MockAuthRepository repository;
  late MockSignInWithGoogleUseCase signInWithGoogle;
  late MockSendOtpUseCase sendOtp;
  late MockVerifyOtpUseCase verifyOtp;
  late MockLinkPhoneUseCase linkPhone;
  late MockLogoutUseCase logout;
  late MockAuthLogger logger;
  late MockCooldownStorage cooldownStorage;
  late MockSignInWithEmailPasswordUseCase signInWithEmailPassword;
  late MockSignUpWithEmailPasswordUseCase signUpWithEmailPassword;
  late MockLinkEmailPasswordUseCase linkEmailPassword;
  late MockGetUserProfileUseCase getUserProfile;
  late MockSaveUserProfileUseCase saveUserProfile;
  late StreamController<AuthUser?> authStream;

  AuthViewModel buildViewModel() {
    return AuthViewModel(
      authRepository: repository,
      signInWithGoogle: signInWithGoogle,
      signInWithEmailPassword: signInWithEmailPassword,
      signUpWithEmailPassword: signUpWithEmailPassword,
      sendOtp: sendOtp,
      verifyOtp: verifyOtp,
      linkPhone: linkPhone,
      linkEmailPassword: linkEmailPassword,
      logout: logout,
      getUserProfile: getUserProfile,
      saveUserProfile: saveUserProfile,
      logger: logger,
      cooldownStorage: cooldownStorage,
    );
  }

  setUp(() {
    repository = MockAuthRepository();
    signInWithGoogle = MockSignInWithGoogleUseCase();
    sendOtp = MockSendOtpUseCase();
    verifyOtp = MockVerifyOtpUseCase();
    linkPhone = MockLinkPhoneUseCase();
    logout = MockLogoutUseCase();
    logger = MockAuthLogger();
    cooldownStorage = MockCooldownStorage();
    signInWithEmailPassword = MockSignInWithEmailPasswordUseCase();
    signUpWithEmailPassword = MockSignUpWithEmailPasswordUseCase();
    linkEmailPassword = MockLinkEmailPasswordUseCase();
    getUserProfile = MockGetUserProfileUseCase();
    saveUserProfile = MockSaveUserProfileUseCase();
    authStream = StreamController<AuthUser?>.broadcast();

    when(() => repository.userChanges())
        .thenAnswer((_) => authStream.stream);
    when(() => cooldownStorage.getCooldownEndMs())
        .thenAnswer((_) async => null);
    when(() => cooldownStorage.getLastPhoneNumber())
        .thenAnswer((_) async => null);
    when(() => cooldownStorage.saveCooldown(
          cooldownEndMs: any(named: 'cooldownEndMs'),
          phoneNumber: any(named: 'phoneNumber'),
        )).thenAnswer((_) async {});
    when(() => cooldownStorage.clearCooldown())
        .thenAnswer((_) async {});
    when(() => logger.logLoginSuccess(any()))
        .thenAnswer((_) async {});
    when(() => logger.logLoginFailure(any()))
        .thenAnswer((_) async {});
    when(() => logger.logOtpFailure(any()))
        .thenAnswer((_) async {});
    when(() => logger.logLinkingResult(success: any(named: 'success'), reason: any(named: 'reason')))
        .thenAnswer((_) async {});
    when(() => getUserProfile(any())).thenAnswer(
      (_) async => const UserProfile(
        uid: 'uid-1',
        name: 'Tester',
        email: 'user@test.com',
        phone: '+15555550000',
      ),
    );
  });

  tearDown(() async {
    await authStream.close();
  });

  test('signInWithGoogle emits AuthAuthenticated on success', () async {
    final vm = buildViewModel();
    final user = AuthUser(uid: 'uid-1', providers: const ['google']);

    when(() => signInWithGoogle()).thenAnswer((_) async => user);

    final success = await vm.signInWithGoogle();
    authStream.add(user);
    await Future<void>.delayed(Duration.zero);

    expect(success, true);
    expect(vm.state, isA<AuthAuthenticated>());
    expect((vm.state as AuthAuthenticated).user.uid, 'uid-1');

    vm.dispose();
  });

  test('signInWithGoogle emits AuthError on failure', () async {
    final vm = buildViewModel();

    when(() => signInWithGoogle())
        .thenThrow(const AuthException('Google failed'));

    final success = await vm.signInWithGoogle();

    expect(success, false);
    expect(vm.state, isA<AuthError>());

    vm.dispose();
  });

  test('sendOtp auto-verified returns success and updates state', () async {
    final vm = buildViewModel();
    final user = AuthUser(uid: 'uid-2', providers: const ['phone']);

    when(() => sendOtp('+15555553333', isLinking: any(named: 'isLinking')))
        .thenAnswer((_) async => OtpSession.autoVerified(user));
    when(() => getUserProfile(any())).thenAnswer(
      (_) async => const UserProfile(
        uid: 'uid-2',
        name: 'Phone User',
        email: 'phone@test.com',
        phone: '+15555553333',
      ),
    );

    final result = await vm.sendOtp('+15555553333');

    expect(result, OtpSendStatus.autoVerified);
    expect(vm.state, isA<AuthAuthenticated>());

    vm.dispose();
  });

  test('sendOtp codeSent moves to unauthenticated state', () async {
    final vm = buildViewModel();

    when(() => sendOtp('+15555554444', isLinking: any(named: 'isLinking')))
        .thenAnswer((_) async => const OtpSession.codeSent('ver-id'));

    final result = await vm.sendOtp('+15555554444');

    expect(result, OtpSendStatus.codeSent);
    expect(vm.state, isA<AuthUnauthenticated>());

    vm.dispose();
  });

  test('verifyOtp emits AuthAuthenticated when verification succeeds', () async {
    final vm = buildViewModel();
    final user = AuthUser(uid: 'uid-3', providers: const ['phone']);

    when(() => sendOtp('+15555555555', isLinking: any(named: 'isLinking')))
        .thenAnswer((_) async => const OtpSession.codeSent('ver-id'));
    when(() => verifyOtp(verificationId: 'ver-id', otp: '123456'))
        .thenAnswer((_) async => user);
    when(() => getUserProfile(any())).thenAnswer(
      (_) async => const UserProfile(
        uid: 'uid-3',
        name: 'Otp User',
        email: 'otp@test.com',
        phone: '+15555555555',
      ),
    );

    await vm.sendOtp('+15555555555');
    final success = await vm.verifyOtp('123456');

    expect(success, true);
    expect(vm.state, isA<AuthAuthenticated>());

    vm.dispose();
  });

  test('verifyOtp returns AuthError when session is invalid', () async {
    final vm = buildViewModel();

    final success = await vm.verifyOtp('123456');

    expect(success, false);
    expect(vm.state, isA<AuthError>());

    vm.dispose();
  });

  test('auth stream restores session to authenticated state', () async {
    final vm = buildViewModel();
    final user = AuthUser(uid: 'uid-session', providers: const ['google']);

    authStream.add(user);
    await Future<void>.delayed(Duration.zero);

    expect(vm.state, isA<AuthAuthenticated>());

    vm.dispose();
  });

  test('logout resets state to unauthenticated on stream update', () async {
    final vm = buildViewModel();

    when(() => logout()).thenAnswer((_) async {});

    await vm.logout();
    authStream.add(null);
    await Future<void>.delayed(Duration.zero);

    expect(vm.state, isA<AuthUnauthenticated>());

    vm.dispose();
  });

  test('linkPhone emits AuthError on failure', () async {
    final vm = buildViewModel();

    when(() => sendOtp('+15555556666', isLinking: any(named: 'isLinking')))
        .thenAnswer((_) async => const OtpSession.codeSent('ver-id'));
    when(() => linkPhone(verificationId: 'ver-id', otp: '222222'))
        .thenThrow(const AuthException('Link failed'));

    await vm.sendOtp('+15555556666');
    final success = await vm.linkPhone('222222');

    expect(success, false);
    expect(vm.state, isA<AuthError>());

    vm.dispose();
  });

  test('verifyOtp emits AuthError on network failure', () async {
    final vm = buildViewModel();

    when(() => sendOtp('+15555557777', isLinking: any(named: 'isLinking')))
        .thenAnswer((_) async => const OtpSession.codeSent('ver-id'));
    when(() => verifyOtp(verificationId: 'ver-id', otp: '111111')).thenThrow(
      FirebaseAuthException(code: 'network-request-failed'),
    );

    await vm.sendOtp('+15555557777');
    final success = await vm.verifyOtp('111111');

    expect(success, false);
    expect(vm.state, isA<AuthError>());

    vm.dispose();
  });
}
