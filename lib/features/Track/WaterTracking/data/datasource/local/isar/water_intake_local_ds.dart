import '../../../models/water_intake_model.dart';

abstract class WaterIntakeLocalDataSource {
  Future<void> addWaterIntake(
    WaterIntakeModel model,
  );

  Future<void> updateWaterIntake(
    WaterIntakeModel model,
  );

  Future<void> softDeleteWaterIntake(
    String id,
  );

  Future<List<WaterIntakeModel>> getTodayIntake(
    String userId,
  );

  Future<List<WaterIntakeModel>> getWeeklyIntake(
    String userId,
  );

  Future<List<WaterIntakeModel>> getMonthlyIntake(
    String userId,
  );

  Future<List<WaterIntakeModel>> getIntakeByDate(
    String userId,
    DateTime date,
  );

  Future<List<WaterIntakeModel>> getIntakeByWeek(
    String userId,
    DateTime weekAnchor,
  );

  Future<List<WaterIntakeModel>> getIntakeByMonth(
    String userId,
    int year,
    int month,
  );

  Future<List<WaterIntakeModel>> getPendingSync();

  Future<WaterIntakeModel?> getById(String id);

  Future<void> upsertFromRemote(WaterIntakeModel model);

  Future<void> markSynced(String id, {String? serverId});
}
