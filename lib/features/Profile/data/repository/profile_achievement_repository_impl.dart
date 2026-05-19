import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Track/WaterTracking/data/models/water_goal_model.dart';
import '../../../Track/WaterTracking/data/models/water_intake_model.dart';
import '../../../Home/data/models/electricity_tracking_model.dart';
import '../../services/achievement_catalog.dart';
import '../../services/achievement_engine.dart';
import '../datasource/profile_achievement_local_data_source.dart';
import '../datasource/profile_achievement_remote_data_source.dart';
import '../models/profile_achievement_model.dart';
import '../repository/profile_achievement_repository.dart';
import '../datasource/profile_stats_local_data_source.dart';

class ProfileAchievementRepositoryImpl
    implements ProfileAchievementRepository {
  final ProfileAchievementLocalDataSource _local;
  final ProfileAchievementRemoteDataSource _remote;
  final ProfileStatsLocalDataSource _statsLocal;
  final AchievementEngine _engine;
  final Isar _isar;

  ProfileAchievementRepositoryImpl(
    this._local,
    this._remote,
    this._statsLocal,
    this._isar, {
    AchievementEngine? engine,
  }) : _engine = engine ?? AchievementEngine();

  @override
  Stream<List<ProfileAchievementModel>> watchAchievements(String uid) {
    return _local.watchAll(uid);
  }

  @override
  Future<List<ProfileAchievementModel>> getAchievements(String uid) async {
    return _local.getAll(uid);
  }

  @override
  Future<void> evaluateAndSync(String uid, {DateTime? now}) async {
    final reference = now ?? DateTime.now();

    await _ensureSeeded(uid);

    final snapshot = await _buildSnapshot(uid, reference);
    final items = await _local.getAll(uid);
    final byId = {for (final item in items) item.achievementId: item};

    final updated = <ProfileAchievementModel>[];

    for (final definition in AchievementCatalog.definitions) {
      final existing = byId[definition.id];
      if (existing == null) {
        continue;
      }

      final progress = _engine.evaluate(definition, snapshot);
      final shouldUnlock = progress.isUnlocked;
      final wasUnlocked = existing.isUnlocked;

      final didChange =
          existing.progress != progress.progress || existing.goal != progress.goal ||
              existing.isUnlocked != shouldUnlock;

      if (!didChange) {
        continue;
      }

      existing.progress = progress.progress;
      existing.goal = progress.goal;
      existing.isUnlocked = shouldUnlock;
      if (shouldUnlock && !wasUnlocked) {
        existing.unlockedAt = reference;
      }
      existing.updatedAt = reference;
      existing.isSynced = false;

      updated.add(existing);
    }

    if (updated.isNotEmpty) {
      await _local.upsertAll(updated);
    }

    await _syncPending(uid);
  }

  @override
  Future<void> syncPending(String uid) async {
    await _syncPending(uid);
  }

  @override
  Future<void> refreshFromRemote(String uid) async {
    try {
      final remoteItems = await _remote.fetchAchievements(uid);
      if (remoteItems.isEmpty) {
        return;
      }

      final localItems = await _local.getAll(uid);
      final localById = {for (final item in localItems) item.achievementId: item};
      final merged = <ProfileAchievementModel>[];

      for (final data in remoteItems) {
        final id = data['id'] as String?;
        if (id == null || id.isEmpty) {
          continue;
        }

        final local = localById[id];
        if (local == null) {
          continue;
        }

        final isUnlocked = (data['isUnlocked'] as bool?) ?? false;
        final progress = (data['progress'] as num?)?.toDouble();
        final goal = (data['goal'] as num?)?.toDouble();

        var didChange = false;
        if (isUnlocked && !local.isUnlocked) {
          local.isUnlocked = true;
          local.unlockedAt = _parseDate(data['unlockedAt']) ?? local.unlockedAt;
          didChange = true;
        }
        if (progress != null && progress != local.progress) {
          local.progress = progress;
          didChange = true;
        }
        if (goal != null && goal != local.goal) {
          local.goal = goal;
          didChange = true;
        }

        if (didChange) {
          local.updatedAt = DateTime.now();
          local.isSynced = true;
          local.lastSyncedAt = DateTime.now();
          merged.add(local);
        }
      }

      if (merged.isNotEmpty) {
        await _local.upsertAll(merged);
      }
    } catch (e, stack) {
      debugPrint('ProfileAchievementRepository: remote refresh failed $e');
      debugPrint('$stack');
    }
  }

  Future<void> _ensureSeeded(String uid) async {
    final existing = await _local.getAll(uid);
    final existingIds = existing.map((item) => item.achievementId).toSet();

    final seed = <ProfileAchievementModel>[];
    for (final definition in AchievementCatalog.definitions) {
      if (existingIds.contains(definition.id)) {
        continue;
      }
      final model = ProfileAchievementModel()
        ..userId = uid
        ..achievementId = definition.id
        ..key = _key(uid, definition.id)
        ..category = definition.category.name
        ..title = definition.title
        ..description = definition.description
        ..iconKey = definition.iconKey
        ..progress = 0
        ..goal = definition.goal
        ..isUnlocked = false
        ..updatedAt = DateTime.now()
        ..isSynced = false;
      seed.add(model);
    }

    if (seed.isNotEmpty) {
      await _local.upsertAll(seed);
    }
  }

  Future<void> _syncPending(String uid) async {
    final items = await _local.getAll(uid);
    final pending = items.where((item) => !item.isSynced).toList();
    if (pending.isEmpty) {
      return;
    }

    for (final item in pending) {
      try {
        await _remote.upsertAchievement(
          uid: uid,
          achievementId: item.achievementId,
          payload: {
            'achievementId': item.achievementId,
            'category': item.category,
            'title': item.title,
            'description': item.description,
            'iconKey': item.iconKey,
            'progress': item.progress,
            'goal': item.goal,
            'isUnlocked': item.isUnlocked,
            'unlockedAt': item.unlockedAt,
            'updatedAtLocal': item.updatedAt,
          },
        );

        item.isSynced = true;
        item.lastSyncedAt = DateTime.now();
        await _local.upsertAll([item]);
      } catch (e, stack) {
        debugPrint('ProfileAchievementRepository: sync failed $e');
        debugPrint('$stack');
      }
    }
  }

  Future<AchievementDataSnapshot> _buildSnapshot(
    String uid,
    DateTime now,
  ) async {
    final stats = await _statsLocal.getByUserId(uid);
    final currentStreak = stats?.currentStreak ?? 0;

    final waterMetrics = await _buildWaterMetrics(uid, now);
    final electricityUnits = await _buildElectricityUnits();

    var totalTransactions = 0;
    var remainingBalance = 0.0;

    try {
      final summary = await _remote.fetchExpenseSummary(uid);
      if (summary != null) {
        totalTransactions = (summary['totalTransactions'] as num?)?.toInt() ?? 0;
        remainingBalance =
            (summary['remainingBalance'] as num?)?.toDouble() ?? 0.0;
      }
    } catch (e, stack) {
      debugPrint('ProfileAchievementRepository: summary fetch failed $e');
      debugPrint('$stack');
    }

    return AchievementDataSnapshot(
      currentStreak: currentStreak,
      waterWeeklyDays: waterMetrics.weeklyDays,
      waterMonthlyGoalPercent: waterMetrics.monthlyPercent,
      electricityUnits: electricityUnits,
      totalTransactions: totalTransactions,
      remainingBalance: remainingBalance,
    );
  }

  Future<_WaterMetrics> _buildWaterMetrics(String uid, DateTime now) async {
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1);

    final intake = await _isar.waterIntakeModels
        .filter()
        .userIdEqualTo(uid)
        .dateTimeBetween(monthStart, monthEnd)
        .findAll();

    var monthlyTotal = 0;
    for (final item in intake) {
      monthlyTotal += item.amountMl;
    }

    final dayCount = now.day > 0 ? now.day : 1;
    final goalModel = await _latestWaterGoal(uid);
    final dailyGoal = goalModel?.dailyGoalMl ?? 0;
    final monthlyGoal = dailyGoal * dayCount;

    final monthlyPercent = monthlyGoal == 0
        ? 0.0
        : (monthlyTotal / monthlyGoal).clamp(0.0, 1.5);

    final weeklyStart = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));
    final weeklyEnd = DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 1));
    final weeklyIntake = await _isar.waterIntakeModels
        .filter()
        .userIdEqualTo(uid)
        .dateTimeBetween(weeklyStart, weeklyEnd)
        .findAll();

    final uniqueDays = <int>{};
    for (final item in weeklyIntake) {
      final date = item.dateTime;
      uniqueDays.add(date.year * 10000 + date.month * 100 + date.day);
    }

    return _WaterMetrics(
      weeklyDays: uniqueDays.length,
      monthlyPercent: monthlyPercent,
    );
  }

  Future<int> _buildElectricityUnits() async {
    final items = await _isar.electricityTrackingHomeModels
        .where()
        .sortByUpdatedAtDesc()
        .findAll();

    if (items.isEmpty) {
      return 0;
    }

    return items.first.consumedUnits;
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

  String _key(String uid, String id) {
    return '$uid::$id';
  }

  DateTime? _parseDate(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }
}

class _WaterMetrics {
  final int weeklyDays;
  final double monthlyPercent;

  const _WaterMetrics({
    required this.weeklyDays,
    required this.monthlyPercent,
  });
}
