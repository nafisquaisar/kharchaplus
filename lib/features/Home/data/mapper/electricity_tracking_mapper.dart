import '../../../Track/ElectricityTracking/data/models/electricity_model.dart';
import '../../domain/entities/electricity_tracking_entity.dart';
import '../models/electricity_tracking_model.dart';

class ElectricityTrackingHomeMapper {
  const ElectricityTrackingHomeMapper._();

  static ElectricityTrackingHomeEntity toEntity(
    ElectricityTrackingHomeModel model,
  ) {
    return model;
  }

  static ElectricityTrackingHomeModel toModel(
    ElectricityTrackingHomeEntity entity,
  ) {
    return ElectricityTrackingHomeModel.fromEntity(entity);
  }

  static ElectricityTrackingHomeModel fromElectricityModel(
    ElectricityModel model, {
    String userId = '',
  }) {
    return ElectricityTrackingHomeModel(
      userId: userId,
      isDeleted: model.isDeleted,
      id: model.id,
      title: model.title ?? 'Electricity Bill',
      startDate: model.startDate,
      endDate: model.endDate,
      prevUnit: model.prevUnit,
      currentUnit: model.currentUnit,
      rate: model.rate,
      isActive: model.isActive,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}

