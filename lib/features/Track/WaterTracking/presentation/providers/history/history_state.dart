import '../../../domain/entities/water_intake_entity.dart';

enum WaterHistoryTab {
  day,
  week,
  month,
}

class IntakeHistoryAnalytics {
  final int totalMl;
  final int dailyAverageMl;
  final int bestDayMl;
  final DateTime? bestDayDate;
  final int currentStreak;


  const IntakeHistoryAnalytics({
    required this.totalMl,
    required this.dailyAverageMl,
    required this.bestDayMl,
    required this.bestDayDate,
    required this.currentStreak,
  });

  factory IntakeHistoryAnalytics.empty() {
    return const IntakeHistoryAnalytics(
      totalMl: 0,
      dailyAverageMl: 0,
      bestDayMl: 0,
      bestDayDate: null,
      currentStreak: 0,
    );
  }
}

class MonthlyProgressData {
  final int consumedMl;
  final int targetMl;
  final int remainingMl;
  final double progress;

  const MonthlyProgressData({
    required this.consumedMl,
    required this.targetMl,
    required this.remainingMl,
    required this.progress,
  });

  factory MonthlyProgressData.empty() {
    return const MonthlyProgressData(
      consumedMl: 0,
      targetMl: 0,
      remainingMl: 0,
      progress: 0,
    );
  }
}

class HistoryState {
  final DateTime selectedDate;
  final int selectedMonth;
  final int selectedYear;
  final WaterHistoryTab selectedTab;

  final List<WaterIntakeEntity> intakeTimeline;
  final List<WaterIntakeEntity> monthEntries;
  final List<WaterIntakeEntity> periodEntries;
  final Map<int, int> dayTotalsByDay;

  final IntakeHistoryAnalytics analytics;
  final MonthlyProgressData monthlyProgress;

  final int dailyGoalMl;
  final bool isLoading;
  final String? error;

  const HistoryState({
    required this.selectedDate,
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedTab,
    required this.intakeTimeline,
    required this.monthEntries,
    required this.periodEntries,
    required this.dayTotalsByDay,
    required this.analytics,
    required this.monthlyProgress,
    required this.dailyGoalMl,
    required this.isLoading,
    required this.error,
  });

  factory HistoryState.initial() {
    final now = DateTime.now();
    return HistoryState(
      selectedDate: DateTime(now.year, now.month, now.day),
      selectedMonth: now.month,
      selectedYear: now.year,
      selectedTab: WaterHistoryTab.day,
      intakeTimeline: const [],
      monthEntries: const [],
      periodEntries: const [],
      dayTotalsByDay: const {},
      analytics: IntakeHistoryAnalytics.empty(),
      monthlyProgress: MonthlyProgressData.empty(),
      dailyGoalMl: 3000,
      isLoading: false,
      error: null,
    );
  }

  HistoryState copyWith({
    DateTime? selectedDate,
    int? selectedMonth,
    int? selectedYear,
    WaterHistoryTab? selectedTab,
    List<WaterIntakeEntity>? intakeTimeline,
    List<WaterIntakeEntity>? monthEntries,
    List<WaterIntakeEntity>? periodEntries,
    Map<int, int>? dayTotalsByDay,
    IntakeHistoryAnalytics? analytics,
    MonthlyProgressData? monthlyProgress,
    int? dailyGoalMl,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return HistoryState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedTab: selectedTab ?? this.selectedTab,
      intakeTimeline: intakeTimeline ?? this.intakeTimeline,
      monthEntries: monthEntries ?? this.monthEntries,
      periodEntries: periodEntries ?? this.periodEntries,
      dayTotalsByDay: dayTotalsByDay ?? this.dayTotalsByDay,
      analytics: analytics ?? this.analytics,
      monthlyProgress: monthlyProgress ?? this.monthlyProgress,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}
