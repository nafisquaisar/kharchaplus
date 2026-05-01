import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailPasswordUseCase {
  final AuthRepository _repository;

  const SignInWithEmailPasswordUseCase(this._repository);

  Future<AuthUser> call({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }
}

