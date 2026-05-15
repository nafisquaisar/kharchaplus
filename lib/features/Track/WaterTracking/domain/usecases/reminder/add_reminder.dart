import '../../entities/water_reminder_entity.dart';
import '../../repository/reminder_repository.dart';

class AddReminder {
  final ReminderRepository repository;

  AddReminder(this.repository);

  Future<void> call(WaterReminderEntity reminder) async {
    await repository.addReminder(reminder);
  }
}

