import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/providers/auth_provider.dart';
import '../goal/goal_provider.dart';
import '../intake/intake_provider.dart';
import '../notification/water_notification_provider.dart';
import '../purchase/purchase_provider.dart';
import '../reminder/reminder_provider.dart';
import '../sync/sync_provider.dart';

final waterSessionControllerProvider = Provider<void>((ref) {
  ref.listen<String?>(
    authUserIdProvider,
    (previous, next) {
      if (previous == next) return;

      ref.invalidate(goalNotifierProvider);
      ref.invalidate(intakeNotifierProvider);
      ref.invalidate(reminderNotifierProvider);
      ref.invalidate(purchaseNotifierProvider);
      ref.invalidate(waterNotificationControllerProvider);
      ref.invalidate(waterSyncNotifierProvider);

      if (next == null) return;

      Future.microtask(() async {
        await ref.read(reminderNotifierProvider.notifier).loadReminders();
        await ref.read(intakeNotifierProvider.notifier).loadTodayIntake();
        await ref.read(intakeNotifierProvider.notifier).loadWeeklyIntake();
        await ref.read(intakeNotifierProvider.notifier).loadMonthlyIntake();
        await ref.read(goalNotifierProvider.notifier).loadGoal();
        await ref.read(purchaseNotifierProvider.notifier).loadPurchases();
      });
    },
    fireImmediately: true,
  );
});
