import '../data/datasource/local/food_tracking_local_datasource.dart';
import '../data/models/food_tracking_model.dart';

class FoodTrackingHomeCacheService {
  final FoodTrackingHomeLocalDataSource localDataSource;

  FoodTrackingHomeCacheService(this.localDataSource);

  Future<List<FoodTrackingHomeModel>> getCachedCycles() {
    return localDataSource.getFoodCycles();
  }

  Stream<List<FoodTrackingHomeModel>> watchCachedCycles() {
    return localDataSource.watchFoodCycles();
  }

  Future<void> upsertCachedCycles(List<FoodTrackingHomeModel> cycles) {
    return localDataSource.upsertFoodCycles(cycles);
  }
}

