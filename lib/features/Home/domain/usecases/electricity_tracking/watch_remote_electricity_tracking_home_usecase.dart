import '../../entities/electricity_tracking_entity.dart';
import '../../repository/electricity_tracking_home_repository.dart';

class WatchRemoteElectricityTrackingHomeUseCase {
  final ElectricityTrackingHomeRepository repository;

  WatchRemoteElectricityTrackingHomeUseCase(this.repository);

  Stream<List<ElectricityTrackingHomeEntity>> call() {
    return repository.watchRemoteCycles();
  }
}

