import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LinkPhoneUseCase {
  final AuthRepository _repository;

  const LinkPhoneUseCase(this._repository);

  Future<AuthUser> call({
    required String verificationId,
    required String otp,
  }) {
    return _repository.linkPhone(verificationId: verificationId, otp: otp);
  }
}

