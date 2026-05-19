class MonthlyGoalResult {
  final int daysCompleted;
  final int daysInMonth;
  final double percent;

  const MonthlyGoalResult({
    required this.daysCompleted,
    required this.daysInMonth,
    required this.percent,
  });
}

class ProfileMonthlyGoalService {
  MonthlyGoalResult calculate({
    required Map<int, int> intakeByDay,
    required int dailyGoalMl,
    required DateTime now,
  }) {
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    if (daysInMonth <= 0) {
      return const MonthlyGoalResult(
        daysCompleted: 0,
        daysInMonth: 0,
        percent: 0,
      );
    }

    if (dailyGoalMl <= 0) {
      return MonthlyGoalResult(
        daysCompleted: 0,
        daysInMonth: daysInMonth,
        percent: 0,
      );
    }

    var completed = 0;
    for (final entry in intakeByDay.entries) {
      if (entry.value >= dailyGoalMl) {
        completed += 1;
      }
    }

    final percent = (completed / daysInMonth) * 100;
    return MonthlyGoalResult(
      daysCompleted: completed,
      daysInMonth: daysInMonth,
      percent: percent.clamp(0, 100),
    );
  }
}

