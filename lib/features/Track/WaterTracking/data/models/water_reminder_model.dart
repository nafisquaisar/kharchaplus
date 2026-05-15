import 'package:isar/isar.dart';

part 'water_reminder_model.g.dart';

@collection
class WaterReminderModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late int hour;

  late int minute;

  late bool repeatDaily;

  late bool enabled;

  late int notificationId;

  // =========================
  // Sync Fields
  // =========================

  late bool isSynced;

  late bool isDeleted;

  late bool isEdited;

  late bool isActive;

  late bool isOfflineCreated;

  late int version;

  late DateTime createdAt;

  late DateTime updatedAt;

  late String userId;

  String? serverId;
}

