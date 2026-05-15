import '../../../../../core/base/base_entity.dart';
import '../entities/water_goal_entity.dart';
import '../entities/water_intake_entity.dart';
import '../entities/water_purchase_entity.dart';

abstract class WaterRepository {
  // =========================
  // Intake
  // =========================

  Future<void> addWaterIntake(
    WaterIntakeEntity intake,
  );

  Future<void> updateWaterIntake(
    WaterIntakeEntity intake,
  );

  Future<void> softDeleteWaterIntake(
    String id,
  );

  Future<List<WaterIntakeEntity>> getTodayIntake();

  Future<List<WaterIntakeEntity>> getWeeklyIntake();

  Future<List<WaterIntakeEntity>> getMonthlyIntake();

  Future<List<WaterIntakeEntity>> getIntakeByDate(
    DateTime date,
  );

  Future<List<WaterIntakeEntity>> getIntakeByWeek(
    DateTime weekAnchor,
  );

  Future<List<WaterIntakeEntity>> getIntakeByMonth(
    int year,
    int month,
  );

  // =========================
  // Purchase
  // =========================

  Future<void> addPurchase(
    WaterPurchaseEntity purchase,
  );

  Future<void> updatePurchase(
    WaterPurchaseEntity purchase,
  );

  Future<void> softDeletePurchase(
    String id,
  );

  Future<List<WaterPurchaseEntity>> getPurchases();

  // =========================
  // Goal
  // =========================

  Future<void> updateGoal(
    WaterGoalEntity goal,
  );

  Future<WaterGoalEntity?> getGoal();

  // =========================
  // Sync
  // =========================

  Future<List<BaseEntity>> getPendingSync();

  Future<void> markAsSynced(
    String id,
  );
}
