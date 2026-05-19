import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/features/Profile/services/profile_monthly_goal_service.dart';

void main() {
  group('ProfileMonthlyGoalService', () {
    test('calculates monthly percent based on completed days', () {
      final service = ProfileMonthlyGoalService();
      final now = DateTime(2026, 5, 26);
      final intakeByDay = {
        20260501: 2000,
        20260502: 2500,
        20260503: 2000,
        20260504: 1500,
        20260505: 2000,
        20260506: 2000,
        20260507: 2100,
        20260508: 2000,
        20260509: 1000,
        20260510: 2000,
        20260511: 2000,
        20260512: 2000,
        20260513: 2000,
        20260514: 2000,
        20260515: 2000,
        20260516: 2000,
        20260517: 2000,
        20260518: 2000,
        20260519: 2000,
        20260520: 2000,
        20260521: 2000,
        20260522: 2000,
      };

      final result = service.calculate(
        intakeByDay: intakeByDay,
        dailyGoalMl: 2000,
        now: now,
      );

      expect(result.daysCompleted, 20);
      expect(result.daysInMonth, 31);
      expect(result.percent.toStringAsFixed(0), '65');
    });

    test('returns 0 when daily goal is not set', () {
      final service = ProfileMonthlyGoalService();
      final result = service.calculate(
        intakeByDay: {20260501: 3000},
        dailyGoalMl: 0,
        now: DateTime(2026, 5, 1),
      );

      expect(result.daysCompleted, 0);
      expect(result.percent, 0);
    });
  });
}
