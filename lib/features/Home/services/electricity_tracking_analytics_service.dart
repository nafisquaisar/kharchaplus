import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../domain/entities/electricity_tracking_entity.dart';

enum ElectricityTrendDirection {
  up,
  down,
  flat,
}

class ElectricityMonthlyPoint {
  final String label;
  final double units;
  final DateTime month;

  const ElectricityMonthlyPoint({
    required this.label,
    required this.units,
    required this.month,
  });
}

class ElectricityTrackingHomeAnalytics {
  final List<ElectricityTrackingHomeEntity> sortedCycles;
  final List<ElectricityMonthlyPoint> points;
  final ElectricityTrackingHomeEntity? current;
  final ElectricityTrackingHomeEntity? previous;
  final double percentChange;
  final ElectricityTrendDirection trend;
  final String previousLabel;

  const ElectricityTrackingHomeAnalytics({
    required this.sortedCycles,
    required this.points,
    required this.current,
    required this.previous,
    required this.percentChange,
    required this.trend,
    required this.previousLabel,
  });

  bool get hasData => sortedCycles.isNotEmpty;

  String get currentMonthLabel {
    if (current == null) {
      return '';
    }
    return DateFormat('MMM').format(current!.endDate);
  }
}

class ElectricityTrackingHomeAnalyticsService {
  ElectricityTrackingHomeAnalytics build(
    List<ElectricityTrackingHomeEntity> items,
  ) {
    final sorted = [...items]
      ..sort((a, b) => b.endDate.compareTo(a.endDate));

    final current = sorted.isNotEmpty ? sorted.first : null;
    final previous = sorted.length > 1 ? sorted[1] : null;

    final previousUnits = previous?.consumedUnits ?? 0;
    final currentUnits = current?.consumedUnits ?? 0;

    double percentChange = 0;
    ElectricityTrendDirection trend = ElectricityTrendDirection.flat;

    if (previousUnits > 0) {
      percentChange = ((currentUnits - previousUnits) / previousUnits) * 100;
      if (percentChange > 0) {
        trend = ElectricityTrendDirection.up;
      } else if (percentChange < 0) {
        trend = ElectricityTrendDirection.down;
      }
    } else if (currentUnits > 0) {
      percentChange = 0;
      trend = ElectricityTrendDirection.up;
    }

    final previousLabel = previous == null
        ? ''
        : DateFormat('MMM').format(previous.endDate);

    final points = _buildPoints(sorted);

    debugPrint('[ElectricityHomeAnalytics] currentUnits=$currentUnits');
    debugPrint('[ElectricityHomeAnalytics] previousUnits=$previousUnits');
    debugPrint('[ElectricityHomeAnalytics] percentChange=${percentChange.toStringAsFixed(2)}');
    debugPrint('[ElectricityHomeAnalytics] trend=$trend');
    debugPrint('[ElectricityHomeAnalytics] chartPoints=${points.length}');

    return ElectricityTrackingHomeAnalytics(
      sortedCycles: sorted,
      points: points,
      current: current,
      previous: previous,
      percentChange: percentChange,
      trend: trend,
      previousLabel: previousLabel,
    );
  }

  List<ElectricityMonthlyPoint> _buildPoints(
    List<ElectricityTrackingHomeEntity> sorted,
  ) {
    if (sorted.isEmpty) {
      return const [];
    }

    final ascending = [...sorted]..sort((a, b) => a.endDate.compareTo(b.endDate));
    final window = ascending.length > 6
        ? ascending.sublist(ascending.length - 6)
        : ascending;

    return window
        .map(
          (item) => ElectricityMonthlyPoint(
            label: DateFormat('MMM').format(item.endDate),
            units: item.consumedUnits.toDouble(),
            month: item.endDate,
          ),
        )
        .toList();
  }
}

