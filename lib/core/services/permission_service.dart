import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService._internal();

  static final PermissionService instance = PermissionService._internal();

  Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.notification.status;
    if (status.isGranted) return true;

    final result = await Permission.notification.request();
    return result.isGranted;
  }

  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.scheduleExactAlarm.status;
    if (status.isGranted) return true;

    final result = await Permission.scheduleExactAlarm.request();
    return result.isGranted;
  }

  Future<bool> hasExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    return Permission.scheduleExactAlarm.isGranted;
  }

  Future<void> openExactAlarmSettings() async {
    if (!Platform.isAndroid) return;

    try {
      final packageName = (await PackageInfo.fromPlatform()).packageName;
      final intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        data: 'package:$packageName',
      );

      await intent.launch();
    } catch (_) {
      await openAppSettings();
    }
  }
}

