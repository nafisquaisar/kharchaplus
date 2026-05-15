import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/auth_provider.dart';
import '../../../data/datasource/local/isar/water_reminder_local_ds.dart';
import '../../../data/datasource/local/isar/water_reminder_local_ds_impl.dart';
import '../../../data/repository/reminder_repository_impl.dart';
import '../../../domain/usecases/reminder/add_reminder.dart';
import '../../../domain/usecases/reminder/delete_reminder.dart';
import '../../../domain/usecases/reminder/get_reminders.dart';
import '../../../domain/usecases/reminder/toggle_reminder.dart';
import '../../../domain/usecases/reminder/update_reminder.dart';
import '../../../services/water_notification_service.dart';
import 'reminder_notifier.dart';
import 'reminder_state.dart';

final waterReminderLocalDSProvider = Provider<WaterReminderLocalDataSource>(
  (ref) => WaterReminderLocalDataSourceImpl(),
);

final reminderRepositoryProvider = Provider<ReminderRepositoryImpl>(
  (ref) => ReminderRepositoryImpl(
    localDataSource: ref.read(waterReminderLocalDSProvider),
    authService: ref.read(authServiceProvider),
  ),
);

final addReminderProvider = Provider<AddReminder>(
  (ref) => AddReminder(ref.read(reminderRepositoryProvider)),
);

final getRemindersProvider = Provider<GetReminders>(
  (ref) => GetReminders(ref.read(reminderRepositoryProvider)),
);

final toggleReminderProvider = Provider<ToggleReminder>(
  (ref) => ToggleReminder(ref.read(reminderRepositoryProvider)),
);

final deleteReminderProvider = Provider<DeleteReminder>(
  (ref) => DeleteReminder(ref.read(reminderRepositoryProvider)),
);

final updateReminderProvider = Provider<UpdateReminder>(
  (ref) => UpdateReminder(ref.read(reminderRepositoryProvider)),
);

final reminderNotificationServiceProvider = Provider<WaterNotificationService>(
  (ref) => WaterNotificationService(),
);

final reminderNotifierProvider =
    StateNotifierProvider<ReminderNotifier, ReminderState>(
  (ref) => ReminderNotifier(
    ref: ref,
    authService: ref.read(authServiceProvider),
    addReminderUsecase: ref.read(addReminderProvider),
    updateReminderUsecase: ref.read(updateReminderProvider),
    getRemindersUsecase: ref.read(getRemindersProvider),
    toggleReminderUsecase: ref.read(toggleReminderProvider),
    deleteReminderUsecase: ref.read(deleteReminderProvider),
    notificationService: ref.read(reminderNotificationServiceProvider),
  ),
);
