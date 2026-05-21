import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/drinking/GoalStreakCards.dart';
import '../../widgets/drinking/quick_add_card.dart';
import '../../widgets/drinking/water_progress_card.dart';
import '../../widgets/drinking/weekly_chart.dart';
import '../../providers/intake/intake_provider.dart';
import '../../providers/goal/goal_provider.dart';
import '../../providers/notification/water_notification_provider.dart';
import '../../providers/reminder/reminder_provider.dart';
import '../../providers/sync/sync_provider.dart';

class DrinkingTab extends ConsumerStatefulWidget {
  const DrinkingTab({
    super.key,
  });

  @override
  ConsumerState<DrinkingTab> createState() => _DrinkingTabState();
}

class _DrinkingTabState extends ConsumerState<DrinkingTab> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      ref.read(waterNotificationControllerProvider);
      ref.read(waterSyncNotifierProvider);
      await ref.read(reminderNotifierProvider.notifier).loadReminders();
      await ref.read(intakeNotifierProvider.notifier).loadTodayIntake();
      await ref.read(intakeNotifierProvider.notifier).loadWeeklyIntake();
      await ref.read(intakeNotifierProvider.notifier).loadMonthlyIntake();
      await ref.read(goalNotifierProvider.notifier).loadGoal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 100,
      ),
      child: const Column(
        children: [
          WaterProgressCard(),
          SizedBox(height: 16),
          QuickAddCard(),
          SizedBox(height: 16),
          WeeklyChart(),
          SizedBox(height: 16),
          GoalStreakCards(),
          SizedBox(height: 16),
          // ReminderTile(),

        ],
      ),
    );
  }
}