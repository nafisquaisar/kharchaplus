import '../entities/otp_session.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;

  const SendOtpUseCase(this._repository);

  Future<OtpSession> call(String phoneNumber, {bool isLinking = false}) {
    return _repository.sendOtp(phoneNumber, isLinking: isLinking);
  }
}
