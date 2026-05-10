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
  // SYNC
  // =========================

  Future<void> syncPendingData();

}