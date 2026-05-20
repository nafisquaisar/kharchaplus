import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Track/WaterTracking/data/models/water_intake_model.dart';
import '../models/profile_overview_model.dart';

@immutable
class ProfileOverviewCacheEntry {
  final ProfileOverviewModel model;
  final DateTime cachedAt;

  const ProfileOverviewCacheEntry({
    required this.model,
    required this.cachedAt,
  });
}

abstract class ProfileOverviewLocalDataSource {
  Future<ProfileOverviewCacheEntry?> getCachedOverview(String uid);

  Future<void> cacheOverview(String uid, ProfileOverviewModel model,
      {DateTime? cachedAt});

  Future<void> clearCache(String uid);

  Future<double> getMonthlyWaterIntakeLiters(String uid, DateTime month);
}

class ProfileOverviewLocalDataSourceImpl
    implements ProfileOverviewLocalDataSource {
  static const int _cacheSchemaVersion = 1;
  static const String _cacheKeyPrefix = 'profile_overview_cache_v';
  static const String _cacheTimeKeyPrefix = 'profile_overview_cache_time_v';

  final SharedPreferences _prefs;
  final Isar _isar;

  ProfileOverviewLocalDataSourceImpl({
    required SharedPreferences prefs,
    required Isar isar,
  })  : _prefs = prefs,
        _isar = isar;

  @override
  Future<ProfileOverviewCacheEntry?> getCachedOverview(String uid) async {
    final jsonKey = _cacheJsonKey(uid);
    final timeKey = _cacheTimeKey(uid);

    final jsonString = _prefs.getString(jsonKey);
    final cachedAtMillis = _prefs.getInt(timeKey);
    if (jsonString == null || cachedAtMillis == null) {
      return null;
    }

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = ProfileOverviewModel.fromJson(map);
      return ProfileOverviewCacheEntry(
        model: model,
        cachedAt: DateTime.fromMillisecondsSinceEpoch(cachedAtMillis),
      );
    } catch (error, stackTrace) {
      debugPrint(
          'ProfileOverviewLocalDataSource: invalid cache payload: $error');
      debugPrint('$stackTrace');
      await _prefs.remove(jsonKey);
      await _prefs.remove(timeKey);
      return null;
    }
  }

  @override
  Future<void> cacheOverview(String uid, ProfileOverviewModel model,
      {DateTime? cachedAt}) async {
    try {
      final payload = jsonEncode(model.toJson());
      final time = cachedAt ?? DateTime.now();

      await _prefs.setString(_cacheJsonKey(uid), payload);
      await _prefs.setInt(_cacheTimeKey(uid), time.millisecondsSinceEpoch);
    } catch (error) {
      throw ProfileOverviewLocalDataSourceException(
        'Failed to cache profile overview for "$uid".',
        cause: error,
      );
    }
  }

  @override
  Future<void> clearCache(String uid) async {
    await _prefs.remove(_cacheJsonKey(uid));
    await _prefs.remove(_cacheTimeKey(uid));
  }

  @override
  Future<double> getMonthlyWaterIntakeLiters(String uid, DateTime month) async {
    final monthStart = DateTime(month.year, month.month, 1);
    final monthEnd = DateTime(month.year, month.month + 1, 1);

    try {
      final intake = await _isar.waterIntakeModels
          .filter()
          .userIdEqualTo(uid)
          .and()
          .isDeletedEqualTo(false)
          .and()
          .dateTimeBetween(
            monthStart,
            monthEnd,
            includeUpper: false,
          )
          .findAll();

      if (intake.isEmpty) {
        return 0.0;
      }

      final totalMl = intake.fold<int>(0, (sum, item) => sum + item.amountMl);
      return totalMl / 1000.0;
    } on IsarError catch (error) {
      throw ProfileOverviewLocalDataSourceException(
        'Failed to read monthly water intake for "$uid".',
        cause: error,
      );
    }
  }

  String _cacheJsonKey(String uid) {
    return '$_cacheKeyPrefix$_cacheSchemaVersion' '_$uid';
  }

  String _cacheTimeKey(String uid) {
    return '$_cacheTimeKeyPrefix$_cacheSchemaVersion' '_$uid';
  }
}

class ProfileOverviewLocalDataSourceException implements Exception {
  final String message;
  final Object? cause;

  const ProfileOverviewLocalDataSourceException(
    this.message, {
    this.cause,
  });

  @override
  String toString() {
    if (cause == null) {
      return message;
    }
    return '$message Cause: $cause';
  }
}
