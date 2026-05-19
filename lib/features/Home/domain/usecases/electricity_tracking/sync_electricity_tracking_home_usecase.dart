import '../../repository/electricity_tracking_home_repository.dart';

class SyncElectricityTrackingHomeUseCase {
  final ElectricityTrackingHomeRepository repository;

  SyncElectricityTrackingHomeUseCase(this.repository);

  Future<void> call() {
    return repository.syncCycles();
  }
}

