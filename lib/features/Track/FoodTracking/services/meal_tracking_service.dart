
import '../domain/entities/MealEntry.dart';
import '../domain/enum/meal_type.dart';

class MealTrackingService {

  // =========================
  // TOGGLE LUNCH
  // =========================

  static MealEntry toggleLunch({

    required MealEntry? existing,

    required String entryId,

    required String cycleId,

    required DateTime date,
  }) {

    if (existing == null) {

      return MealEntry(

        id: entryId,

        cycleId: cycleId,

        date: date,

        lunch: true,

        createdAt: DateTime.now(),

        updatedAt: DateTime.now(),
      );
    }

    return existing.copyWith(

      lunch: !existing.lunch,

      updatedAt: DateTime.now(),
    );
  }

  // =========================
  // TOGGLE DINNER
  // =========================

  static MealEntry toggleDinner({

    required MealEntry? existing,

    required String entryId,

    required String cycleId,

    required DateTime date,
  }) {

    if (existing == null) {

      return MealEntry(

        id: entryId,

        cycleId: cycleId,

        date: date,

        dinner: true,

        createdAt: DateTime.now(),

        updatedAt: DateTime.now(),
      );
    }

    return existing.copyWith(

      dinner: !existing.dinner,

      updatedAt: DateTime.now(),
    );
  }

  // =========================
  // TOGGLE SPECIAL THALI
  // =========================

  static MealEntry toggleSpecial({

    required MealEntry? existing,

    required String entryId,

    required String cycleId,

    required DateTime date,
  }) {

    if (existing == null) {

      return MealEntry(

        id: entryId,

        cycleId: cycleId,

        date: date,

        extraMealType: MealType.specialThali,

        createdAt: DateTime.now(),

        updatedAt: DateTime.now(),
      );
    }

    final isSpecial =
        existing.extraMealType ==
            MealType.specialThali;

    return existing.copyWith(

      extraMealType:

      isSpecial
          ? null
          : MealType.specialThali,

      updatedAt: DateTime.now(),
    );
  }

  // =========================
  // UPDATE NOTE
  // =========================

  static MealEntry updateNote({

    required MealEntry? existing,

    required String entryId,

    required String cycleId,

    required DateTime date,

    required String note,
  }) {

    if (existing == null) {

      return MealEntry(

        id: entryId,

        cycleId: cycleId,

        date: date,

        note: note,

        createdAt: DateTime.now(),

        updatedAt: DateTime.now(),
      );
    }

    return existing.copyWith(

      note: note,

      updatedAt: DateTime.now(),
    );
  }
}