import '../../repository/RecentActivityRepository.dart';

class SyncRecentActivitiesUseCase {
  final RecentActivityRepository repository;

  SyncRecentActivitiesUseCase(
    this.repository,
  );

  Future<void> call() async {
    await repository.syncRecentActivities();
  }
}

