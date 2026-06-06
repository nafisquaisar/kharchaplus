import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static const String _prefsKey = 'is_dark_mode';
  static final ValueNotifier<bool> isDark = ValueNotifier(false);
  static SharedPreferences? _prefs;
  static bool _isBound = false;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final saved = _prefs!.getBool(_prefsKey);
    if (saved != null) {
      isDark.value = saved;
    } else {
      final brightness = WidgetsBinding
          .instance.platformDispatcher.platformBrightness;
      isDark.value =
          brightness == Brightness.dark;
    }
    _bindPersistence();
  }

  static Future<void> setDark(bool value) async {
    isDark.value = value;
    await _persist(value);
  }

  static Future<void> toggle() async {
    await setDark(!isDark.value);
  }

  static void _bindPersistence() {
    if (_isBound) return;
    _isBound = true;
    isDark.addListener(() {
      _persist(isDark.value);
    });
  }

  static Future<void> _persist(bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_prefsKey, value);
  }
}