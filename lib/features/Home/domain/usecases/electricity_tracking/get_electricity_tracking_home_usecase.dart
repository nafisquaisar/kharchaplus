import '../../entities/electricity_tracking_entity.dart';
import '../../repository/electricity_tracking_home_repository.dart';

class GetElectricityTrackingHomeUseCase {
  final ElectricityTrackingHomeRepository repository;

  GetElectricityTrackingHomeUseCase(this.repository);

  Future<List<ElectricityTrackingHomeEntity>> call() {
    return repository.getCachedCycles();
  }
}

