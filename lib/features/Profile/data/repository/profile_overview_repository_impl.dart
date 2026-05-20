import 'package:flutter/foundation.dart';

import '../../domain/repository/profile_overview_repository.dart';
import '../../services/monthly_overview_service.dart';
import '../datasource/profile_overview_local_data_source.dart';
import '../datasource/profile_overview_remote_data_source.dart';
import '../models/profile_overview_model.dart';

class ProfileOverviewRepositoryImpl implements ProfileOverviewRepository {
  final ProfileOverviewRemoteDataSource _remote;
  final ProfileOverviewLocalDataSource _local;
  final MonthlyOverviewService _service;
  final Duration _cacheTtl;

  ProfileOverviewRepositoryImpl({
    required ProfileOverviewRemoteDataSource remote,
    required ProfileOverviewLocalDataSource local,
    MonthlyOverviewService? service,
    Duration cacheTtl = const Duration(minutes: 15),
  })  : _remote = remote,
        _local = local,
        _service = service ?? const MonthlyOverviewService(),
        _cacheTtl = cacheTtl;

  @override
  Future<ProfileOverviewModel?> getCachedOverview(String uid) async {
    final cached = await _local.getCachedOverview(uid.trim());
    return cached?.model;
  }

  @override
  Future<void> clearCache(String uid) {
    return _local.clearCache(uid.trim());
  }

  @override
  Future<ProfileOverviewModel> getOverview(
    String uid, {
    bool forceRefresh = false,
  }) async {
    final userId = uid.trim();
    if (userId.isEmpty) {
      throw const ProfileOverviewRepositoryException(
        'User id is required to fetch profile overview.',
      );
    }

    final cachedEntry = await _local.getCachedOverview(userId);

    if (!forceRefresh) {
      if (cachedEntry != null && !_isExpired(cachedEntry.cachedAt)) {
        return cachedEntry.model;
      }
    }

    final now = DateTime.now();
    final currentMonth = _monthStart(now);
    final previousMonth = _monthStart(DateTime(now.year, now.month - 1, 1));

    try {
      final currentExpenseIncomeFuture =
          _remote.getMonthlyExpenseIncome(userId, currentMonth);
      final previousExpenseIncomeFuture =
          _remote.getMonthlyExpenseIncome(userId, previousMonth);
      final currentElectricityFuture =
          _remote.getMonthlyElectricityUnits(userId, currentMonth);
      final previousElectricityFuture =
          _remote.getMonthlyElectricityUnits(userId, previousMonth);
      final currentWaterFuture =
          _local.getMonthlyWaterIntakeLiters(userId, currentMonth);
      final previousWaterFuture =
          _local.getMonthlyWaterIntakeLiters(userId, previousMonth);

      final currentExpenseIncome = await currentExpenseIncomeFuture;
      final previousExpenseIncome = await previousExpenseIncomeFuture;
      final currentElectricity = await currentElectricityFuture;
      final previousElectricity = await previousElectricityFuture;
      final currentWater = await currentWaterFuture;
      final previousWater = await previousWaterFuture;

      final model = _service.buildOverview(
        currentExpense: currentExpenseIncome.totalExpense,
        previousExpense: previousExpenseIncome.totalExpense,
        currentIncome: currentExpenseIncome.totalIncome,
        previousIncome: previousExpenseIncome.totalIncome,
        currentElectricityUnits: currentElectricity,
        previousElectricityUnits: previousElectricity,
        currentWaterLiters: currentWater,
        previousWaterLiters: previousWater,
      );

      await _local.cacheOverview(userId, model, cachedAt: now);
      return model;
    } catch (e, stack) {
      debugPrint('ProfileOverviewRepository: fetch failed for "$userId": $e');
      debugPrint('$stack');

      if (cachedEntry != null) {
        debugPrint(
          'ProfileOverviewRepository: returning stale cache for "$userId".',
        );
        return cachedEntry.model;
      }

      throw ProfileOverviewRepositoryException(
        'Failed to build profile overview for "$userId".',
        cause: e,
        stackTrace: stack,
      );
    }
  }

  bool _isExpired(DateTime cachedAt) {
    return DateTime.now().difference(cachedAt) > _cacheTtl;
  }

  DateTime _monthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
}

class ProfileOverviewRepositoryException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const ProfileOverviewRepositoryException(
    this.message, {
    this.cause,
    this.stackTrace,
  });

  @override
  String toString() {
    if (cause == null) {
      return message;
    }
    return '$message Cause: $cause';
  }
}
