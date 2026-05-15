import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/water_analytics_service.dart';
import '../goal/goal_provider.dart';
import '../intake/intake_provider.dart';
import '../purchase/purchase_provider.dart';
import '../filters/expense_filter_provider.dart';

class AnalyticsState<T> {
  final T data;
  final bool isLoading;
  final String? error;

  const AnalyticsState({
    required this.data,
    required this.isLoading,
    required this.error,
  });
}

final waterAnalyticsServiceProvider = Provider<WaterAnalyticsService>(
  (ref) => WaterAnalyticsService(),
);

final waterIntakeAnalyticsProvider = Provider<AnalyticsState<WaterIntakeAnalytics>>(
  (ref) {
    final intakeState = ref.watch(intakeNotifierProvider);
    final goalState = ref.watch(goalNotifierProvider);
    final analytics = ref
        .read(waterAnalyticsServiceProvider)
        .calculateWaterIntakeAnalytics(
          todayIntake: intakeState.todayIntake,
          weeklyIntake: intakeState.weeklyIntake,
          monthlyIntake: intakeState.monthlyIntake,
          dailyGoalMl: goalState.goal?.dailyGoalMl ?? 3000,
        );

    return AnalyticsState(
      data: analytics,
      isLoading: intakeState.isLoading || goalState.isLoading,
      error: intakeState.error ?? goalState.error,
    );
  },
);

final streakAnalyticsProvider = Provider<AnalyticsState<StreakAnalytics>>(
  (ref) {
    final intakeState = ref.watch(intakeNotifierProvider);
    final analytics = ref
        .read(waterAnalyticsServiceProvider)
        .calculateStreakAnalytics(
          intake: intakeState.monthlyIntake.isNotEmpty
              ? intakeState.monthlyIntake
              : intakeState.weeklyIntake,
        );

    return AnalyticsState(
      data: analytics,
      isLoading: intakeState.isLoading,
      error: intakeState.error,
    );
  },
);

final weeklyChartAnalyticsProvider = Provider<AnalyticsState<WeeklyChartAnalytics>>(
  (ref) {
    final intakeState = ref.watch(intakeNotifierProvider);
    final analytics = ref
        .read(waterAnalyticsServiceProvider)
        .calculateWeeklyChartAnalytics(
          weeklyIntake: intakeState.weeklyIntake,
        );

    return AnalyticsState(
      data: analytics,
      isLoading: intakeState.isLoading,
      error: intakeState.error,
    );
  },
);

final expenseAnalyticsProvider = Provider<AnalyticsState<ExpenseAnalytics>>(
  (ref) {
    final purchaseState = ref.watch(purchaseNotifierProvider);
    final selected = ref.watch(selectedMonthProvider);
    final referenceDate = DateTime(selected.year, selected.month, 1);
    final analytics = ref
        .read(waterAnalyticsServiceProvider)
        .calculateExpenseAnalytics(
          purchases: purchaseState.purchases,
          now: referenceDate,
        );

    return AnalyticsState(
      data: analytics,
      isLoading: purchaseState.isLoading,
      error: purchaseState.error,
    );
  },
);

