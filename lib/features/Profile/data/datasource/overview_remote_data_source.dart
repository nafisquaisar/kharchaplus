import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/overview_summary_model.dart';

/// Remote data source for overview data from Firestore
/// Handles all Firestore queries and aggregations
class OverviewRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ===== PATH HELPERS =====
  DocumentReference<Map<String, dynamic>> _overviewRef(
    String userId,
    String month,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('monthly_overview')
        .doc(month);
  }

  DocumentReference<Map<String, dynamic>> _summaryRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('summary')
        .doc('main');
  }

  /// Watch real-time overview updates for current month
  Stream<OverviewSummaryModel?> watchCurrentMonthOverview(String userId) {
    final now = DateTime.now();
    final month = _formatMonth(now);
    return watchMonthOverview(userId, month);
  }

  /// Watch real-time overview updates for specific month
  Stream<OverviewSummaryModel?> watchMonthOverview(
    String userId,
    String month,
  ) {
    return _overviewRef(userId, month).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return OverviewSummaryModel.fromJson(snapshot.data() ?? {});
    });
  }

  /// Get overview history as a stream for range queries
  Stream<List<OverviewSummaryModel>> watchOverviewHistory(
    String userId,
    int months,
  ) {
    final now = DateTime.now();
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('monthly_overview')
        .orderBy('month', descending: true)
        .limit(months)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OverviewSummaryModel.fromJson(doc.data()))
          .toList();
    });
  }

  /// Fetch monthly summary data (expenses + income)
  Future<Map<String, dynamic>> fetchMonthlySummary(
    String userId,
    String month,
  ) async {
    try {
      final summaryRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('monthly_summary')
          .doc(month);

      final snapshot = await summaryRef.get();
      return snapshot.data() ?? {};
    } catch (e) {
      print('❌ OverviewRemoteDataSource.fetchMonthlySummary error: $e');
      return {};
    }
  }

  /// Fetch water tracking data for month
  /// Assumes water data is stored in monthly collections
  Future<double> fetchMonthlyWaterIntake(
    String userId,
    String month,
  ) async {
    try {
      final query = _firestore
          .collection('users')
          .doc(userId)
          .collection('water_tracking')
          .where('month', isEqualTo: month);

      final snapshot = await query.get();
      double total = 0;

      for (var doc in snapshot.docs) {
        final liters = doc.data()['totalLiters'] ?? 0.0;
        total += (liters as num).toDouble();
      }

      return total;
    } catch (e) {
      print('❌ OverviewRemoteDataSource.fetchMonthlyWaterIntake error: $e');
      return 0;
    }
  }

  /// Fetch electricity tracking data for month
  Future<double> fetchMonthlyElectricity(
    String userId,
    String month,
  ) async {
    try {
      final query = _firestore
          .collection('users')
          .doc(userId)
          .collection('electricity_tracking')
          .where('month', isEqualTo: month);

      final snapshot = await query.get();
      double total = 0;

      for (var doc in snapshot.docs) {
        final units = doc.data()['totalUnits'] ?? 0.0;
        total += (units as num).toDouble();
      }

      return total;
    } catch (e) {
      print('❌ OverviewRemoteDataSource.fetchMonthlyElectricity error: $e');
      return 0;
    }
  }

  /// Compute complete overview by aggregating all sources
  /// This is computationally intensive - call sparingly
  Future<OverviewSummaryModel> computeMonthOverview(
    String userId,
    String month,
  ) async {
    try {
      final summaryData = await fetchMonthlySummary(userId, month);
      final waterIntake = await fetchMonthlyWaterIntake(userId, month);
      final electricityUnits = await fetchMonthlyElectricity(userId, month);

      final totalExpense =
          (summaryData['total_expense'] ?? 0.0) as double;
      final totalIncome =
          (summaryData['total_income'] ?? 0.0) as double;
      final balance = totalIncome - totalExpense;

      // Fetch previous month for trend calculation
      final prevMonthTrends =
          await _calculateTrends(userId, month, totalExpense, totalIncome);

      final overview = OverviewSummaryModel(
        id: 'overview_$month',
        userId: userId,
        month: month,
        totalExpense: totalExpense,
        totalIncome: totalIncome,
        balance: balance,
        waterIntakeLiters: waterIntake,
        electricityUnits: electricityUnits,
        expenseTrend: prevMonthTrends['expenseTrend'] ?? 0.0,
        incomeTrend: prevMonthTrends['incomeTrend'] ?? 0.0,
        waterTrend: prevMonthTrends['waterTrend'] ?? 0.0,
        electricityTrend: prevMonthTrends['electricityTrend'] ?? 0.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save computed overview for caching
      await _overviewRef(userId, month)
          .set(overview.toJson(), SetOptions(merge: true));

      return overview;
    } catch (e) {
      print('❌ OverviewRemoteDataSource.computeMonthOverview error: $e');
      return OverviewSummaryModel.empty(userId: userId, month: month);
    }
  }

  /// Calculate trend percentages by comparing with previous month
  Future<Map<String, double>> _calculateTrends(
    String userId,
    String month,
    double currentExpense,
    double currentIncome,
  ) async {
    try {
      final prevMonth = _getPreviousMonth(month);
      final prevSummary = await fetchMonthlySummary(userId, prevMonth);

      final prevExpense =
          (prevSummary['total_expense'] ?? 0.0) as double;
      final prevIncome =
          (prevSummary['total_income'] ?? 0.0) as double;

      final expenseTrend = prevExpense != 0
          ? ((currentExpense - prevExpense) / prevExpense) * 100
          : 0.0;

      final incomeTrend = prevIncome != 0
          ? ((currentIncome - prevIncome) / prevIncome) * 100
          : 0.0;

      final prevWater = await fetchMonthlyWaterIntake(userId, prevMonth);
      final waterTrend = prevWater != 0 ? 0.0 : 0.0; // Will be updated appropriately

      final prevElectricity =
          await fetchMonthlyElectricity(userId, prevMonth);
      final electricityTrend = prevElectricity != 0 ? 0.0 : 0.0;

      return {
        'expenseTrend': expenseTrend,
        'incomeTrend': incomeTrend,
        'waterTrend': waterTrend,
        'electricityTrend': electricityTrend,
      };
    } catch (e) {
      print('❌ OverviewRemoteDataSource._calculateTrends error: $e');
      return {
        'expenseTrend': 0.0,
        'incomeTrend': 0.0,
        'waterTrend': 0.0,
        'electricityTrend': 0.0,
      };
    }
  }

  /// ===== UTILITY METHODS =====
  String _formatMonth(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  String _getPreviousMonth(String month) {
    // Parse month string "YYYY-MM"
    final parts = month.split('-');
    var year = int.parse(parts[0]);
    var m = int.parse(parts[1]);

    m--;
    if (m == 0) {
      m = 12;
      year--;
    }

    return '$year-${m.toString().padLeft(2, '0')}';
  }
}

