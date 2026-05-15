import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterPrefDataSource {
  static const _keyReminderEnabled = 'water_reminder_enabled';
  static const _keyIntervalMinutes = 'water_reminder_interval_minutes';
  static const _keyMorningHour = 'water_morning_hour';
  static const _keyMorningMinute = 'water_morning_minute';
  static const _keyGoalHour = 'water_goal_hour';
  static const _keyGoalMinute = 'water_goal_minute';

  Future<bool> getReminderEnabled() async {
	final prefs = await SharedPreferences.getInstance();
	return prefs.getBool(_keyReminderEnabled) ?? false;
  }

  Future<int> getIntervalMinutes() async {
	final prefs = await SharedPreferences.getInstance();
	return prefs.getInt(_keyIntervalMinutes) ?? 120;
  }

  Future<void> setReminderEnabled(bool value) async {
	final prefs = await SharedPreferences.getInstance();
	await prefs.setBool(_keyReminderEnabled, value);
  }

  Future<void> setIntervalMinutes(int value) async {
	final prefs = await SharedPreferences.getInstance();
	await prefs.setInt(_keyIntervalMinutes, value);
  }

  Future<TimeOfDay> getMorningTime() async {
	final prefs = await SharedPreferences.getInstance();
	final hour = prefs.getInt(_keyMorningHour) ?? 8;
	final minute = prefs.getInt(_keyMorningMinute) ?? 0;
	return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> setMorningTime(TimeOfDay time) async {
	final prefs = await SharedPreferences.getInstance();
	await prefs.setInt(_keyMorningHour, time.hour);
	await prefs.setInt(_keyMorningMinute, time.minute);
  }

  Future<TimeOfDay> getGoalCheckTime() async {
	final prefs = await SharedPreferences.getInstance();
	final hour = prefs.getInt(_keyGoalHour) ?? 20;
	final minute = prefs.getInt(_keyGoalMinute) ?? 0;
	return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> setGoalCheckTime(TimeOfDay time) async {
	final prefs = await SharedPreferences.getInstance();
	await prefs.setInt(_keyGoalHour, time.hour);
	await prefs.setInt(_keyGoalMinute, time.minute);
  }
}

