import 'package:flutter/foundation.dart';

import '../../Track/WaterTracking/domain/entities/water_goal_entity.dart';
import '../../Track/WaterTracking/domain/entities/water_intake_entity.dart';
import '../../Track/WaterTracking/domain/entities/water_purchase_entity.dart';
import '../../Track/WaterTracking/services/water_analytics_service.dart';
import '../data/models/water_tracking_model.dart';
import '../domain/entities/water_tracking_entity.dart';

class WaterTrackingHomeAnalyticsService {
  WaterTrackingHomeAnalyticsService({WaterAnalyticsService? analyticsService})
      : _analyticsService = analyticsService ?? WaterAnalyticsService();

  final WaterAnalyticsService _analyticsService;

  WaterTrackingHomeModel buildSnapshot({
    required String userId,
    required List<WaterIntakeEntity> todayIntake,
    required List<WaterIntakeEntity> weeklyIntake,
    required List<WaterIntakeEntity> monthlyIntake,
    required List<WaterPurchaseEntity> purchases,
    required WaterGoalEntity? goal,
    DateTime? now,
  }) {
    final dailyGoalMl = goal?.dailyGoalMl ?? 0;

    final intakeAnalytics = _analyticsService.calculateWaterIntakeAnalytics(
      todayIntake: todayIntake,
      weeklyIntake: weeklyIntake,
      monthlyIntake: monthlyIntake,
      dailyGoalMl: dailyGoalMl,
      now: now,
    );

    final expenseAnalytics = _analyticsService.calculateExpenseAnalytics(
      purchases: purchases,
      now: now,
    );

    final currentExpense = expenseAnalytics.monthlyExpense;
    final previousExpense = expenseAnalytics.previousMonthExpense;

    var percentChange = 0.0;
    var trend = WaterExpenseTrend.flat;

    if (previousExpense > 0) {
      percentChange = ((currentExpense - previousExpense) / previousExpense) * 100;
      if (percentChange > 0) {
        trend = WaterExpenseTrend.up;
      } else if (percentChange < 0) {
        trend = WaterExpenseTrend.down;
      }
    } else if (currentExpense > 0) {
      percentChange = 0;
      trend = WaterExpenseTrend.up;
    }

    debugPrint('[WaterHomeAnalytics] todayIntakeMl=${intakeAnalytics.todayMl}');
    debugPrint('[WaterHomeAnalytics] dailyGoalMl=$dailyGoalMl');
    debugPrint(
      '[WaterHomeAnalytics] drinking progress calculated=${intakeAnalytics.intakePercent.toStringAsFixed(2)}',
    );
    debugPrint('[WaterHomeAnalytics] monthly expense calculated=${currentExpense.toStringAsFixed(2)}');
    debugPrint(
      '[WaterHomeAnalytics] previous expense=${previousExpense.toStringAsFixed(2)}',
    );
    debugPrint(
      '[WaterHomeAnalytics] percentage trend calculated=${percentChange.toStringAsFixed(2)} trend=$trend',
    );

    return WaterTrackingHomeModel(
      id: userId,
      userId: userId,
      todayIntakeMl: intakeAnalytics.todayMl,
      dailyGoalMl: dailyGoalMl,
      intakePercent: intakeAnalytics.intakePercent,
      monthlyExpense: currentExpense,
      previousMonthExpense: previousExpense,
      expensePercentChange: percentChange,
      expenseTrend: waterExpenseTrendToValue(trend),
      updatedAt: DateTime.now(),
    );
  }
}
