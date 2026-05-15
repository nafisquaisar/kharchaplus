import 'package:isar/isar.dart';

import '../../../../../../../core/services/isar_service.dart';
import '../../../models/water_reminder_model.dart';
import 'water_reminder_local_ds.dart';

class WaterReminderLocalDataSourceImpl implements WaterReminderLocalDataSource {
  final Isar isar = IsarService.isar;

  @override
  Future<void> addReminder(WaterReminderModel model) async {
    await isar.writeTxn(() async {
      await isar.waterReminderModels.put(model);
    });
  }

  @override
  Future<void> updateReminder(WaterReminderModel model) async {
    model.updatedAt = DateTime.now();
    model.isEdited = true;
    model.isSynced = false;

    await isar.writeTxn(() async {
      await isar.waterReminderModels.put(model);
    });
  }

  @override
  Future<void> deleteReminder(String id) async {
    final existing = await isar.waterReminderModels
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) return;

    existing.isDeleted = true;
    existing.isSynced = false;
    existing.updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.waterReminderModels.put(existing);
    });
  }

  @override
  Future<void> toggleReminder(String id, bool enabled) async {
    final existing = await isar.waterReminderModels
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) return;

    existing.enabled = enabled;
    existing.isEdited = true;
    existing.isSynced = false;
    existing.updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.waterReminderModels.put(existing);
    });
  }

  @override
  Future<List<WaterReminderModel>> getReminders(String userId) async {
    return isar.waterReminderModels
        .filter()
        .userIdEqualTo(userId)
        .and()
        .isDeletedEqualTo(false)
        .sortByHour()
        .thenByMinute()
        .findAll();
  }

  @override
  Future<List<WaterReminderModel>> getPendingSync() async {
    return isar.waterReminderModels
        .filter()
        .isSyncedEqualTo(false)
        .findAll();
  }

  @override
  Future<WaterReminderModel?> getById(String id) async {
    return isar.waterReminderModels
        .filter()
        .idEqualTo(id)
        .findFirst();
  }

  @override
  Future<void> upsertFromRemote(WaterReminderModel model) async {
    final existing = await isar.waterReminderModels
        .filter()
        .idEqualTo(model.id)
        .findFirst();

    if (existing != null) {
      model.isarId = existing.isarId;
    }

    await isar.writeTxn(() async {
      await isar.waterReminderModels.put(model);
    });
  }

  @override
  Future<void> markSynced(String id, {String? serverId}) async {
    final existing = await isar.waterReminderModels
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
      await isar.waterReminderModels.put(existing);
    });
  }
}
