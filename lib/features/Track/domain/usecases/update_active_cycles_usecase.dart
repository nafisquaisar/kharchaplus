import '../repository/tracking_repository.dart';

class UpdateActiveCyclesUseCase {

  final TrackingRepository repository;

  UpdateActiveCyclesUseCase(this.repository);

  Future<void> call({
    required String type,
    required int cycle,
  }) {

    return repository.updateActiveCycles(
      type: type,
      cycle: cycle,
    );
  }
}