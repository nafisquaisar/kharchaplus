import '../../repository/water_tracking_home_repository.dart';

class SyncWaterTrackingHomeUseCase {
  final WaterTrackingHomeRepository repository;

  SyncWaterTrackingHomeUseCase(this.repository);

  Future<void> call() {
    return repository.syncSnapshot();
  }
}

