import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/features/Profile/services/achievement_catalog.dart';
import 'package:expense_tracker/features/Profile/services/achievement_engine.dart';

void main() {
  group('AchievementEngine', () {
    test('streak_master unlocks at 7 days', () {
      final engine = AchievementEngine();
      final definition = AchievementCatalog.byId('streak_master')!;
      final snapshot = AchievementDataSnapshot(
        currentStreak: 7,
        waterWeeklyDays: 0,
        waterMonthlyGoalPercent: 0,
        electricityUnits: 0,
        totalTransactions: 0,
        remainingBalance: 0,
      );

      final result = engine.evaluate(definition, snapshot);
      expect(result.isUnlocked, true);
    });

    test('expense_tracker unlocks at 5 transactions', () {
      final engine = AchievementEngine();
      final definition = AchievementCatalog.byId('expense_tracker')!;
      final snapshot = AchievementDataSnapshot(
        currentStreak: 0,
        waterWeeklyDays: 0,
        waterMonthlyGoalPercent: 0,
        electricityUnits: 0,
        totalTransactions: 5,
        remainingBalance: 0,
      );

      final result = engine.evaluate(definition, snapshot);
      expect(result.isUnlocked, true);
    });
  });
}

