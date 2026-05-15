import '../../../domain/entities/water_reminder_entity.dart';

class ReminderState {
  final bool isLoading;
  final List<WaterReminderEntity> reminders;
  final String? error;

  const ReminderState({
    required this.isLoading,
    required this.reminders,
    this.error,
  });

  factory ReminderState.initial() {
    return const ReminderState(
      isLoading: false,
      reminders: [],
      error: null,
    );
  }

  ReminderState copyWith({
    bool? isLoading,
    List<WaterReminderEntity>? reminders,
    String? error,
  }) {
    return ReminderState(
      isLoading: isLoading ?? this.isLoading,
      reminders: reminders ?? this.reminders,
      error: error,
    );
  }
}

