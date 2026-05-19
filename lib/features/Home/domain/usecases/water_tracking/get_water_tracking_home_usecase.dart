import '../../entities/water_tracking_entity.dart';
import '../../repository/water_tracking_home_repository.dart';

class GetWaterTrackingHomeUseCase {
  final WaterTrackingHomeRepository repository;

  GetWaterTrackingHomeUseCase(this.repository);

  Future<WaterTrackingHomeEntity?> call() {
    return repository.getCachedSnapshot();
  }
}

