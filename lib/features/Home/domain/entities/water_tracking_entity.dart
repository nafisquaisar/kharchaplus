enum WaterExpenseTrend {
  up,
  down,
  flat,
}

class WaterTrackingHomeEntity {
  final String id;
  final int todayIntakeMl;
  final int dailyGoalMl;
  final double intakePercent;
  final double monthlyExpense;
  final double previousMonthExpense;
  final double expensePercentChange;
  final String expenseTrend;
  final DateTime updatedAt;

  const WaterTrackingHomeEntity({
    required this.id,
    required this.todayIntakeMl,
    required this.dailyGoalMl,
    required this.intakePercent,
    required this.monthlyExpense,
    required this.previousMonthExpense,
    required this.expensePercentChange,
    required this.expenseTrend,
    required this.updatedAt,
  });

  bool get hasGoal => dailyGoalMl > 0;

  bool get hasIntake => todayIntakeMl > 0;

  bool get hasExpense => monthlyExpense > 0;
}

String waterExpenseTrendToValue(WaterExpenseTrend trend) {
  switch (trend) {
    case WaterExpenseTrend.up:
      return 'up';
    case WaterExpenseTrend.down:
      return 'down';
    case WaterExpenseTrend.flat:
      return 'flat';
  }
}

WaterExpenseTrend waterExpenseTrendFromValue(String value) {
  switch (value) {
    case 'up':
      return WaterExpenseTrend.up;
    case 'down':
      return WaterExpenseTrend.down;
    default:
      return WaterExpenseTrend.flat;
  }
}
