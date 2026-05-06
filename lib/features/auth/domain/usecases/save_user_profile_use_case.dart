import '../repositories/auth_repository.dart';

class SaveUserProfileUseCase {
  final AuthRepository _repository;

  const SaveUserProfileUseCase(this._repository);

  Future<void> call({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String? photoUrl,
  }) {
    return _repository.saveUserProfile(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
    );
  }

}

