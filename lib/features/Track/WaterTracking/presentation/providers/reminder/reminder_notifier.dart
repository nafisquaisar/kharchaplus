import 'package:expense_tracker/core/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/water_reminder_entity.dart';
import '../../../domain/usecases/reminder/add_reminder.dart';
import '../../../domain/usecases/reminder/delete_reminder.dart';
import '../../../domain/usecases/reminder/get_reminders.dart';
import '../../../domain/usecases/reminder/toggle_reminder.dart';
import '../../../domain/usecases/reminder/update_reminder.dart';
import '../../../services/water_notification_service.dart';
import '../sync/sync_provider.dart';
import 'reminder_state.dart';

class ReminderNotifier extends StateNotifier<ReminderState> {
  final AddReminder addReminderUsecase;
  final UpdateReminder updateReminderUsecase;
  final GetReminders getRemindersUsecase;
  final ToggleReminder toggleReminderUsecase;
  final DeleteReminder deleteReminderUsecase;
  final WaterNotificationService notificationService;
  final Ref ref;
  final AuthService authService;

  ReminderNotifier({
    required this.ref,
    required this.authService,
    required this.addReminderUsecase,
    required this.updateReminderUsecase,
    required this.getRemindersUsecase,
    required this.toggleReminderUsecase,
    required this.deleteReminderUsecase,
    required this.notificationService,
  }) : super(ReminderState.initial());

  final Uuid uuid = const Uuid();

  Future<void> loadReminders() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final data = await getRemindersUsecase();

      state = state.copyWith(
        isLoading: false,
        reminders: data,
        error: null,
      );

      await _syncSchedules(data);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addReminder({
    required int hour,
    required int minute,
    required bool repeatDaily,
    required bool enabled,
  }) async {
    try {
      final userId = await authService.getCurrentUserId();
      final reminder = WaterReminderEntity(
        id: uuid.v4(),
        hour: hour,
        minute: minute,
        repeatDaily: repeatDaily,
        enabled: enabled,
        notificationId: _notificationId(),
        isSynced: false,
        isDeleted: false,
        isEdited: false,
        isActive: true,
        isOfflineCreated: true,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: userId,
      );

      state = state.copyWith(
        reminders: [...state.reminders, reminder],
        error: null,
      );

      await addReminderUsecase(reminder);

      await loadReminders();

      ref.read(waterSyncNotifierProvider.notifier).syncNow();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleReminder(String id, bool enabled) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await toggleReminderUsecase(id, enabled);

      await loadReminders();

      if (enabled) {
        final reminder = state.reminders.firstWhere(
          (item) => item.id == id,
        );
        await _scheduleReminder(reminder);
      } else {
        final reminder = state.reminders.firstWhere(
          (item) => item.id == id,
        );
        await notificationService.cancelReminder(reminder.notificationId);
      }

      ref.read(waterSyncNotifierProvider.notifier).syncNow();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateReminder({
    required String reminderId,
    required int hour,
    required int minute,
    required bool repeatDaily,
    required bool enabled,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final existing = state.reminders.firstWhere(
        (item) => item.id == reminderId,
      );

      final duplicate = state.reminders.any(
        (item) =>
            item.id != reminderId &&
            item.hour == hour &&
            item.minute == minute &&
            item.repeatDaily == repeatDaily,
      );

      if (duplicate) {
        state = state.copyWith(isLoading: false, error: 'Duplicate reminder');
        return;
      }

      final updated = WaterReminderEntity(
        id: existing.id,
        hour: hour,
        minute: minute,
        repeatDaily: repeatDaily,
        enabled: enabled,
        notificationId: existing.notificationId,
        isSynced: false,
        isDeleted: false,
        isEdited: true,
        isActive: true,
        isOfflineCreated: existing.isOfflineCreated,
        version: existing.version + 1,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
        userId: existing.userId,
        serverId: existing.serverId,
      );

      state = state.copyWith(
        reminders: state.reminders
            .map((item) => item.id == reminderId ? updated : item)
            .toList(),
        error: null,
      );

      await updateReminderUsecase(updated);

      await loadReminders();

      if (enabled) {
        await _scheduleReminder(updated);
      } else {
        await notificationService.cancelReminder(updated.notificationId);
      }

      ref.read(waterSyncNotifierProvider.notifier).syncNow();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final reminder = state.reminders.firstWhere(
        (item) => item.id == id,
      );

      await deleteReminderUsecase(id);

      await notificationService.cancelReminder(reminder.notificationId);

      await loadReminders();

      ref.read(waterSyncNotifierProvider.notifier).syncNow();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _syncSchedules(List<WaterReminderEntity> reminders) async {
    await notificationService.initialize();
    await notificationService.requestPermissions();

    for (final reminder in reminders) {
      if (reminder.enabled) {
        await notificationService.scheduleReminder(
          notificationId: reminder.notificationId,
          hour: reminder.hour,
          minute: reminder.minute,
          title: 'Time to drink water',
          body: 'Stay hydrated throughout the day',
          repeatDaily: reminder.repeatDaily,
        );
      } else {
        await notificationService.cancelReminder(reminder.notificationId);
      }
    }
  }

  Future<void> _scheduleReminder(WaterReminderEntity reminder) async {
    await notificationService.initialize();
    await notificationService.requestPermissions();

    await notificationService.scheduleReminder(
      notificationId: reminder.notificationId,
      hour: reminder.hour,
      minute: reminder.minute,
      title: 'Time to drink water',
      body: 'Stay hydrated throughout the day',
      repeatDaily: reminder.repeatDaily,
    );
  }

  int _notificationId() {
    return DateTime.now().microsecondsSinceEpoch.remainder(2147483647);
  }
}
