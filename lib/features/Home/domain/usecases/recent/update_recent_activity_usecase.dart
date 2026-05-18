import '../../entities/RecentActivityEntity.dart';
import '../../repository/RecentActivityRepository.dart';

class UpdateRecentActivityUseCase {
  final RecentActivityRepository repository;

  UpdateRecentActivityUseCase(
    this.repository,
  );

  Future<void> call(
    RecentActivityEntity activity,
  ) async {
    await repository.updateActivity(activity);
  }
}

