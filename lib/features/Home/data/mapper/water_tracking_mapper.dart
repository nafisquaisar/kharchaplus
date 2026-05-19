import '../../domain/entities/water_tracking_entity.dart';
import '../models/water_tracking_model.dart';

class WaterTrackingHomeMapper {
  const WaterTrackingHomeMapper._();

  static WaterTrackingHomeEntity toEntity(
    WaterTrackingHomeModel model,
  ) {
    return model;
  }

  static WaterTrackingHomeModel toModel(
    WaterTrackingHomeEntity entity,
  ) {
    return WaterTrackingHomeModel.fromEntity(entity);
  }
}

