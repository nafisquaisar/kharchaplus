import '../data/datasource/remote/food_tracking_remote_datasource.dart';
import '../data/models/food_tracking_model.dart';

class FoodTrackingHomeSyncService {
  final FoodTrackingHomeRemoteDataSource remoteDataSource;

  FoodTrackingHomeSyncService(this.remoteDataSource);

  Future<List<FoodTrackingHomeModel>> fetchRemoteCycles() {
    return remoteDataSource.getFoodCycles();
  }

  Stream<List<FoodTrackingHomeModel>> watchRemoteCycles() {
    return remoteDataSource.watchFoodCycles();
  }
}

