
import '../../repository/RecentActivityRepository.dart';

class DeleteRecentActivityUseCase {
  final RecentActivityRepository repository;

  DeleteRecentActivityUseCase(
      this.repository,
      );

  Future<void> call(
      String referenceId,
      ) async {
    await repository.deleteActivity(
      referenceId,
    );
  }
}