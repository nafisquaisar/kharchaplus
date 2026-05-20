import 'package:isar/isar.dart';
import '../models/overview_summary_model.dart';

/// Local cache data source using Isar
/// Provides fast offline access to overview data
abstract class OverviewLocalDataSource {
  /// Watch local overview for current month
  Stream<OverviewSummaryModel?> watchCurrentMonthOverview(String userId);

  /// Get cached overview for specific month
  Stream<OverviewSummaryModel?> watchMonthOverview(
    String userId,
    String month,
  );

  /// Get overview history from cache
  Stream<List<OverviewSummaryModel>> watchOverviewHistory(
    String userId,
    int months,
  );

  /// Save overview to local cache
  Future<void> saveOverview(OverviewSummaryModel overview);

  /// Save batch of overviews
  Future<void> saveOverviews(List<OverviewSummaryModel> overviews);

  /// Clear all cached overview data
  Future<void> clearAll();

  /// Clear specific month cache
  Future<void> clearMonth(String userId, String month);
}

/// Implementation of OverviewLocalDataSource using Isar
class OverviewLocalDataSourceImpl implements OverviewLocalDataSource {
  final Isar _isar;

  const OverviewLocalDataSourceImpl(this._isar);

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
    // Note: This requires an Isar model implementation
    // For now, returning empty stream as placeholder
    // In a real scenario, we'd have an OverviewSummary Isar collection
    return Stream.value(null);
  }

  @override
  Stream<List<OverviewSummaryModel>> watchOverviewHistory(
    String userId,
    int months,
  ) {
    // Placeholder for history stream
    return Stream.value([]);
  }

  @override
  Future<void> saveOverview(OverviewSummaryModel overview) async {
    try {
      // In production, this would write to an Isar collection
      // For now, this is a placeholder
      print('✅ OverviewLocalDataSourceImpl.saveOverview: ${overview.id}');
    } catch (e) {
      print('❌ OverviewLocalDataSourceImpl.saveOverview error: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveOverviews(List<OverviewSummaryModel> overviews) async {
    try {
      for (var overview in overviews) {
        await saveOverview(overview);
      }
    } catch (e) {
      print('❌ OverviewLocalDataSourceImpl.saveOverviews error: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      // In production, delete all from Isar collection
      print('✅ OverviewLocalDataSourceImpl.clearAll');
    } catch (e) {
      print('❌ OverviewLocalDataSourceImpl.clearAll error: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearMonth(String userId, String month) async {
    try {
      // In production, delete specific month from Isar
      print('✅ OverviewLocalDataSourceImpl.clearMonth: $month');
    } catch (e) {
      print('❌ OverviewLocalDataSourceImpl.clearMonth error: $e');
      rethrow;
    }
  }

  /// ===== UTILITY METHODS =====
  String _formatMonth(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }
}

