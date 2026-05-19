import '../../entities/food_tracking_entity.dart';
import '../../repository/food_tracking_home_repository.dart';

class WatchRemoteFoodTrackingHomeUseCase {
  final FoodTrackingHomeRepository repository;

  WatchRemoteFoodTrackingHomeUseCase(this.repository);

  Stream<List<FoodTrackingHomeEntity>> call() {
    return repository.watchRemoteCycles();
  }
}

