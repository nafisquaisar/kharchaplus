import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class GetUserProfileUseCase {
  final AuthRepository _repository;

  const GetUserProfileUseCase(this._repository);

  Future<UserProfile?> call(String uid) {
    return _repository.getUserProfile(uid);
  }
}

