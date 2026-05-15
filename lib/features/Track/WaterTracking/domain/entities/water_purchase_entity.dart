
import '../../../../../core/base/base_entity.dart';

class WaterPurchaseEntity extends BaseEntity {

  final String type;

  final int quantity;

  final double price;

  final String? vendor;

  final DateTime date;

  const WaterPurchaseEntity({
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

    required this.type,
    required this.quantity,
    required this.price,
    this.vendor,
    required this.date,
  });
}