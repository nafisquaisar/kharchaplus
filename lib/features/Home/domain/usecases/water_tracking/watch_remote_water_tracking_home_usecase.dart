import '../../entities/water_tracking_entity.dart';
import '../../repository/water_tracking_home_repository.dart';

class WatchRemoteWaterTrackingHomeUseCase {
  final WaterTrackingHomeRepository repository;

  WatchRemoteWaterTrackingHomeUseCase(this.repository);

  Stream<WaterTrackingHomeEntity?> call() {
    return repository.watchRemoteSnapshot();
  }
}

