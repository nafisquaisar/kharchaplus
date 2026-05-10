import '../entities/FoodCycle.dart';
import '../entities/MealEntry.dart';


abstract class FoodRepository {

  // =========================
  // FOOD CYCLE
  // =========================

  Future<void> createCycle(FoodCycle cycle);

  Future<void> updateCycle(FoodCycle cycle);

  Future<void> deleteCycle(String cycleId);

  Future<List<FoodCycle>> getAllCycles();

  Future<FoodCycle?> getCycleById(String cycleId);

  // =========================
  // MEAL ENTRY
  // =========================

  Future<void> saveMealEntry(MealEntry entry);

  Future<void> updateMealEntry(MealEntry entry);

  Future<void> deleteMealEntry(String entryId);

  Future<List<MealEntry>> getMealEntries(
      String cycleId,
      );

  Future<MealEntry?> getMealByDate(
      String cycleId,
      DateTime date,
      );

  // =========================
  // SYNC
  // =========================

  Future<void> syncPendingData();

}