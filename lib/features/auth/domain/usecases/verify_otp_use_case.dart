import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  Future<AuthUser> call({
    required String verificationId,
    required String otp,
  }) {
    return _repository.verifyOtp(verificationId: verificationId, otp: otp);
  }
}

