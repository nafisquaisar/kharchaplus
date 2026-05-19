import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/features/Profile/services/profile_streak_service.dart';

void main() {
  group('ProfileStreakService', () {
    test('first open starts streak at 1', () {
      final service = ProfileStreakService();
      final result = service.update(
        now: DateTime(2026, 5, 19, 10, 0),
        current: null,
      );

      expect(result.state.currentStreak, 1);
      expect(result.reason, StreakUpdateReason.firstOpen);
    });

    test('same day does not increment streak', () {
      final service = ProfileStreakService();
      final existing = StreakState(
        currentStreak: 3,
        lastOpenedAt: DateTime(2026, 5, 19, 8, 0),
        lastOpenedDayKey: 20260519,
        timezoneOffsetMinutes: 0,
      );

      final result = service.update(
        now: DateTime(2026, 5, 19, 20, 0),
        current: existing,
      );

      expect(result.state.currentStreak, 3);
      expect(result.reason, StreakUpdateReason.sameDay);
    });

    test('next day increments streak', () {
      final service = ProfileStreakService();
      final existing = StreakState(
        currentStreak: 4,
        lastOpenedAt: DateTime(2026, 5, 18, 9, 0),
        lastOpenedDayKey: 20260518,
        timezoneOffsetMinutes: 0,
      );

      final result = service.update(
        now: DateTime(2026, 5, 19, 9, 0),
        current: existing,
      );

      expect(result.state.currentStreak, 5);
      expect(result.reason, StreakUpdateReason.nextDay);
    });

    test('skipped days resets streak to 1', () {
      final service = ProfileStreakService();
      final existing = StreakState(
        currentStreak: 7,
        lastOpenedAt: DateTime(2026, 5, 15, 9, 0),
        lastOpenedDayKey: 20260515,
        timezoneOffsetMinutes: 0,
      );

      final result = service.update(
        now: DateTime(2026, 5, 19, 9, 0),
        current: existing,
      );

      expect(result.state.currentStreak, 1);
      expect(result.reason, StreakUpdateReason.skippedDays);
    });

    test('time travel does not reset streak', () {
      final service = ProfileStreakService();
      final existing = StreakState(
        currentStreak: 5,
        lastOpenedAt: DateTime(2026, 5, 19, 9, 0),
        lastOpenedDayKey: 20260519,
        timezoneOffsetMinutes: 0,
      );

      final result = service.update(
        now: DateTime(2026, 5, 18, 23, 0),
        current: existing,
      );

      expect(result.state.currentStreak, 5);
      expect(result.reason, StreakUpdateReason.timeTravel);
    });
  });
}

