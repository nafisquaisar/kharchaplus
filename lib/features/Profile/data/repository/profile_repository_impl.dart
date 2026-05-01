import '../../domain/repository/profile_repository.dart';
import '../datasource/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource dataSource;

  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<Map<String, dynamic>> getProfileData() {
    return dataSource.fetchProfile();
  }
}