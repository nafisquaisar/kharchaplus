import 'package:expense_tracker/core/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/water_intake_entity.dart';
import '../../../domain/usecases/goals/get_goal.dart';
import '../../../domain/usecases/intake/add_water_intake.dart';
import '../../../domain/usecases/intake/get_intake_by_date.dart';
import '../../../domain/usecases/intake/get_intake_by_month.dart';
import '../../../domain/usecases/intake/get_intake_by_week.dart';
import '../../../domain/usecases/intake/soft_delete_water_intake.dart';
import '../../../domain/usecases/intake/update_water_intake.dart';
import '../sync/sync_provider.dart';
import 'history_state.dart';

class HistoryNotifier extends StateNotifier<HistoryState> {
  final Ref ref;
  final AuthService authService;
  final GetGoal getGoalUsecase;
  final AddWaterIntake addWaterIntakeUsecase;
  final GetIntakeByDate getIntakeByDateUsecase;
  final GetIntakeByWeek getIntakeByWeekUsecase;
  final GetIntakeByMonth getIntakeByMonthUsecase;
  final UpdateWaterIntake updateWaterIntakeUsecase;
  final SoftDeleteWaterIntake softDeleteWaterIntakeUsecase;

  final Uuid _uuid = const Uuid();

  HistoryNotifier({
    required this.ref,
    required this.authService,
    required this.getGoalUsecase,
    required this.addWaterIntakeUsecase,
    required this.getIntakeByDateUsecase,
    required this.getIntakeByWeekUsecase,
    required this.getIntakeByMonthUsecase,
    required this.updateWaterIntakeUsecase,
    required this.softDeleteWaterIntakeUsecase,
  }) : super(HistoryState.initial());

  Future<void> initialize() async {
    await _reloadData(showLoading: true);
  }

  Future<void> refresh() async {
    await _reloadData(showLoading: true);
  }

  Future<void> selectTab(WaterHistoryTab tab) async {
    if (state.selectedTab == tab) {
      return;
    }
    state = state.copyWith(
      selectedTab: tab,
      clearError: true,
    );
    await _reloadData(showLoading: true);
  }

  Future<void> selectDate(DateTime date) async {
    final normalized = DateTime(
      date.year,
      date.month,
      date.day,
    );
    state = state.copyWith(
      selectedDate: normalized,
      selectedMonth: normalized.month,
      selectedYear: normalized.year,
      clearError: true,
    );
    await _reloadData(showLoading: true);
  }

  Future<void> selectMonthYear(int year, int month) async {
    final currentDay = state.selectedDate.day;
    final lastDay = DateTime(
      year,
      month + 1,
      0,
    ).day;
    final day = currentDay > lastDay ? lastDay : currentDay;

    state = state.copyWith(
      selectedYear: year,
      selectedMonth: month,
      selectedDate: DateTime(
        year,
        month,
        day,
      ),
      clearError: true,
    );
    await _reloadData(showLoading: true);
  }

