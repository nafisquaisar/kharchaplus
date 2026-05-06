import '../entities/auth_user.dart';
import '../entities/otp_session.dart';
import '../entities/user_profile.dart';

abstract class AuthRepository {
  Stream<AuthUser?> userChanges();

  Future<AuthUser> signInWithGoogle();

  Future<AuthUser> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> linkEmailPassword({
    required String email,
    required String password,
  });

  Future<OtpSession> sendOtp(String phoneNumber, {bool isLinking = false});

  Future<AuthUser> verifyOtp({
    required String verificationId,
    required String otp,
  });

  Future<AuthUser> linkPhone({
    required String verificationId,
    required String otp,
  });

  Future<UserProfile?> getUserProfile(String uid);

  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String? photoUrl,
  });

  Future<void> logout();
}
