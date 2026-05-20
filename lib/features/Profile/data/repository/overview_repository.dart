import '../models/overview_summary_model.dart';

/// Abstract repository for monthly overview data
/// Follows clean architecture principles with single responsibility
abstract class OverviewRepository {
  /// Get current month's overview as a stream for real-time updates
  Stream<OverviewSummaryModel?> watchCurrentMonthOverview(String userId);

  /// Get specific month's overview
  Stream<OverviewSummaryModel?> watchMonthOverview(
    String userId,
    String month,
  );

  /// Get overview history for a date range
  Stream<List<OverviewSummaryModel>> watchOverviewHistory(
    String userId,
    int months,
  );

  /// Compute and cache overview for current month
  /// This aggregates data from expenses, income, water, and electricity
  Future<OverviewSummaryModel> computeCurrentMonthOverview(String userId);

  /// Compute overview for specific month
  Future<OverviewSummaryModel> computeMonthOverview(
    String userId,
    String month,
  );

  /// Refresh overview data (poll from Firestore + calculate trends)
  Future<void> refreshOverview(String userId, String month);

  /// Force sync pending overview records
  Future<void> syncPending(String userId);

  /// Clear cached overview data
  Future<void> clearCache(String userId);
}

