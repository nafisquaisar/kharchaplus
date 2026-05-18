import '../entities/MealEntry.dart';

abstract class MealRepository {

  // =========================
  // SAVE
  // =========================

  Future<void> saveMealEntry(
      MealEntry entry,
      );

  // =========================
  // GET ALL
  // =========================

  Future<List<MealEntry>>
  getMealEntries(
      String cycleId,
      );

  // =========================
  // GET SINGLE
  // =========================

  Future<MealEntry?> getMealByDate({

    required String cycleId,

    required DateTime date,
  });

  // =========================
  // DELETE
  // =========================

  Future<void> deleteMealEntry(
      String cycleId,
      String entryId,
      );


  Stream<List<MealEntry>>
  watchMealEntries(
      String cycleId,
      );
}