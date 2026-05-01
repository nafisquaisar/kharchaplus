import '../repository/profile_repository.dart';

class GetProfileData {
  final ProfileRepository repository;

  GetProfileData(this.repository);

  Future<Map<String, dynamic>> call() {
    return repository.getProfileData();
  }
}