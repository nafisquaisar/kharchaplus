import '../../../../../core/base/base_entity.dart';

class WaterIntakeEntity extends BaseEntity {
  final int amountMl;

  final DateTime dateTime;

  final String sourceType;

  const WaterIntakeEntity({
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
    required this.amountMl,
    required this.dateTime,
    this.sourceType = 'Manual',
  });
}
