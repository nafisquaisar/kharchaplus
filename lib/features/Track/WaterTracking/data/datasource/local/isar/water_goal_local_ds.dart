import 'package:isar/isar.dart';

import '../../../models/water_goal_model.dart';

abstract class WaterGoalLocalDataSource {
  Future<void> updateGoal(
    WaterGoalModel model,
  );

  Future<WaterGoalModel?> getGoal(
    String userId,
  );

  Future<WaterGoalModel?> getGoalById(String id);

  Future<List<WaterGoalModel>> getPendingSync();

  Future<void> upsertGoal(WaterGoalModel model);

  Future<void> markSynced(String id, {String? serverId});
}