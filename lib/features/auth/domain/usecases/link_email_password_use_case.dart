import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LinkEmailPasswordUseCase {
  final AuthRepository _repository;

  const LinkEmailPasswordUseCase(this._repository);

  Future<AuthUser> call({
    required String email,
    required String password,
  }) {
    return _repository.linkEmailPassword(
      email: email,
      password: password,
    );
  }
}

