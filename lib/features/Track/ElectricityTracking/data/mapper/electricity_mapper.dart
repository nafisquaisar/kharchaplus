import '../../domain/entities/electricity_entity.dart';
import '../models/electricity_model.dart';

extension ElectricityModelMapper
on ElectricityModel {

  ElectricityEntity toEntity() {

    return ElectricityEntity(

      id: id,

      title: title,

      startDate: startDate,
      endDate: endDate,

      prevUnit: prevUnit,
      currentUnit: currentUnit,

      rate: rate,

      isSynced: isSynced,
      isDeleted: isDeleted,
      isEdited: isEdited,
      isActive: isActive,

      isOfflineCreated:
      isOfflineCreated,

      version: version,

      createdAt: createdAt,
      updatedAt: updatedAt,

      userId: userId,

      serverId: serverId,
    );
  }
}

extension ElectricityEntityMapper
on ElectricityEntity {

  ElectricityModel toModel() {

    return ElectricityModel(

      id: id,

      title: title,

      startDate: startDate,
      endDate: endDate,

      prevUnit: prevUnit,
      currentUnit: currentUnit,

      rate: rate,

      isSynced: isSynced,
      isDeleted: isDeleted,
      isEdited: isEdited,
      isActive: isActive,

      isOfflineCreated:
      isOfflineCreated,

      version: version,

      createdAt: createdAt,
      updatedAt: updatedAt,

      userId: userId,

      serverId: serverId,
    );
  }
}