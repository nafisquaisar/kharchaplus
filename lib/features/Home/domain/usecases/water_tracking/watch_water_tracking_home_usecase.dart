import '../../entities/water_tracking_entity.dart';
import '../../repository/water_tracking_home_repository.dart';

class WatchWaterTrackingHomeUseCase {
  final WaterTrackingHomeRepository repository;

  WatchWaterTrackingHomeUseCase(this.repository);

  Stream<WaterTrackingHomeEntity?> call() {
    return repository.watchCachedSnapshot();
  }
}

