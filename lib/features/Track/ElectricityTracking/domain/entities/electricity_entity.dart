import '../../core/entities.dart';

class ElectricityEntity extends BaseEntity {

  final String? title;

  final DateTime startDate;
  final DateTime endDate;

  final int prevUnit;
  final int currentUnit;

  final double rate;

  const ElectricityEntity({
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

    this.title,

    required this.startDate,
    required this.endDate,

    required this.prevUnit,
    required this.currentUnit,

    required this.rate,
  });

  int get consumed {

    final value =
        currentUnit - prevUnit;

    return value < 0 ? 0 : value;
  }

  double get total =>
      consumed * rate;

  bool get isHighUsage =>
      consumed >= 500;

  bool get isCriticalBill =>
      total >= 5000;

  String get displayTitle {

    if (title != null &&
        title!.trim().isNotEmpty) {

      return title!;
    }

    return "Electricity Bill";
  }
}