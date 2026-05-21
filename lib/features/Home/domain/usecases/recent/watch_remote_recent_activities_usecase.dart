import '../../entities/RecentActivityEntity.dart';
import '../../repository/RecentActivityRepository.dart';

class WatchRemoteRecentActivitiesUseCase {

  final RecentActivityRepository repository;

  WatchRemoteRecentActivitiesUseCase(
      this.repository,
      );

  Stream<List<RecentActivityEntity>>
  call(
      String userId,
      ) {

    return repository
        .watchRemoteActivities(
      userId,
    );
  }
}