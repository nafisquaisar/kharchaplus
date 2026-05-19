import '../../repository/food_tracking_home_repository.dart';

class SyncFoodTrackingHomeUseCase {
  final FoodTrackingHomeRepository repository;

  SyncFoodTrackingHomeUseCase(this.repository);

  Future<void> call() {
    return repository.syncCycles();
  }
}

