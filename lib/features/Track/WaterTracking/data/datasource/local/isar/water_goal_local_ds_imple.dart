import 'package:expense_tracker/features/Track/WaterTracking/data/datasource/local/isar/water_goal_local_ds.dart';
import 'package:isar/isar.dart';

import '../../../../../../../core/services/isar_service.dart';
import '../../../models/water_goal_model.dart';

class WaterGoalLocalDataSourceImpl
    implements
        WaterGoalLocalDataSource {

  final Isar isar =
      IsarService.isar;

  @override
  Future<void> updateGoal(
      WaterGoalModel model,
      ) async {

    model.updatedAt =
        DateTime.now();

    model.isSynced = false;

    final existing = await isar.waterGoalModels
        .filter()
        .idEqualTo(model.id)
        .findFirst();

    if (existing != null) {
      model.isarId = existing.isarId;
    }

    await isar.writeTxn(() async {

      await isar.waterGoalModels
          .put(model);
    });
  }

  @override
  Future<WaterGoalModel?>
  getGoal(
      String userId,
      ) async {

    return isar.waterGoalModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .isDeletedEqualTo(false)
        .findFirst();
  }

  @override
  Future<WaterGoalModel?> getGoalById(String id) async {
    return isar.waterGoalModels
        .filter()
        .idEqualTo(id)
        .findFirst();
  }

  @override
  Future<List<WaterGoalModel>> getPendingSync() async {
    return isar.waterGoalModels
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
  }

  @override
  Future<void> upsertGoal(WaterGoalModel model) async {
    final existing = await isar.waterGoalModels
        .filter()
        .idEqualTo(model.id)
        .findFirst();

    if (existing != null) {
      model.isarId = existing.isarId;
    }

    await isar.writeTxn(() async {
      await isar.waterGoalModels
          .put(model);
    });
  }

  @override
  Future<void> markSynced(String id, {String? serverId}) async {
    final existing = await isar.waterGoalModels
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) return;

    existing.isSynced = true;
    existing.isEdited = false;
    existing.isOfflineCreated = false;
    if (serverId != null) {
      existing.serverId = serverId;
    }

    await isar.writeTxn(() async {
      await isar.waterGoalModels
          .put(existing);
    });
  }
}