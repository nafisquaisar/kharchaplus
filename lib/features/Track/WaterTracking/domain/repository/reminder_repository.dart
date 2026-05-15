import '../entities/water_reminder_entity.dart';

abstract class ReminderRepository {
  Future<void> addReminder(WaterReminderEntity reminder);

  Future<void> updateReminder(WaterReminderEntity reminder);

  Future<void> toggleReminder(String id, bool enabled);

  Future<void> deleteReminder(String id);

  Future<List<WaterReminderEntity>> getReminders();
}

