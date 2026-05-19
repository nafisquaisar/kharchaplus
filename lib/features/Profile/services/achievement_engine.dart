import 'achievement_catalog.dart';

class AchievementDataSnapshot {
  final int currentStreak;
  final int waterWeeklyDays;
  final double waterMonthlyGoalPercent;
  final int electricityUnits;
  final int totalTransactions;
  final double remainingBalance;

  const AchievementDataSnapshot({
    required this.currentStreak,
    required this.waterWeeklyDays,
    required this.waterMonthlyGoalPercent,
    required this.electricityUnits,
    required this.totalTransactions,
    required this.remainingBalance,
  });
}

class AchievementProgress {
  final double progress;
  final double goal;
  final bool isUnlocked;

  const AchievementProgress({
    required this.progress,
    required this.goal,
    required this.isUnlocked,
  });
}

class AchievementEngine {
  AchievementProgress evaluate(
    AchievementDefinition definition,
    AchievementDataSnapshot snapshot,
  ) {
    switch (definition.id) {
      case 'streak_master':
        return _fromProgress(
          progress: snapshot.currentStreak.toDouble(),
          goal: definition.goal,
        );
      case 'water_saver':
        return _fromProgress(
          progress: snapshot.waterWeeklyDays.toDouble(),
          goal: definition.goal,
        );
      case 'goal_achiever':
        return _fromProgress(
          progress: snapshot.waterMonthlyGoalPercent,
          goal: definition.goal,
        );
      case 'electric_saver':
      case 'gas_saver':
        if (snapshot.electricityUnits <= 0) {
          return _fromProgress(progress: 0, goal: 1);
        }
        final underGoal = snapshot.electricityUnits <= definition.goal;
        return _fromProgress(progress: underGoal ? 1 : 0, goal: 1);
      case 'expense_tracker':
        return _fromProgress(
          progress: snapshot.totalTransactions.toDouble(),
          goal: definition.goal,
        );
      case 'budget_king':
        final isPositive = snapshot.remainingBalance >= 0;
        return _fromProgress(progress: isPositive ? 1 : 0, goal: 1);
      case 'finance_ninja':
        return _fromProgress(
          progress: snapshot.totalTransactions.toDouble(),
          goal: definition.goal,
        );
      default:
        return _fromProgress(progress: 0, goal: definition.goal);
    }
  }

  AchievementProgress _fromProgress({
    required double progress,
    required double goal,
  }) {
    final resolvedGoal = (goal <= 0 ? 1 : goal).toDouble();
    final resolvedProgress = (progress < 0 ? 0 : progress).toDouble();
    return AchievementProgress(
      progress: resolvedProgress,
      goal: resolvedGoal,
      isUnlocked: resolvedProgress >= resolvedGoal,
    );
  }
}
