

import '../../entities/RecentActivityEntity.dart';
import '../../repository/RecentActivityRepository.dart';

class AddRecentActivityUseCase {
  final RecentActivityRepository repository;

  AddRecentActivityUseCase(
      this.repository,
      );

  Future<void> call(
      RecentActivityEntity activity,
      ) async {
    await repository.addActivity(
      activity,
    );
  }
}