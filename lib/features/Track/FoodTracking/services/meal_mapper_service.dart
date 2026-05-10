import '../domain/entities/MealEntry.dart';
import '../domain/enum/meal_type.dart';

class MealMapperService {
  // =========================
  // CALENDAR MAP
  // =========================

  static Map<String, Map<String, bool>> buildCalendarData(
    List<MealEntry> meals,
  ) {
    final Map<String, Map<String, bool>> data = {};

    for (final meal in meals) {
      final key =
          "${meal.date.year}-"
          "${meal.date.month}-"
          "${meal.date.day}";

      data[key] = {
        "lunch": meal.lunch,

        "dinner": meal.dinner,

        "special": meal.extraMealType == MealType.specialThali,
      };
    }

    return data;
  }
}
