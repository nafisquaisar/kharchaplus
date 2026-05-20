import 'dart:async';
import 'overview_repository.dart';
import '../models/overview_summary_model.dart';
import '../datasource/overview_remote_data_source.dart';
import '../datasource/overview_local_data_source.dart';

/// Implementation of OverviewRepository combining local cache and remote data
/// Follows single responsibility and dependency injection principles
class OverviewRepositoryImpl implements OverviewRepository {
  final OverviewLocalDataSource _localDataSource;
  final OverviewRemoteDataSource _remoteDataSource;

  /// Cache timers to prevent excessive Firestore reads
  final Map<String, Timer> _refreshTimers = {};

  /// Stream controllers for better cache invalidation
  final Map<String, StreamController<OverviewSummaryModel?>> _monthControllers =
      {};

  OverviewRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );

  @override
  Stream<OverviewSummaryModel?> watchCurrentMonthOverview(String userId) {
    final now = DateTime.now();
    final month = _formatMonth(now);
    return watchMonthOverview(userId, month);
  }

  @override
  Stream<OverviewSummaryModel?> watchMonthOverview(
    String userId,
    String month,
  ) {
    final key = '${userId}_$month';

    // Create or return existing controller
    _monthControllers[key] ??= StreamController<OverviewSummaryModel?>.broadcast();

    // Start background refresh if not already running
    _startBackgroundRefresh(userId, month);

    // Return the remote stream (which will update the controller)
    return _remoteDataSource.watchMonthOverview(userId, month).map((overview) {
      // Save to local cache on update
      if (overview != null) {
        _localDataSource.saveOverview(overview);
      }
      _monthControllers[key]?.add(overview);
      return overview;
    });
  }

  @override
  Stream<List<OverviewSummaryModel>> watchOverviewHistory(
    String userId,
    int months,
  ) {
    return _remoteDataSource.watchOverviewHistory(userId, months).map((history) {
      // Save to local cache
      _localDataSource.saveOverviews(history);
      return history;
    });
  }

  @override
  Future<OverviewSummaryModel> computeCurrentMonthOverview(String userId) {
    final now = DateTime.now();
    final month = _formatMonth(now);
    return computeMonthOverview(userId, month);
  }

  @override
  Future<OverviewSummaryModel> computeMonthOverview(
    String userId,
    String month,
  ) async {
    try {
      final overview = await _remoteDataSource.computeMonthOverview(
        userId,
        month,
      );

      // Cache locally
      await _localDataSource.saveOverview(overview);

      // Update stream controller
      final key = '${userId}_$month';
      _monthControllers[key]?.add(overview);

      return overview;
    } catch (e) {
      print('❌ OverviewRepositoryImpl.computeMonthOverview error: $e');
      rethrow;
    }
  }

  @override
  Future<void> refreshOverview(String userId, String month) async {
    try {
      await computeMonthOverview(userId, month);
    } catch (e) {
      print('❌ OverviewRepositoryImpl.refreshOverview error: $e');
      // Don't rethrow - allow graceful degradation
    }
  }

  @override
  Future<void> syncPending(String userId) async {
    try {
      final now = DateTime.now();
      final month = _formatMonth(now);
      await computeMonthOverview(userId, month);
    } catch (e) {
      print('❌ OverviewRepositoryImpl.syncPending error: $e');
    }
  }

  @override
  Future<void> clearCache(String userId) async {
    try {
      // Clear local cache
      await _localDataSource.clearAll();

      // Stop any running refresh timers
      for (var key in _refreshTimers.keys.where((k) => k.startsWith(userId))) {
        _refreshTimers[key]?.cancel();
        _refreshTimers.remove(key);
      }

      // Clear stream controllers
      for (var key in _monthControllers.keys.where((k) => k.startsWith(userId))) {
        _monthControllers[key]?.close();
        _monthControllers.remove(key);
      }
    } catch (e) {
      print('❌ OverviewRepositoryImpl.clearCache error: $e');
    }
  }

  /// ===== PRIVATE HELPER METHODS =====

  /// Start background refresh every 5 minutes to keep data fresh
  void _startBackgroundRefresh(String userId, String month) {
    final key = '${userId}_${month}_refresh';

    // Don't start if already running
    if (_refreshTimers.containsKey(key)) {
      return;
    }

    // Refresh every 5 minutes
    _refreshTimers[key] = Timer.periodic(
      const Duration(minutes: 5),
      (_) => refreshOverview(userId, month),
    );

    // Clean up timer on next month
    Future.delayed(const Duration(hours: 24), () {
      _refreshTimers[key]?.cancel();
      _refreshTimers.remove(key);
    });
  }

  /// Dispose resources
  void dispose() {
    for (var timer in _refreshTimers.values) {
      timer.cancel();
    }
    _refreshTimers.clear();

    for (var controller in _monthControllers.values) {
      controller.close();
    }
    _monthControllers.clear();
  }

  /// Format month as "YYYY-MM"
  String _formatMonth(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }
}

