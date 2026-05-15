
import '../../../../../core/base/base_entity.dart';

class WaterGoalEntity extends BaseEntity {

  final int dailyGoalMl;

  final bool reminderEnabled;

  const WaterGoalEntity({
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

    required this.dailyGoalMl,
    required this.reminderEnabled,
  });
}