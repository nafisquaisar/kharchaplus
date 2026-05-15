import '../../../../../core/base/base_entity.dart';

class WaterReminderEntity extends BaseEntity {
  final int hour;
  final int minute;
  final bool repeatDaily;
  final bool enabled;
  final int notificationId;

  const WaterReminderEntity({
    required super.id,
    required super.isSynced,
    required super.isDeleted,
    required super.isEdited,
    required super.isActive,
    required super.isOfflineCreated,
    required super.version,
    required super.createdAt,
    required super.updatedAt,
    required super.userId,
    super.serverId,
    required this.hour,
    required this.minute,
    required this.repeatDaily,
    required this.enabled,
    required this.notificationId,
  });
}

