import '../../domain/entities/food_tracking_entity.dart';
import '../models/food_tracking_model.dart';

class FoodTrackingHomeMapper {
  const FoodTrackingHomeMapper._();

  static FoodTrackingHomeEntity toEntity(FoodTrackingHomeModel model) {
    return model;
  }

  static FoodTrackingHomeModel toModel(FoodTrackingHomeEntity entity) {
    return FoodTrackingHomeModel.fromEntity(entity);
  }
}

