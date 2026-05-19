import '../../entities/food_tracking_entity.dart';
import '../../repository/food_tracking_home_repository.dart';

class WatchFoodTrackingHomeUseCase {
  final FoodTrackingHomeRepository repository;

  WatchFoodTrackingHomeUseCase(this.repository);

  Stream<List<FoodTrackingHomeEntity>> call() {
    return repository.watchCachedCycles();
  }
}

