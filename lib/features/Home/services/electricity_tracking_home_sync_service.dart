import '../data/datasource/remote/electricity_tracking_remote_datasource.dart';
import '../data/models/electricity_tracking_model.dart';

class ElectricityTrackingHomeSyncService {
  final ElectricityTrackingHomeRemoteDataSource remoteDataSource;

  ElectricityTrackingHomeSyncService(this.remoteDataSource);

  Future<List<ElectricityTrackingHomeModel>> fetchRemoteCycles() {
    return remoteDataSource.getElectricityCycles();
  }

  Stream<List<ElectricityTrackingHomeModel>> watchRemoteCycles() {
    return remoteDataSource.watchElectricityCycles();
  }
}

