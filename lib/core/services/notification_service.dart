import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

typedef NotificationTapCallback = void Function(String? payload);

class NotificationService {
  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize({NotificationTapCallback? onTap}) async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        onTap?.call(response.payload);
      },
    );

    await _configureTimeZones();

    _initialized = true;
  }

  Future<void> createAndroidChannels(
    List<AndroidNotificationChannel> channels,
  ) async {
    final android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) return;

    for (final channel in channels) {
      await android.createNotificationChannel(channel);
    }
  }

  Future<void> zonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required String channelId,
    required String channelName,
    required String channelDescription,
    AndroidScheduleMode scheduleMode =
        AndroidScheduleMode.exactAllowWhileIdle,
    DateTimeComponents? matchDateTimeComponents,
    String? payload,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: matchDateTimeComponents,
      payload: payload,
    );
  }

  Future<void> cancel({required int id}) async {
    await _plugin.cancel(id: id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> _configureTimeZones() async {
    if (_isTimeZoneReady()) return;

    tz.initializeTimeZones();
    final tzName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzName));
  }

  bool _isTimeZoneReady() {
    try {
      tz.local;
      return true;
    } catch (_) {
      return false;
    }
  }
}
