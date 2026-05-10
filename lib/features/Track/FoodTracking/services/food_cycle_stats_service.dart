
import '../domain/entities/MealEntry.dart';
import '../domain/entities/food_cycle_stats_model.dart';

class FoodCycleStatsService {

  static FoodCycleStatsModel calculate({

    required List<MealEntry> meals,

    required int totalTiffin,

    required double mealPrice,
  }) {

    int lunch = 0;

    int dinner = 0;

    int special = 0;

    for (final meal in meals) {

      if (meal.lunch) {
        lunch++;
      }

      if (meal.dinner) {
        dinner++;
      }

      if (meal.extraMealType != null) {
        special++;
      }
    }

    final totalMeals =
        lunch + dinner;

    final remaining =
        totalTiffin - totalMeals;

    final double progress =
    totalTiffin == 0
        ? 0.0
        : totalMeals / totalTiffin;

    final totalCost =
        totalMeals * mealPrice;

    return FoodCycleStatsModel(

      totalMeals: totalMeals,

      lunchCount: lunch,

      dinnerCount: dinner,

      specialCount: special,

      totalTiffin: totalTiffin,

      remaining: remaining,

      progress: progress,

      totalCost: totalCost,
    );
  }
}