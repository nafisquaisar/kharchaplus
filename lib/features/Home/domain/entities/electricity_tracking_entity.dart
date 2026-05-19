class ElectricityTrackingHomeEntity {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final int prevUnit;
  final int currentUnit;
  final double rate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ElectricityTrackingHomeEntity({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.prevUnit,
    required this.currentUnit,
    required this.rate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  int get consumedUnits {
    final value = currentUnit - prevUnit;
    return value < 0 ? 0 : value;
  }

  double get billAmount => consumedUnits * rate;
}

