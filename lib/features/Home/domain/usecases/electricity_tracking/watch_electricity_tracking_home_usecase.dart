import '../../entities/electricity_tracking_entity.dart';
import '../../repository/electricity_tracking_home_repository.dart';

class WatchElectricityTrackingHomeUseCase {
  final ElectricityTrackingHomeRepository repository;

  WatchElectricityTrackingHomeUseCase(this.repository);

  Stream<List<ElectricityTrackingHomeEntity>> call() {
    return repository.watchCachedCycles();
  }
}

