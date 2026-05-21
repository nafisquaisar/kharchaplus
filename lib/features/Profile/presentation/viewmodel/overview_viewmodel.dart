import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../data/models/overview_summary_model.dart';
import '../../data/repository/overview_repository.dart';


/// ViewModel for Monthly Overview Dashboard
/// Manages state, data flow, and business logic
/// Extends ChangeNotifier for Provider integration
class OverviewViewModel extends ChangeNotifier {
  final OverviewRepository _repository;

  /// ===== STATE MANAGEMENT =====

  /// Current overview data
  OverviewSummaryModel? _currentOverview;
  OverviewSummaryModel? get currentOverview => _currentOverview;

  /// Loading states
  bool _isInitialLoading = false;
  bool get isInitialLoading => _isInitialLoading;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  /// Error handling
  String? _error;
  String? get error => _error;

  /// Stream subscriptions
  StreamSubscription<OverviewSummaryModel?>? _overviewSubscription;

  /// Bind this ViewModel to a user
  String? _boundUserId;
  String? get boundUserId => _boundUserId;

  /// Cache for trend indicators
  Map<String, double> _trendCache = {};
  Map<String, double> get trendCache => _trendCache;

  OverviewViewModel(this._repository);

  /// ===== INITIALIZATION & BINDING =====

  /// Bind the ViewModel to a specific user
  void bindUser(String? userId) {
    if (userId == null || userId == _boundUserId) {
      return;
    }

    _boundUserId = userId;
    _startWatchingOverview();
  }

  /// Start watching real-time overview updates
  void _startWatchingOverview() {
    if (_boundUserId == null) return;

    // Cancel previous subscription
    _overviewSubscription?.cancel();

    _isInitialLoading = true;
    notifyListeners();

    try {
      _overviewSubscription = _repository
          .watchCurrentMonthOverview(_boundUserId!)
          .listen(
            (overview) {
              _currentOverview = overview;
              _error = null;
              _isInitialLoading = false;
              _cacheTransformations();
              notifyListeners();
            },
            onError: (e) {
              _error = 'Failed to load overview: ${e.toString()}';
              _isInitialLoading = false;
              notifyListeners();
              print('❌ OverviewViewModel error: $e');
            },
          );
    } catch (e) {
      _error = 'Error initializing overview: ${e.toString()}';
      _isInitialLoading = false;
      notifyListeners();
    }
  }

  /// ===== PUBLIC METHODS =====

  /// Manually refresh overview data
  Future<void> refresh() async {
    if (_boundUserId == null) return;

    _isRefreshing = true;
    notifyListeners();

    try {
      await _repository.refreshOverview(
        _boundUserId!,
        _getCurrentMonth(),
      );
      _error = null;
    } catch (e) {
      _error = 'Refresh failed: ${e.toString()}';
      print('❌ OverviewViewModel.refresh error: $e');
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Get formatted trend percentage with sign
  String formatTrendPercentage(double trend) {
    if (trend == 0) return '0%';
    final sign = trend > 0 ? '+' : '';
    return '$sign${trend.toStringAsFixed(1)}%';
  }

  /// Check if trend is positive (red for expense, green for income)
  bool isTrendPositive(String metricType, double trend) {
    // For expenses: negative trend is good (lower spending)
    if (metricType == 'expense' || metricType == 'electricity' || metricType == 'water') {
      return trend < 0;
    }
    // For income: positive trend is good
    return trend > 0;
  }

  /// Get trend color
  /// Returns: green for positive trends (or negative for expenses), red for negative (or positive for expenses)
  /// This helps visualization
  String getTrendStatus(String metricType, double trend) {
    final isPositive = isTrendPositive(metricType, trend);
    if (isPositive) return 'positive';
    if (trend == 0) return 'neutral';
    return 'negative';
  }

  /// Get all metrics as formatted strings
  Map<String, String> getFormattedMetrics() {
    if (_currentOverview == null) {
      return {
        'expense': '₹0',
        'income': '₹0',
        'water': '0L',
        'electricity': '0 kWh',
      };
    }

    return {
      'expense': '₹${_currentOverview!.totalExpense.toStringAsFixed(2)}',
      'income': '₹${_currentOverview!.totalIncome.toStringAsFixed(2)}',
      'water': '${_currentOverview!.waterIntakeLiters.toStringAsFixed(1)}L',
      'electricity': '${_currentOverview!.electricityUnits.toStringAsFixed(1)} kWh',
      'balance': '₹${_currentOverview!.balance.toStringAsFixed(2)}',
    };
  }

  /// ===== PRIVATE HELPER METHODS =====

  void _cacheTransformations() {
    if (_currentOverview == null) return;

    _trendCache = {
      'expenseTrend': _currentOverview!.expenseTrend,
      'incomeTrend': _currentOverview!.incomeTrend,
      'waterTrend': _currentOverview!.waterTrend,
      'electricityTrend': _currentOverview!.electricityTrend,
    };
  }

  String _getCurrentMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  /// ===== LIFECYCLE =====

  @override
  void dispose() {
    _overviewSubscription?.cancel();
    super.dispose();
  }
}

