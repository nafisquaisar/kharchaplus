import '../../domain/entities/water_goal_entity.dart';
import '../../domain/entities/water_intake_entity.dart';
import '../../domain/entities/water_purchase_entity.dart';

import '../models/water_goal_model.dart';
import '../models/water_intake_model.dart';
import '../models/water_purchase_model.dart';

class WaterMapper {
  // =========================
  // Intake
  // =========================

  static WaterIntakeModel intakeEntityToModel(
    WaterIntakeEntity entity,
  ) {
    final model = WaterIntakeModel();

    model.id = entity.id;

    model.amountMl = entity.amountMl;

    model.dateTime = entity.dateTime;

    model.sourceType = entity.sourceType;

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

  static WaterIntakeEntity intakeModelToEntity(
    WaterIntakeModel model,
  ) {
    return WaterIntakeEntity(
      id: model.id,
      amountMl: model.amountMl,
      dateTime: model.dateTime,
      sourceType: model.sourceType ?? 'Manual',
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

  // =========================
  // Purchase
  // =========================

  static WaterPurchaseModel purchaseEntityToModel(
    WaterPurchaseEntity entity,
  ) {
    final model = WaterPurchaseModel();

    model.id = entity.id;

    model.type = entity.type;

    model.quantity = entity.quantity;

    model.price = entity.price;

    model.vendor = entity.vendor;

    model.date = entity.date;

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

  static WaterPurchaseEntity purchaseModelToEntity(
    WaterPurchaseModel model,
  ) {
    return WaterPurchaseEntity(
      id: model.id,
      type: model.type,
      quantity: model.quantity,
      price: model.price,
      vendor: model.vendor,
      date: model.date,
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

  // =========================
  // Goal
  // =========================

  static WaterGoalModel goalEntityToModel(
    WaterGoalEntity entity,
  ) {
    final model = WaterGoalModel();

    model.id = entity.id;

    model.dailyGoalMl = entity.dailyGoalMl;

    model.reminderEnabled = entity.reminderEnabled;

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

  static WaterGoalEntity goalModelToEntity(
    WaterGoalModel model,
  ) {
    return WaterGoalEntity(
      id: model.id,
      dailyGoalMl: model.dailyGoalMl,
      reminderEnabled: model.reminderEnabled,
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
