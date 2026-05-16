import 'package:expense_tracker/core/services/notification_service.dart';
import 'package:expense_tracker/core/services/permission_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class WaterNotificationService {
  static const _hydrationChannelId = 'water_hydration_channel';
  static const _hydrationChannelName = 'Hydration Reminders';
  static const _hydrationChannelDesc = 'Reminders to drink water';

  static const _goalChannelId = 'water_goal_channel';
  static const _goalChannelName = 'Daily Goal Reminders';
  static const _goalChannelDesc = 'Daily goal completion reminders';

  static const _morningChannelId = 'water_morning_channel';
  static const _morningChannelName = 'Morning Hydration';
  static const _morningChannelDesc = 'Morning hydration motivation';

  static const _hydrationBaseId = 3000;
  static const _morningId = 4000;
  static const _goalId = 4001;

  final NotificationService _notificationService;
  final PermissionService _permissionService;

  WaterNotificationService({
    NotificationService? notificationService,
    PermissionService? permissionService,
  })  : _notificationService =
            notificationService ?? NotificationService.instance,
        _permissionService = permissionService ?? PermissionService.instance;

  Future<void> initialize() async {
    await _notificationService.initialize();
    await _createChannels();
  }

  Future<void> requestPermissions({
    bool openSettingsOnDenied = false,
  }) async {
    await _permissionService.requestNotificationPermission();
    final exactGranted =
        await _permissionService.requestExactAlarmPermission();

    if (!exactGranted && openSettingsOnDenied) {
      await _permissionService.openExactAlarmSettings();
    }
  }

  Future<void> openExactAlarmSettings() async {
    await _permissionService.openExactAlarmSettings();
  }

  Future<void> scheduleHydrationReminders({required int intervalMinutes,}) async {
    await cancelHydrationReminders();

    if (intervalMinutes <= 0) return;

    final maxCount = (24 * 60 / intervalMinutes).floor();
    final now = tz.TZDateTime.now(tz.local);

    final scheduleMode = await _resolveScheduleMode();
    for (var i = 1; i <= maxCount; i++) {
      final scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        8,
        0,
      ).add(Duration(minutes: intervalMinutes * (i - 1)));

      await _notificationService.zonedSchedule(
        id: _hydrationBaseId + i,
        title: 'Time to drink water',
        body: 'Stay hydrated throughout the day',
        scheduledDate: scheduled,
        channelId: _hydrationChannelId,
        channelName: _hydrationChannelName,
        channelDescription: _hydrationChannelDesc,
        matchDateTimeComponents: DateTimeComponents.time,
        scheduleMode: scheduleMode,
      );
    }
  }

  Future<void> scheduleMorningReminder({
    required int hour,
    required int minute,
  }) async {
    final scheduleMode = await _resolveScheduleMode();
    await _notificationService.zonedSchedule(
      id: _morningId,
      title: 'Start your day with water 🚰',
      body: 'Hydration helps you feel energized',
      scheduledDate: _nextInstanceOfTime(hour, minute),
      channelId: _morningChannelId,
      channelName: _morningChannelName,
      channelDescription: _morningChannelDesc,
      matchDateTimeComponents: DateTimeComponents.time,
      scheduleMode: scheduleMode,
    );
  }

  Future<void> scheduleDailyGoalReminder({
    required int hour,
    required int minute,
    required int remainingMl,
  }) async {
    final remainingL = (remainingMl / 1000).toStringAsFixed(1);
    final message = remainingMl > 0
        ? 'You still need $remainingL L water 💧'
        : 'Great job hitting your goal today!';

    final scheduleMode = await _resolveScheduleMode();
    await _notificationService.zonedSchedule(
      id: _goalId,
      title: 'Daily Goal Check',
      body: message,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      channelId: _goalChannelId,
      channelName: _goalChannelName,
      channelDescription: _goalChannelDesc,
      matchDateTimeComponents: DateTimeComponents.time,
      scheduleMode: scheduleMode,
    );
  }

  Future<void> cancelHydrationReminders() async {
    for (var i = 1; i <= 1440; i++) {
      await _notificationService.cancel(id: _hydrationBaseId + i);
    }
  }

  Future<void> cancelAllWaterNotifications() async {
    await cancelHydrationReminders();
    await _notificationService.cancel(id: _morningId);
    await _notificationService.cancel(id: _goalId);
  }

  Future<void> scheduleReminder({
    required int notificationId,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required bool repeatDaily,
  }) async {
    final scheduleMode = await _resolveScheduleMode();
    await _notificationService.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      channelId: _hydrationChannelId,
      channelName: _hydrationChannelName,
      channelDescription: _hydrationChannelDesc,
      matchDateTimeComponents:
          repeatDaily ? DateTimeComponents.time : null,
      scheduleMode: scheduleMode,
    );
  }

  Future<void> cancelReminder(int notificationId) async {
    await _notificationService.cancel(id: notificationId);
  }

  Future<void> _createChannels() async {
    await _notificationService.createAndroidChannels([
      const AndroidNotificationChannel(
        _hydrationChannelId,
        _hydrationChannelName,
        description: _hydrationChannelDesc,
        importance: Importance.high,
      ),
      const AndroidNotificationChannel(
        _goalChannelId,
        _goalChannelName,
        description: _goalChannelDesc,
        importance: Importance.high,
      ),
      const AndroidNotificationChannel(
        _morningChannelId,
        _morningChannelName,
        description: _morningChannelDesc,
        importance: Importance.high,
      ),
    ]);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // IMPORTANT FIX
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    print('NOW TIME: $now');
    print('SCHEDULE TIME: $scheduled');

    return scheduled;
  }

  Future<void> testReminder() async {
    final now = tz.TZDateTime.now(tz.local);

    final scheduled = now.add(const Duration(seconds: 10));

    await _notificationService.zonedSchedule(
      id: 12345,
      title: 'Water Reminder Test',
      body: 'This should appear in 10 sec',
      scheduledDate: scheduled,
      channelId: _hydrationChannelId,
      channelName: _hydrationChannelName,
      channelDescription: _hydrationChannelDesc,
      scheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print('TEST REMINDER SET FOR: $scheduled');
  }

  Future<AndroidScheduleMode> _resolveScheduleMode() async {
    final hasExact = await _permissionService.hasExactAlarmPermission();
    return hasExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexact;
  }





}

