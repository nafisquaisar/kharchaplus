import '../../entities/water_reminder_entity.dart';
import '../../repository/reminder_repository.dart';

class GetReminders {
  final ReminderRepository repository;

  GetReminders(this.repository);

  Future<List<WaterReminderEntity>> call() async {
    return repository.getReminders();
  }
}

