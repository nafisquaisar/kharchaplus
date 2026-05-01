import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailPasswordUseCase {
  final AuthRepository _repository;

  const SignUpWithEmailPasswordUseCase(this._repository);

  Future<AuthUser> call({
    required String email,
    required String password,
  }) {
    return _repository.signUpWithEmailPassword(
      email: email,
      password: password,
    );
  }
}

