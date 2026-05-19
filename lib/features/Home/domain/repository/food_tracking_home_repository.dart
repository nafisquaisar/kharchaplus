import '../entities/food_tracking_entity.dart';

abstract class FoodTrackingHomeRepository {
  Future<List<FoodTrackingHomeEntity>> getCachedCycles();

  Stream<List<FoodTrackingHomeEntity>> watchCachedCycles();

  Stream<List<FoodTrackingHomeEntity>> watchRemoteCycles();

  Future<void> syncCycles();
}

