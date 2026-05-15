import '../../repository/reminder_repository.dart';

class ToggleReminder {
  final ReminderRepository repository;

  ToggleReminder(this.repository);

  Future<void> call(String id, bool enabled) async {
    await repository.toggleReminder(id, enabled);
  }
}

