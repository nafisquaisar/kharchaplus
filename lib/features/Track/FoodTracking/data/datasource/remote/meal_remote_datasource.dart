import '../../../domain/entities/FoodCycle.dart';
import '../../../domain/entities/MealEntry.dart';

abstract class MealRemoteDataSource {

  // FOOD CYCLE

  Future<void> createCycle(
      FoodCycle cycle,
      );

  Future<List<FoodCycle>>
  getAllCycles();

  Future<void> updateCycle(
      FoodCycle cycle,
      );

  Future<void> deleteCycle(
      String cycleId,
      );

  // MEAL ENTRY

  Future<void> saveMealEntry(
      MealEntry entry,
      );

  Future<List<MealEntry>>
  getMealEntries(
      String cycleId,
      );


  Stream<List<MealEntry>>
  watchMealEntries(
      String cycleId,
      );

  Future<void> deleteMealEntry(
      String cycleId,
      String entryId,
      );
}