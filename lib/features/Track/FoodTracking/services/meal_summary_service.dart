
import '../domain/entities/MealEntry.dart';

class MealSummaryService {

  // =========================
  // TOTAL MEALS
  // =========================

  static int totalMeals(
      List<MealEntry> meals,
      ) {

    int total = 0;

    for (final meal in meals) {

      if (meal.lunch) {
        total++;
      }

      if (meal.dinner) {
        total++;
      }
    }

    return total;
  }

  // =========================
  // LUNCH COUNT
  // =========================

  static int lunchCount(
      List<MealEntry> meals,
      ) {

    return meals
        .where((e) => e.lunch)
        .length;
  }

  // =========================
  // DINNER COUNT
  // =========================

  static int dinnerCount(
      List<MealEntry> meals,
      ) {

    return meals
        .where((e) => e.dinner)
        .length;
  }

  // =========================
  // SPECIAL COUNT
  // =========================

  static int specialCount(
      List<MealEntry> meals,
      ) {

    return meals
        .where(
          (e) =>
      e.extraMealType != null,
    )
        .length;
  }

  // =========================
  // REMAINING
  // =========================

  static int remainingMeals({

    required int totalMeals,

    required int totalTiffin,
  }) {

    return totalTiffin - totalMeals;
  }

  // =========================
  // TOTAL COST
  // =========================

  static double totalCost({

    required List<MealEntry> meals,

    required double mealPrice,
  }) {

    final total =
    totalMeals(meals);

    return total * mealPrice;
  }

  // =========================
  // PROGRESS
  // =========================

  static double progress({

    required int totalMeals,

    required int totalTiffin,
  }) {

    if (totalTiffin == 0) {
      return 0;
    }

    return
      (totalMeals / totalTiffin)
          * 100;
  }
}