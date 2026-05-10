class FoodCycleStatsModel {

  final int totalMeals;

  final int lunchCount;

  final int dinnerCount;

  final int specialCount;

  final int totalTiffin;

  final int remaining;

  final double progress;

  final double totalCost;

  const FoodCycleStatsModel({

    required this.totalMeals,

    required this.lunchCount,

    required this.dinnerCount,

    required this.specialCount,

    required this.totalTiffin,

    required this.remaining,

    required this.progress,

    required this.totalCost,
  });

  // =========================
  // EMPTY
  // =========================

  factory FoodCycleStatsModel.empty() {

    return const FoodCycleStatsModel(

      totalMeals: 0,

      lunchCount: 0,

      dinnerCount: 0,

      specialCount: 0,

      totalTiffin: 0,

      remaining: 0,

      progress: 0,

      totalCost: 0,
    );
  }
}