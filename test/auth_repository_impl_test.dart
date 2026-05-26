import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_tracker/features/auth/data/datasources/firebase_auth_data_source.dart';
import 'package:expense_tracker/features/auth/data/datasources/firestore_user_data_source.dart';
import 'package:expense_tracker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker/features/auth/domain/entities/auth_exception.dart';
import 'package:expense_tracker/features/auth/data/services/auth_logger.dart';

class MockFirebaseAuthDataSource extends Mock
    implements FirebaseAuthDataSource {}

class MockFirestoreUserDataSource extends Mock
    implements FirestoreUserDataSource {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockUserInfo extends Mock implements UserInfo {}

class FakeAuthCredential extends Fake implements AuthCredential {}

class MockAuthLogger extends Mock implements AuthLogger {}

void main() {
  late MockFirebaseAuthDataSource authDataSource;
  late MockFirestoreUserDataSource userDataSource;
  late MockAuthLogger logger;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
  });

  setUp(() {
    authDataSource = MockFirebaseAuthDataSource();
    userDataSource = MockFirestoreUserDataSource();
    logger = MockAuthLogger();
    repository = AuthRepositoryImpl(authDataSource, userDataSource, logger);

    when(() => logger.logLoginSuccess(any()))
        .thenAnswer((_) async {});
    when(() => logger.logLoginFailure(any()))
        .thenAnswer((_) async {});
    when(() => logger.logOtpFailure(any()))
        .thenAnswer((_) async {});
    when(() => logger.logLinkingResult(success: any(named: 'success'), reason: any(named: 'reason')))
        .thenAnswer((_) async {});
  });

  test('signInWithGoogle returns user and upserts Firestore doc', () async {
    final credential = GoogleAuthProvider.credential(
      accessToken: 'token',
      idToken: 'id-token',
    );
    final userCredential = MockUserCredential();
    final user = MockUser();

    when(() => authDataSource.getGoogleCredential())
        .thenAnswer((_) async => credential);
    when(() => authDataSource.currentUser).thenReturn(null);
    when(() => authDataSource.signInWithCredential(credential))
        .thenAnswer((_) async => userCredential);
    when(() => userCredential.user).thenReturn(user);
    when(() => user.uid).thenReturn('uid-1');
    when(() => user.email).thenReturn('user@test.com');
    when(() => user.phoneNumber).thenReturn(null);
    when(() => user.displayName).thenReturn('Tester');
    when(() => user.photoURL).thenReturn(null);

    final userInfo = MockUserInfo();
    when(() => userInfo.providerId).thenReturn('google.com');
    when(() => user.providerData).thenReturn([userInfo]);

    when(() => userDataSource.upsertUserProfile(
          user: user,
          providers: any(named: 'providers'),
        )).thenAnswer((_) async {});

    final result = await repository.signInWithGoogle();

    expect(result.uid, 'uid-1');
    expect(result.providers, contains('google'));
    verify(() => userDataSource.upsertUserProfile(
          user: user,
          providers: any(named: 'providers'),
        )).called(1);
  });

  test('signInWithGoogle throws when cancelled', () async {
    when(() => authDataSource.getGoogleCredential())
        .thenAnswer((_) async => null);

    expect(
      () => repository.signInWithGoogle(),
      throwsA(isA<AuthException>()),
    );
  });

  test('sendOtp returns auto-verified session', () async {
    final userCredential = MockUserCredential();
    final user = MockUser();
    when(() => authDataSource.sendOtp(
          '+15555550000',
          isLinking: any(named: 'isLinking'),
        )).thenAnswer((_) async =>
        OtpSessionResult.autoVerified(FakeAuthCredential()));
    when(() => authDataSource.currentUser).thenReturn(null);
    when(() => authDataSource.signInWithCredential(any()))
        .thenAnswer((_) async => userCredential);
    when(() => userCredential.user).thenReturn(user);
    when(() => user.uid).thenReturn('uid-2');
    when(() => user.email).thenReturn(null);
    when(() => user.phoneNumber).thenReturn('+15555550000');
    when(() => user.displayName).thenReturn(null);
    when(() => user.photoURL).thenReturn(null);

    final userInfo = MockUserInfo();
    when(() => userInfo.providerId).thenReturn('phone');
    when(() => user.providerData).thenReturn([userInfo]);

    when(() => userDataSource.upsertUserProfile(
          user: user,
          providers: any(named: 'providers'),
        )).thenAnswer((_) async {});

    final session = await repository.sendOtp('+15555550000');

    expect(session.isAutoVerified, true);
    expect(session.user?.uid, 'uid-2');
  });

  test('verifyOtp signs in and upserts user', () async {
    final userCredential = MockUserCredential();
    final user = MockUser();

    when(() => authDataSource.currentUser).thenReturn(null);
    when(() => authDataSource.signInWithCredential(any()))
        .thenAnswer((_) async => userCredential);
    when(() => userCredential.user).thenReturn(user);
    when(() => user.uid).thenReturn('uid-3');
    when(() => user.email).thenReturn(null);
    when(() => user.phoneNumber).thenReturn('+15555551111');
    when(() => user.displayName).thenReturn(null);
    when(() => user.photoURL).thenReturn(null);

    final userInfo = MockUserInfo();
    when(() => userInfo.providerId).thenReturn('phone');
    when(() => user.providerData).thenReturn([userInfo]);

    when(() => userDataSource.upsertUserProfile(
          user: user,
          providers: any(named: 'providers'),
        )).thenAnswer((_) async {});

    final result = await repository.verifyOtp(
      verificationId: 'verification-id',
      otp: '123456',
    );

    expect(result.uid, 'uid-3');
    verify(() => authDataSource.signInWithCredential(any())).called(1);
  });

  test('linkPhone uses linkWithCredential when user exists', () async {
    final userCredential = MockUserCredential();
    final user = MockUser();

    when(() => authDataSource.currentUser).thenReturn(user);
    when(() => user.reload()).thenAnswer((_) async {});
    when(() => authDataSource.linkWithCredential(any()))
        .thenAnswer((_) async => userCredential);
    when(() => userCredential.user).thenReturn(user);
    when(() => user.uid).thenReturn('uid-4');
    when(() => user.email).thenReturn(null);
    when(() => user.phoneNumber).thenReturn('+15555552222');
    when(() => user.displayName).thenReturn(null);
    when(() => user.photoURL).thenReturn(null);

    final userInfo = MockUserInfo();
    when(() => userInfo.providerId).thenReturn('phone');
    when(() => user.providerData).thenReturn([userInfo]);

    when(() => userDataSource.upsertUserProfile(
          user: user,
          providers: any(named: 'providers'),
        )).thenAnswer((_) async {});

    final result = await repository.linkPhone(
      verificationId: 'verification-id',
      otp: '654321',
    );

    expect(result.uid, 'uid-4');
    verify(() => authDataSource.linkWithCredential(any())).called(1);
  });

  test('linkPhone merges profiles when credential already in use', () async {
    final existingUser = MockUser();
    final mergedUserCredential = MockUserCredential();
    final mergedUser = MockUser();

    var currentUserCalls = 0;
    when(() => authDataSource.currentUser).thenAnswer((_) {
      currentUserCalls += 1;
      return currentUserCalls == 1 ? existingUser : mergedUser;
    });
    when(() => existingUser.uid).thenReturn('uid-old');

    when(() => authDataSource.linkWithCredential(any())).thenThrow(
      FirebaseAuthException(code: 'credential-already-in-use'),
    );
    when(() => authDataSource.signInWithCredential(any()))
        .thenAnswer((_) async => mergedUserCredential);
    when(() => mergedUserCredential.user).thenReturn(mergedUser);
    when(() => mergedUser.reload()).thenAnswer((_) async {});
    when(() => mergedUser.uid).thenReturn('uid-new');
    when(() => mergedUser.email).thenReturn('new@test.com');
    when(() => mergedUser.phoneNumber).thenReturn('+15555559999');
    when(() => mergedUser.displayName).thenReturn('Merged');
    when(() => mergedUser.photoURL).thenReturn(null);

    final userInfo = MockUserInfo();
    when(() => userInfo.providerId).thenReturn('phone');
    when(() => mergedUser.providerData).thenReturn([userInfo]);

    when(() => userDataSource.mergeUserProfiles(
          fromUid: 'uid-old',
          toUid: 'uid-new',
        )).thenAnswer((_) async {});
    when(() => userDataSource.upsertUserProfile(
          user: mergedUser,
          providers: any(named: 'providers'),
        )).thenAnswer((_) async {});

    final result = await repository.linkPhone(
      verificationId: 'verification-id',
      otp: '123456',
    );

    expect(result.uid, 'uid-new');
    verify(() => userDataSource.mergeUserProfiles(
          fromUid: 'uid-old',
          toUid: 'uid-new',
        )).called(1);
  });

  test('linkPhone rethrows non-linking exceptions', () async {
    final currentUser = MockUser();
    when(() => authDataSource.currentUser).thenReturn(currentUser);
    when(() => authDataSource.linkWithCredential(any())).thenThrow(
      FirebaseAuthException(code: 'invalid-credential'),
    );

    expect(
      () => repository.linkPhone(
        verificationId: 'verification-id',
        otp: '123456',
      ),
      throwsA(isA<FirebaseAuthException>()),
    );
  });
}
