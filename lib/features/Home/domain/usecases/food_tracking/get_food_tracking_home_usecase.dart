import '../../entities/food_tracking_entity.dart';
import '../../repository/food_tracking_home_repository.dart';

class GetFoodTrackingHomeUseCase {
  final FoodTrackingHomeRepository repository;

  GetFoodTrackingHomeUseCase(this.repository);

  Future<List<FoodTrackingHomeEntity>> call() {
    return repository.getCachedCycles();
  }
}