  Future<bool> addIntake({
    required int amountMl,
    required DateTime dateTime,
    required String sourceType,
  }) async {
    try {
      final userId = await authService.getCurrentUserId();
      final now = DateTime.now();

      final entity = WaterIntakeEntity(
        id: _uuid.v4(),
        amountMl: amountMl,
        dateTime: dateTime,
        sourceType: sourceType,
        isSynced: false,
        isDeleted: false,
        isEdited: false,
        isActive: true,
        isOfflineCreated: true,
        version: 1,
        createdAt: now,
        updatedAt: now,
        userId: userId,
      );

      await addWaterIntakeUsecase(entity);
      await _reloadData(showLoading: false);
      ref.read(waterSyncNotifierProvider.notifier).syncNow();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateIntake({
    required WaterIntakeEntity existing,
    required int amountMl,
    required DateTime dateTime,
    required String sourceType,
  }) async {
    try {
      final updated = WaterIntakeEntity(
        id: existing.id,
        amountMl: amountMl,
        dateTime: dateTime,
        sourceType: sourceType,
        isSynced: false,
        isDeleted: false,
        isEdited: true,
        isActive: existing.isActive,
        isOfflineCreated: existing.isOfflineCreated,
        version: existing.version + 1,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
        userId: existing.userId,
        serverId: existing.serverId,
      );

      await updateWaterIntakeUsecase(updated);
      await _reloadData(showLoading: false);
      ref.read(waterSyncNotifierProvider.notifier).syncNow();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteIntake(String id) async {
    try {
      await softDeleteWaterIntakeUsecase(id);
      await _reloadData(showLoading: false);
      ref.read(waterSyncNotifierProvider.notifier).syncNow();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
      return false;
    }
  }

  void removeTimelineOptimistic(WaterIntakeEntity intake) {
    final nextTimeline =
        state.intakeTimeline.where((item) => item.id != intake.id).toList();

    final nextMonth =
        state.monthEntries.where((item) => item.id != intake.id).toList();

    final nextPeriod = _removeFromPeriod(
      periodEntries: state.periodEntries,
      intake: intake,
      tab: state.selectedTab,
      selectedDate: state.selectedDate,
    );

    _applyDerivedState(
      intakeTimeline: nextTimeline,
      monthEntries: nextMonth,
      periodEntries: nextPeriod,
      clearError: true,
    );
  }

  void restoreTimelineOptimistic(WaterIntakeEntity intake) {
    final nextTimeline = [...state.intakeTimeline];
    if (_sameDay(intake.dateTime, state.selectedDate)) {
      nextTimeline.add(intake);
      nextTimeline.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }

    final nextMonth = [...state.monthEntries];
    if (intake.dateTime.year == state.selectedYear &&
        intake.dateTime.month == state.selectedMonth) {
      nextMonth.add(intake);
      nextMonth.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }

    final nextPeriod = _restoreToPeriod(
      periodEntries: state.periodEntries,
      intake: intake,
      tab: state.selectedTab,
      selectedDate: state.selectedDate,
      monthEntries: nextMonth,
      intakeTimeline: nextTimeline,
    );

    _applyDerivedState(
      intakeTimeline: nextTimeline,
      monthEntries: nextMonth,
      periodEntries: nextPeriod,
      clearError: true,
    );
  }

  Future<void> _reloadData({
    required bool showLoading,
  }) async {
    if (showLoading) {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
      );
    }

    try {
      final goalFuture = getGoalUsecase();
      final monthFuture = getIntakeByMonthUsecase(
        state.selectedYear,
        state.selectedMonth,
      );
      final dayFuture = getIntakeByDateUsecase(
        state.selectedDate,
      );

      final results = await Future.wait([
        goalFuture,
        monthFuture,
        dayFuture,
      ]);

      final goal = results[0] as dynamic;
      final monthEntries = (results[1] as List<WaterIntakeEntity>)
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      final dayEntries = (results[2] as List<WaterIntakeEntity>)
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

      List<WaterIntakeEntity> periodEntries;
      switch (state.selectedTab) {
        case WaterHistoryTab.day:
          periodEntries = dayEntries;
          break;
        case WaterHistoryTab.week:
          periodEntries = await getIntakeByWeekUsecase(state.selectedDate);
          periodEntries.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          break;
        case WaterHistoryTab.month:
          periodEntries = monthEntries;
          break;
      }

      state = state.copyWith(
        intakeTimeline: dayEntries,
        monthEntries: monthEntries,
        periodEntries: periodEntries,
        dailyGoalMl: goal?.dailyGoalMl ?? state.dailyGoalMl,
      );

      _applyDerivedState(
        intakeTimeline: dayEntries,
        monthEntries: monthEntries,
        periodEntries: periodEntries,
        clearError: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void _applyDerivedState({
    required List<WaterIntakeEntity> intakeTimeline,
    required List<WaterIntakeEntity> monthEntries,
    required List<WaterIntakeEntity> periodEntries,
    bool clearError = false,
    bool? isLoading,
  }) {
    final totalsByDay = _groupDayTotals(monthEntries);
    final analytics = _buildAnalytics(
      periodEntries: periodEntries,
      monthEntries: monthEntries,
      dailyGoalMl: state.dailyGoalMl,
      tab: state.selectedTab,
      selectedDate: state.selectedDate,
      selectedMonth: state.selectedMonth,
      selectedYear: state.selectedYear,
    );
    final monthlyProgress = _buildMonthlyProgress(
      monthEntries: monthEntries,
      dailyGoalMl: state.dailyGoalMl,
      year: state.selectedYear,
      month: state.selectedMonth,
    );

    state = state.copyWith(
      intakeTimeline: intakeTimeline,
      monthEntries: monthEntries,
      periodEntries: periodEntries,
      dayTotalsByDay: totalsByDay,
      analytics: analytics,
      monthlyProgress: monthlyProgress,
      isLoading: isLoading ?? state.isLoading,
      clearError: clearError,
    );
  }

  Map<int, int> _groupDayTotals(List<WaterIntakeEntity> entries) {
    final totals = <int, int>{};
    for (final item in entries) {
      final day = item.dateTime.day;
      totals[day] = (totals[day] ?? 0) + item.amountMl;
    }
    return totals;
  }

  IntakeHistoryAnalytics _buildAnalytics({
    required List<WaterIntakeEntity> periodEntries,
    required List<WaterIntakeEntity> monthEntries,
    required int dailyGoalMl,
    required WaterHistoryTab tab,
    required DateTime selectedDate,
    required int selectedMonth,
    required int selectedYear,
  }) {
    var total = 0;
    for (final item in periodEntries) {
      total += item.amountMl;
    }

    final dayTotals = <DateTime, int>{};
    for (final item in periodEntries) {
      final date = DateTime(
        item.dateTime.year,
        item.dateTime.month,
        item.dateTime.day,
      );
      dayTotals[date] = (dayTotals[date] ?? 0) + item.amountMl;
    }

    DateTime? bestDayDate;
    var bestDayMl = 0;
    for (final entry in dayTotals.entries) {
      if (entry.value > bestDayMl) {
        bestDayMl = entry.value;
        bestDayDate = entry.key;
      }
    }

    final daysInMonth = DateTime(
      selectedYear,
      selectedMonth + 1,
      0,
    ).day;

    final divisor = switch (tab) {
      WaterHistoryTab.day => 1,
      WaterHistoryTab.week => 7,
      WaterHistoryTab.month => daysInMonth,
    };

    final streak = _calculateStreak(
      entries: monthEntries,
      anchor: selectedDate,
      dailyGoalMl: dailyGoalMl,
    );

    return IntakeHistoryAnalytics(
      totalMl: total,
      dailyAverageMl: divisor == 0 ? 0 : (total / divisor).round(),
      bestDayMl: bestDayMl,
      bestDayDate: bestDayDate,
      currentStreak: streak,
    );
  }

  MonthlyProgressData _buildMonthlyProgress({
    required List<WaterIntakeEntity> monthEntries,
    required int dailyGoalMl,
    required int year,
    required int month,
  }) {
    var consumed = 0;
    for (final item in monthEntries) {
      consumed += item.amountMl;
    }

    final daysInMonth = DateTime(
      year,
      month + 1,
      0,
    ).day;

    final target = dailyGoalMl * daysInMonth;
    final remaining = target - consumed;
    final progress = target == 0 ? 0.0 : (consumed / target).clamp(0.0, 1.0);

    return MonthlyProgressData(
      consumedMl: consumed,
      targetMl: target,
      remainingMl: remaining < 0 ? 0 : remaining,
      progress: progress,
    );
  }

  int _calculateStreak({
    required List<WaterIntakeEntity> entries,
    required DateTime anchor,
    required int dailyGoalMl,
  }) {
    final totals = <DateTime, int>{};

    for (final item in entries) {
      final date = DateTime(
        item.dateTime.year,
        item.dateTime.month,
        item.dateTime.day,
      );

      totals[date] = (totals[date] ?? 0) + item.amountMl;
    }

    var streak = 0;

    var cursor = DateTime(
      anchor.year,
      anchor.month,
      anchor.day,
    );

    while (true) {
      final value = totals[cursor] ?? 0;

      print('Date: $cursor');
      print('Value: $value');
      print('Goal: $dailyGoalMl');

      if (value >= dailyGoalMl) {
        streak += 1;

        cursor = cursor.subtract(
          const Duration(days: 1),
        );

        continue;
      }

      break;
    }

    print('Final Streak: $streak');

    return streak;
  }

  List<WaterIntakeEntity> _removeFromPeriod({
    required List<WaterIntakeEntity> periodEntries,
    required WaterIntakeEntity intake,
    required WaterHistoryTab tab,
    required DateTime selectedDate,
  }) {
    switch (tab) {
      case WaterHistoryTab.day:
        return periodEntries.where((item) => item.id != intake.id).toList();
      case WaterHistoryTab.week:
        if (_isInSelectedWeek(
          intakeDate: intake.dateTime,
          selectedDate: selectedDate,
        )) {
          return periodEntries.where((item) => item.id != intake.id).toList();
        }
        return periodEntries;
      case WaterHistoryTab.month:
        return periodEntries.where((item) => item.id != intake.id).toList();
    }
  }

  List<WaterIntakeEntity> _restoreToPeriod({
    required List<WaterIntakeEntity> periodEntries,
    required WaterIntakeEntity intake,
    required WaterHistoryTab tab,
    required DateTime selectedDate,
    required List<WaterIntakeEntity> monthEntries,
    required List<WaterIntakeEntity> intakeTimeline,
  }) {
    switch (tab) {
      case WaterHistoryTab.day:
        return intakeTimeline;
      case WaterHistoryTab.week:
        final next = [...periodEntries];
        if (_isInSelectedWeek(
          intakeDate: intake.dateTime,
          selectedDate: selectedDate,
        )) {
          next.add(intake);
          next.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        }
        return next;
      case WaterHistoryTab.month:
        return monthEntries;
    }
  }

  bool _isInSelectedWeek({
    required DateTime intakeDate,
    required DateTime selectedDate,
  }) {
    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final start = selected.subtract(
      Duration(days: selected.weekday - 1),
    );
    final end = start.add(
      const Duration(days: 7),
    );
    final value = DateTime(
      intakeDate.year,
      intakeDate.month,
      intakeDate.day,
    );
    return !value.isBefore(start) && value.isBefore(end);
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
