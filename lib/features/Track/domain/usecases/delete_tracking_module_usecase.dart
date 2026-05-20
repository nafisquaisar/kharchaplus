import '../repository/tracking_repository.dart';

class DeleteTrackingModuleUseCase {

  final TrackingRepository repository;

  DeleteTrackingModuleUseCase(this.repository);

  Future<void> call({
    required String type,
  }) {

    return repository.deleteTrackingModule(
      type: type,
    );
  }
}