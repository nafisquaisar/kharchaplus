import '../../../models/water_reminder_model.dart';

abstract class WaterReminderLocalDataSource {
  Future<void> addReminder(WaterReminderModel model);

  Future<void> updateReminder(WaterReminderModel model);

  Future<void> deleteReminder(String id);

  Future<void> toggleReminder(String id, bool enabled);

  Future<List<WaterReminderModel>> getReminders(String userId);

  Future<List<WaterReminderModel>> getPendingSync();

  Future<WaterReminderModel?> getById(String id);

  Future<void> upsertFromRemote(WaterReminderModel model);

  Future<void> markSynced(String id, {String? serverId});
}
