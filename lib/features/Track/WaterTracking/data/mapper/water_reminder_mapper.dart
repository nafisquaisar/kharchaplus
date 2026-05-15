import '../../domain/entities/water_reminder_entity.dart';
import '../models/water_reminder_model.dart';

class WaterReminderMapper {
  static WaterReminderModel entityToModel(WaterReminderEntity entity) {
    final model = WaterReminderModel();
    model.id = entity.id;
    model.hour = entity.hour;
    model.minute = entity.minute;
    model.repeatDaily = entity.repeatDaily;
    model.enabled = entity.enabled;
    model.notificationId = entity.notificationId;
    model.isSynced = entity.isSynced;
    model.isDeleted = entity.isDeleted;
    model.isEdited = entity.isEdited;
    model.isActive = entity.isActive;
    model.isOfflineCreated = entity.isOfflineCreated;
    model.version = entity.version;
    model.createdAt = entity.createdAt;
    model.updatedAt = entity.updatedAt;
    model.userId = entity.userId;
    model.serverId = entity.serverId;
    return model;
  }

  static WaterReminderEntity modelToEntity(WaterReminderModel model) {
    return WaterReminderEntity(
      id: model.id,
      hour: model.hour,
      minute: model.minute,
      repeatDaily: model.repeatDaily,
      enabled: model.enabled,
      notificationId: model.notificationId,
      isSynced: model.isSynced,
      isDeleted: model.isDeleted,
      isEdited: model.isEdited,
      isActive: model.isActive,
      isOfflineCreated: model.isOfflineCreated,
      version: model.version,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      userId: model.userId,
      serverId: model.serverId,
    );
  }
}

