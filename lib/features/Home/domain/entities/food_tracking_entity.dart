class FoodTrackingHomeEntity {
  final String id;
  final String title;
  final int totalTiffin;
  final int totalEaten;
  final int remainingTiffin;
  final double monthlyAmount;
  final double mealPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FoodTrackingHomeEntity({
    required this.id,
    required this.title,
    required this.totalTiffin,
    required this.totalEaten,
    required this.remainingTiffin,
    required this.monthlyAmount,
    required this.mealPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status.toLowerCase() == 'active';

  double get progress {
    if (totalTiffin <= 0) {
      return 0;
    }
    final value = totalEaten / totalTiffin;
    if (value < 0) {
      return 0;
    }
    if (value > 1) {
      return 1;
    }
    return value;
  }

  int get progressPercent => (progress * 100).round();
}

