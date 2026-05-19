import '../data/datasource/local/electricity_tracking_local_datasource.dart';
import '../data/models/electricity_tracking_model.dart';

class ElectricityTrackingHomeCacheService {
  final ElectricityTrackingHomeLocalDataSource localDataSource;

  ElectricityTrackingHomeCacheService(this.localDataSource);

  Future<List<ElectricityTrackingHomeModel>> getCachedCycles() {
    return localDataSource.getElectricityCycles();
  }

  Stream<List<ElectricityTrackingHomeModel>> watchCachedCycles() {
    return localDataSource.watchElectricityCycles();
  }

  Future<void> upsertCachedCycles(List<ElectricityTrackingHomeModel> cycles) {
    return localDataSource.upsertElectricityCycles(cycles);
  }
}

