import '../../entities/water_reminder_entity.dart';
import '../../repository/reminder_repository.dart';

class UpdateReminder {
  final ReminderRepository repository;

  UpdateReminder(this.repository);

  Future<void> call(WaterReminderEntity reminder) async {
    await repository.updateReminder(reminder);
  }
}

