import '../../entities/RecentActivityEntity.dart';
import '../../repository/RecentActivityRepository.dart';

class WatchRecentActivitiesUseCase {
  final RecentActivityRepository repository;

  WatchRecentActivitiesUseCase(
    this.repository,
  );

  Stream<List<RecentActivityEntity>> call() {
    return repository.watchRecentActivities();
  }
}

