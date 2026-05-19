import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:isar/isar.dart';

import '../../../Track/WaterTracking/data/models/water_goal_model.dart';
import '../../../Track/WaterTracking/data/models/water_intake_model.dart';
import '../../services/profile_monthly_goal_service.dart';
import '../../services/profile_streak_service.dart';
import '../datasource/profile_stats_local_data_source.dart';
import '../datasource/profile_stats_remote_data_source.dart';
import '../models/profile_stats_model.dart';
import 'profile_stats_repository.dart';

class ProfileStatsRepositoryImpl implements ProfileStatsRepository {
  final ProfileStatsLocalDataSource _local;
  final ProfileStatsRemoteDataSource _remote;
  final ProfileStreakService _service;
  final ProfileMonthlyGoalService _monthlyGoalService;
  final Isar _isar;

  ProfileStatsRepositoryImpl(
    this._local,
    this._remote,
    this._isar, {
    ProfileStreakService? service,
    ProfileMonthlyGoalService? monthlyGoalService,
  }) : _service = service ?? ProfileStreakService(),
        _monthlyGoalService =
            monthlyGoalService ?? ProfileMonthlyGoalService();

  @override
  Stream<ProfileStatsModel?> watchStats(String uid) {
    return _local.watchByUserId(uid);
  }

  @override
  Future<ProfileStatsModel> recordAppOpen(String uid, {DateTime? now}) async {
    final reference = now ?? DateTime.now();
    final existing = await _local.getByUserId(uid);

    final currentState = existing == null
        ? null
        : StreakState(
            currentStreak: existing.currentStreak,
            lastOpenedAt: existing.lastOpenedAt,
            lastOpenedDayKey: existing.lastOpenedDayKey,
            timezoneOffsetMinutes: existing.timezoneOffsetMinutes,
          );

    final result = _service.update(
      now: reference,
      current: currentState,
    );

    final shouldUpdateLocal = result.didChange || existing == null;

    final model = existing ?? ProfileStatsModel();
    model.userId = uid;
    model.currentStreak = result.state.currentStreak;
    model.lastOpenedDayKey = result.state.lastOpenedDayKey;
    model.lastOpenedAt = result.state.lastOpenedAt;
    model.timezoneOffsetMinutes = result.state.timezoneOffsetMinutes;

    if (existing == null) {
      model.monthlyGoalDaysCompleted = 0;
      model.monthlyGoalDaysInMonth = 0;
      model.monthlyGoalPercent = 0;
    }

    model.updatedAt = reference;

    if (shouldUpdateLocal) {
      model.isSynced = false;
      await _local.upsert(model);
    }

    await recomputeMonthlyGoal(uid, now: reference);

    if (!model.isSynced) {
      await _sync(model, allowThrow: false);
    }

    return model;
  }

  @override
  Future<void> recomputeMonthlyGoal(String uid, {DateTime? now}) async {
    final reference = now ?? DateTime.now();
    final existing = await _local.getByUserId(uid);
    if (existing == null) {
      return;
    }

    final monthStart = DateTime(reference.year, reference.month, 1);
    final monthEnd = DateTime(reference.year, reference.month + 1, 1);

    final intake = await _isar.waterIntakeModels
        .filter()
        .userIdEqualTo(uid)
        .dateTimeBetween(monthStart, monthEnd)
        .findAll();

    final intakeByDay = <int, int>{};
    for (final item in intake) {
      final date = item.dateTime;
      final key = date.year * 10000 + date.month * 100 + date.day;
      intakeByDay[key] = (intakeByDay[key] ?? 0) + item.amountMl;
    }

    final goalModel = await _latestWaterGoal(uid);
    final dailyGoal = goalModel?.dailyGoalMl ?? 0;

    final result = _monthlyGoalService.calculate(
      intakeByDay: intakeByDay,
      dailyGoalMl: dailyGoal,
      now: reference,
    );

    existing.monthlyGoalDaysCompleted = result.daysCompleted;
    existing.monthlyGoalDaysInMonth = result.daysInMonth;
    existing.monthlyGoalPercent = result.percent;
    existing.updatedAt = reference;
    existing.isSynced = false;

    await _local.upsert(existing);

    await _sync(existing, allowThrow: false);
  }

  @override
  Stream<void> watchMonthlyGoalChanges(String uid) {
    final intakeStream = _isar.waterIntakeModels
        .filter()
        .userIdEqualTo(uid)
        .watch(fireImmediately: true)
        .map((_) => null);

    final goalStream = _isar.waterGoalModels
        .filter()
        .userIdEqualTo(uid)
        .watch(fireImmediately: true)
        .map((_) => null);

    final controller = StreamController<void>.broadcast();
    StreamSubscription? intakeSub;
    StreamSubscription? goalSub;

    controller.onListen = () {
      intakeSub = intakeStream.listen((_) => controller.add(null));
      goalSub = goalStream.listen((_) => controller.add(null));
    };

    controller.onCancel = () async {
      await intakeSub?.cancel();
      await goalSub?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> syncPending(String uid) async {
    final existing = await _local.getByUserId(uid);
    if (existing == null || existing.isSynced) {
      return;
    }

    await _sync(existing, allowThrow: true);
  }

  Future<void> _sync(ProfileStatsModel model, {required bool allowThrow}) async {
    try {
      await _remote.upsertStats(
        uid: model.userId,
        currentStreak: model.currentStreak,
        lastOpenedAt: model.lastOpenedAt,
        lastOpenedDayKey: model.lastOpenedDayKey,
        timezoneOffsetMinutes: model.timezoneOffsetMinutes,
        monthlyGoalDaysCompleted: model.monthlyGoalDaysCompleted,
        monthlyGoalDaysInMonth: model.monthlyGoalDaysInMonth,
        monthlyGoalPercent: model.monthlyGoalPercent,
        updatedAt: model.updatedAt,
      );

      model.isSynced = true;
      model.lastSyncedAt = DateTime.now();
      await _local.upsert(model);
    } catch (e, stack) {
      debugPrint('ProfileStatsRepository: sync failed $e');
      debugPrint('$stack');
      if (allowThrow) {
        rethrow;
      }
    }
  }

  Future<WaterGoalModel?> _latestWaterGoal(String uid) async {
    final items = await _isar.waterGoalModels
        .filter()
        .userIdEqualTo(uid)
        .sortByUpdatedAtDesc()
        .findAll();

    if (items.isEmpty) {
      return null;
    }
    return items.first;
  }
}
