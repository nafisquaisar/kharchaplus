
import '../../entities/RecentActivityEntity.dart';
import '../../repository/RecentActivityRepository.dart';


class GetRecentActivitiesUseCase {
  final RecentActivityRepository repository;

  GetRecentActivitiesUseCase(
      this.repository,
      );

  Future<List<RecentActivityEntity>>
  call() async {
    return await repository
        .getRecentActivities();
  }
}