import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasource/local/shared_pref/water_pref_ds.dart';
import '../../../services/water_notification_service.dart';
import '../../providers/analytics/water_analytics_provider.dart';
import '../../providers/goal/goal_provider.dart';

class WaterNotificationState {
  final bool enabled;
  final int intervalMinutes;
  final bool isLoading;
  final String? error;

  const WaterNotificationState({
    required this.enabled,
    required this.intervalMinutes,
    required this.isLoading,
    required this.error,
  });

  WaterNotificationState copyWith({
    bool? enabled,
    int? intervalMinutes,
    bool? isLoading,
    String? error,
  }) {
    return WaterNotificationState(
      enabled: enabled ?? this.enabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory WaterNotificationState.initial() {
    return const WaterNotificationState(
      enabled: false,
      intervalMinutes: 120,
      isLoading: false,
      error: null,
    );
  }
}

final waterPrefDataSourceProvider = Provider<WaterPrefDataSource>(
  (ref) => WaterPrefDataSource(),
);

final waterNotificationServiceProvider = Provider<WaterNotificationService>(
  (ref) => WaterNotificationService(),
);

final waterNotificationControllerProvider =
    StateNotifierProvider<WaterNotificationController, WaterNotificationState>(
  (ref) => WaterNotificationController(
    ref: ref,
    prefs: ref.read(waterPrefDataSourceProvider),
    service: ref.read(waterNotificationServiceProvider),
  )..initialize(),
);

class WaterNotificationController
    extends StateNotifier<WaterNotificationState> {
  final Ref ref;
  final WaterPrefDataSource prefs;
  final WaterNotificationService service;

  WaterNotificationController({
    required this.ref,
    required this.prefs,
    required this.service,
  }) : super(WaterNotificationState.initial()) {
    _listenToGoalChanges();
    _listenToAnalyticsChanges();
  }

  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await service.initialize();
      await service.requestPermissions();

      final enabled = await prefs.getReminderEnabled();
      final interval = await prefs.getIntervalMinutes();

      state = state.copyWith(
        enabled: enabled,
        intervalMinutes: interval,
        isLoading: false,
        error: null,
      );

      if (enabled) {
        await _scheduleAll();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleReminders(bool enabled) async {
    if (enabled == state.enabled) return;

    state = state.copyWith(isLoading: true, error: null);

    await prefs.setReminderEnabled(enabled);

    if (enabled) {
      await _scheduleAll();
    } else {
      await service.cancelAllWaterNotifications();
    }

    state = state.copyWith(isLoading: false, enabled: enabled);
  }

  Future<void> updateInterval(int minutes) async {
    if (minutes <= 0) return;

    state = state.copyWith(isLoading: true, error: null);

    await prefs.setIntervalMinutes(minutes);

    state = state.copyWith(intervalMinutes: minutes, isLoading: false);

    if (state.enabled) {
      await _scheduleAll();
    }
  }

  Future<void> _scheduleAll() async {
    final interval = state.intervalMinutes;
    final morningTime = await prefs.getMorningTime();
    final goalTime = await prefs.getGoalCheckTime();
    final remainingMl = ref.read(waterIntakeAnalyticsProvider).data.remainingMl;

    await service.scheduleHydrationReminders(intervalMinutes: interval);
    await service.scheduleMorningReminder(
      hour: morningTime.hour,
      minute: morningTime.minute,
    );
    await service.scheduleDailyGoalReminder(
      hour: goalTime.hour,
      minute: goalTime.minute,
      remainingMl: remainingMl,
    );
  }

  void _listenToGoalChanges() {
    ref.listen(goalNotifierProvider, (_, next) {
      final goal = next.goal;
      if (goal == null) return;

      if (goal.reminderEnabled != state.enabled) {
        toggleReminders(goal.reminderEnabled);
      }
    });
  }

  void _listenToAnalyticsChanges() {
    ref.listen(waterIntakeAnalyticsProvider, (_, __) {
      if (state.enabled) {
        _scheduleAll();
      }
    });
  }
}


