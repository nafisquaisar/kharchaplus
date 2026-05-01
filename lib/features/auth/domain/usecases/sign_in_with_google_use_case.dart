import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _repository;

  const SignInWithGoogleUseCase(this._repository);

  Future<AuthUser> call() {
    return _repository.signInWithGoogle();
  }
}

