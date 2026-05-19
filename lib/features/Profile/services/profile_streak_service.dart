class StreakState {
  final int currentStreak;
  final DateTime lastOpenedAt;
  final int lastOpenedDayKey;
  final int timezoneOffsetMinutes;

  const StreakState({
    required this.currentStreak,
    required this.lastOpenedAt,
    required this.lastOpenedDayKey,
    required this.timezoneOffsetMinutes,
  });
}

enum StreakUpdateReason {
  firstOpen,
  sameDay,
  nextDay,
  skippedDays,
  timeTravel,
}

class StreakUpdateResult {
  final StreakState state;
  final bool didChange;
  final int deltaDays;
  final StreakUpdateReason reason;

  const StreakUpdateResult({
    required this.state,
    required this.didChange,
    required this.deltaDays,
    required this.reason,
  });
}

class ProfileStreakService {
  StreakUpdateResult update({
    required DateTime now,
    StreakState? current,
  }) {
    final today = _dateOnly(now);
    final todayKey = _dayKey(today);
    final timezoneOffsetMinutes = now.timeZoneOffset.inMinutes;

    if (current == null) {
      return StreakUpdateResult(
        state: StreakState(
          currentStreak: 1,
          lastOpenedAt: now,
          lastOpenedDayKey: todayKey,
          timezoneOffsetMinutes: timezoneOffsetMinutes,
        ),
        didChange: true,
        deltaDays: 0,
        reason: StreakUpdateReason.firstOpen,
      );
    }

    final lastDate = _dateOnly(current.lastOpenedAt);
    final deltaDays = today.difference(lastDate).inDays;

    if (deltaDays == 0) {
      final changedTimezone =
          current.timezoneOffsetMinutes != timezoneOffsetMinutes;
      final changedDayKey = current.lastOpenedDayKey != todayKey;

      return StreakUpdateResult(
        state: StreakState(
          currentStreak: current.currentStreak,
          lastOpenedAt: changedDayKey || changedTimezone ? now : current.lastOpenedAt,
          lastOpenedDayKey: todayKey,
          timezoneOffsetMinutes: timezoneOffsetMinutes,
        ),
        didChange: changedDayKey || changedTimezone,
        deltaDays: 0,
        reason: StreakUpdateReason.sameDay,
      );
    }

    if (deltaDays == 1) {
      return StreakUpdateResult(
        state: StreakState(
          currentStreak: current.currentStreak + 1,
          lastOpenedAt: now,
          lastOpenedDayKey: todayKey,
          timezoneOffsetMinutes: timezoneOffsetMinutes,
        ),
        didChange: true,
        deltaDays: 1,
        reason: StreakUpdateReason.nextDay,
      );
    }

    if (deltaDays > 1) {
      return StreakUpdateResult(
        state: StreakState(
          currentStreak: 1,
          lastOpenedAt: now,
          lastOpenedDayKey: todayKey,
          timezoneOffsetMinutes: timezoneOffsetMinutes,
        ),
        didChange: true,
        deltaDays: deltaDays,
        reason: StreakUpdateReason.skippedDays,
      );
    }

    return StreakUpdateResult(
      state: StreakState(
        currentStreak: current.currentStreak,
        lastOpenedAt: now,
        lastOpenedDayKey: todayKey,
        timezoneOffsetMinutes: timezoneOffsetMinutes,
      ),
      didChange: true,
      deltaDays: deltaDays,
      reason: StreakUpdateReason.timeTravel,
    );
  }

  int _dayKey(DateTime date) {
    return date.year * 10000 + date.month * 100 + date.day;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
