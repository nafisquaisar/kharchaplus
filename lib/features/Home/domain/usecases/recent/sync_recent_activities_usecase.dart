import '../../repository/RecentActivityRepository.dart';

class SyncRecentActivitiesUseCase {

  final RecentActivityRepository repository;

  SyncRecentActivitiesUseCase(
      this.repository,
      );

  Future<void> call(
      String userId,
      ) async {

    await repository
        .syncRecentActivities(
      userId,
    );
  }
}