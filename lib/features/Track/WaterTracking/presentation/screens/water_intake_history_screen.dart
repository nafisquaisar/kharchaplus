import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/Common/CommonAppBar.dart';
import '../../../../../core/constants/AppColors.dart';
import '../../../../../core/utils/AppFlushbar.dart';
import '../../domain/entities/water_intake_entity.dart';
import '../bottomsheet/add_water_sheet.dart';
import '../providers/history/history_provider.dart';
import '../providers/history/history_state.dart';
import '../widgets/history/history_analytics_card.dart';
import '../widgets/history/history_summary_card.dart';
import '../widgets/history/intake_timeline_tile.dart';
import '../widgets/history/monthly_progress_card.dart';
import '../widgets/history/water_calendar_widget.dart';

class WaterIntakeHistoryScreen extends ConsumerStatefulWidget {
  const WaterIntakeHistoryScreen({
    super.key,
  });

  @override
  ConsumerState<WaterIntakeHistoryScreen> createState() =>
      _WaterIntakeHistoryScreenState();
}

class _WaterIntakeHistoryScreenState
    extends ConsumerState<WaterIntakeHistoryScreen> {
  final Map<String, Timer> _deleteTimers = {};
  final Map<String, WaterIntakeEntity> _pendingDelete = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(historyNotifierProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    for (final timer in _deleteTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyNotifierProvider);
    final notifier = ref.read(historyNotifierProvider.notifier);

    final selectedMonthDate = DateTime(
      state.selectedYear,
      state.selectedMonth,
      1,
    );

    final monthLabel = DateFormat('MMMM yyyy').format(selectedMonthDate);
    final selectedDayTotal = _sumIntake(state.intakeTimeline);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize:
        const Size.fromHeight(
          kToolbarHeight,
        ),

        child: CommonAppBar(

          title: "Water Intake History",

          isHome: false,

          isDashboard: false,

          showMore: true,

          onMenuTap: () {

            Navigator.pop(context);
          },

          onNotificationTap: () {},

          onMoreTap: () {

            _openFilterSheet();
          },
        ),
      ),

      body: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: Colors.white,
        onRefresh: notifier.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(
            16,
            10,
            16,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          children: [
            _HistoryTabSwitcher(
              selectedTab: state.selectedTab,
              onTabSelected: (tab) {
                notifier.selectTab(tab);
              },
            ),
            const SizedBox(height: 14),
            if (state.isLoading && state.monthEntries.isEmpty)
              const _AnalyticsSkeleton()
            else
              _AnalyticsGrid(state: state),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => _openMonthPicker(state),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.20),
                    ),
                  ),
                  child: Text(
                    '$monthLabel \u25be',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: WaterCalendarWidget(
                key: ValueKey('${state.selectedYear}-${state.selectedMonth}'),
                month: selectedMonthDate,
                selectedDate: state.selectedDate,
                dayTotalsByDay: state.dayTotalsByDay,
                dailyGoalMl: state.dailyGoalMl,
                onDaySelected: (date) {
                  notifier.selectDate(date);
                },
              ),
            ),
            const SizedBox(height: 14),
            HistorySummaryCard(
              selectedDate: state.selectedDate,
              totalMl: selectedDayTotal,
              dailyGoalMl: state.dailyGoalMl,
            ),
            const SizedBox(height: 16),
            _TimelineHeader(
              onAdd: _openAddSheet,
            ),
            const SizedBox(height: 10),
            if (state.isLoading && state.intakeTimeline.isEmpty)
              const _TimelineSkeleton()
            else if (state.intakeTimeline.isEmpty)
              const _HistoryEmptyState()
            else
              ListView.builder(
                itemCount: state.intakeTimeline.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final intake = state.intakeTimeline[index];
                  return IntakeTimelineTile(
                    intake: intake,
                    onEdit: () => _openEditSheet(intake),
                    onDelete: () => _deleteWithUndo(intake),
                  );
                },
              ),
            const SizedBox(height: 14),
            MonthlyProgressCard(
              consumedMl: state.monthlyProgress.consumedMl,
              targetMl: state.monthlyProgress.targetMl,
              remainingMl: state.monthlyProgress.remainingMl,
              progress: state.monthlyProgress.progress,
            ),
            if (state.error != null) ...[
              const SizedBox(height: 10),
              Text(
                state.error!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _sumIntake(List<WaterIntakeEntity> entries) {
    var total = 0;
    for (final item in entries) {
      total += item.amountMl;
    }
    return total;
  }

  Future<void> _openAddSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddWaterSheet(
            onSubmit: ({
              required int amountMl,
              required DateTime dateTime,
              required String sourceType,
            }) async {
              return ref.read(historyNotifierProvider.notifier).addIntake(
                    amountMl: amountMl,
                    dateTime: dateTime,
                    sourceType: sourceType,
                  );
            },
          ),
        );
      },
    );
  }

  Future<void> _openEditSheet(WaterIntakeEntity intake) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddWaterSheet(
            existingIntake: intake,
            onSubmit: ({
              required int amountMl,
              required DateTime dateTime,
              required String sourceType,
            }) async {
              return ref.read(historyNotifierProvider.notifier).updateIntake(
                    existing: intake,
                    amountMl: amountMl,
                    dateTime: dateTime,
                    sourceType: sourceType,
                  );
            },
          ),
        );
      },
    );
  }

  void _deleteWithUndo(WaterIntakeEntity intake) {
    ref.read(historyNotifierProvider.notifier).removeTimelineOptimistic(intake);
    _pendingDelete[intake.id] = intake;

    AppFlushbar.showUndo(
      context,
      message: 'Intake deleted',
      onUndo: () {
        final pending = _pendingDelete.remove(intake.id);
        _deleteTimers.remove(intake.id)?.cancel();
        if (pending != null) {
          ref
              .read(historyNotifierProvider.notifier)
              .restoreTimelineOptimistic(pending);
        }
      },
    );

    _deleteTimers[intake.id]?.cancel();
    _deleteTimers[intake.id] = Timer(const Duration(seconds: 5), () async {
      final pending = _pendingDelete.remove(intake.id);
      if (pending == null) {
        return;
      }

      final didDelete = await ref
          .read(historyNotifierProvider.notifier)
          .deleteIntake(pending.id);

      if (!mounted) {
        return;
      }

      if (!didDelete) {
        ref
            .read(historyNotifierProvider.notifier)
            .restoreTimelineOptimistic(pending);
        AppFlushbar.showError(context, 'Failed to delete intake');
      }
    });
  }

  Future<void> _openMonthPicker(HistoryState state) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(
        state.selectedYear,
        state.selectedMonth,
        1,
      ),
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked == null) {
      return;
    }

    await ref.read(historyNotifierProvider.notifier).selectMonthYear(
          picked.year,
          picked.month,
        );
  }

  Future<void> _openFilterSheet() async {
    final selected = ref.read(historyNotifierProvider).selectedTab;
    final notifier = ref.read(historyNotifierProvider.notifier);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _HistoryFilterSheet(
          selectedTab: selected,
          onSelected: (tab) async {
            Navigator.pop(context);
            await notifier.selectTab(tab);
          },
        );
      },
    );
  }
}

class _AnalyticsGrid extends StatelessWidget {
  final HistoryState state;


  const _AnalyticsGrid({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final bestDayText = state.analytics.bestDayDate == null
        ? '--'
        : DateFormat('dd MMM').format(state.analytics.bestDayDate!);

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        HistoryAnalyticsCard(
          title: 'Total Intake',
          value: '${state.analytics.totalMl}ml',
          subtitle: 'Selected period',
          icon: Icons.local_drink_rounded,
        ),
        HistoryAnalyticsCard(
          title: 'Daily Average',
          value: '${state.analytics.dailyAverageMl}ml',
          subtitle: 'Average/day',
          icon: Icons.analytics_outlined,
        ),
        HistoryAnalyticsCard(
          title: 'Best Day',
          value: '${state.analytics.bestDayMl}ml',
          subtitle: bestDayText,
          icon: Icons.emoji_events_outlined,
        ),
        HistoryAnalyticsCard(
          title: 'Current Streak',
          value: '${state.analytics.currentStreak} days',
          subtitle: 'Goal-achieved streak',
          icon: Icons.local_fire_department_outlined,
        ),
      ],
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  final VoidCallback onAdd;

  const _TimelineHeader({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Intake Timeline',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onAdd,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accent,
          ),
          icon: const Icon(
            Icons.add_rounded,
            size: 18,
          ),
          label: const Text(
            'Add Intake',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryTabSwitcher extends StatelessWidget {
  final WaterHistoryTab selectedTab;
  final ValueChanged<WaterHistoryTab> onTabSelected;

  const _HistoryTabSwitcher({
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    const tabs = [
      WaterHistoryTab.day,
      WaterHistoryTab.week,
      WaterHistoryTab.month,
    ];

    final index = tabs.indexOf(selectedTab);
    final alignments = [
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            alignment: alignments[index],
            child: Container(
              width: (MediaQuery.of(context).size.width - 40) / 3,
              decoration: BoxDecoration(
                gradient: AppColors.kharchaGradient,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Row(
            children: tabs
                .map(
                  (tab) => Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onTabSelected(tab),
                      child: Center(
                        child: Text(
                          _label(tab),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: tab == selectedTab
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  String _label(WaterHistoryTab tab) {
    switch (tab) {
      case WaterHistoryTab.day:
        return 'Day';
      case WaterHistoryTab.week:
        return 'Week';
      case WaterHistoryTab.month:
        return 'Month';
    }
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.water_drop_outlined,
            color: AppColors.accent,
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(
            'No intake history found \ud83d\udca7',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryFilterSheet extends StatelessWidget {
  final WaterHistoryTab selectedTab;
  final ValueChanged<WaterHistoryTab> onSelected;

  const _HistoryFilterSheet({
    required this.selectedTab,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Filter Timeline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _FilterTile(
              label: 'Day',
              selected: selectedTab == WaterHistoryTab.day,
              onTap: () => onSelected(WaterHistoryTab.day),
            ),
            _FilterTile(
              label: 'Week',
              selected: selectedTab == WaterHistoryTab.week,
              onTap: () => onSelected(WaterHistoryTab.week),
            ),
            _FilterTile(
              label: 'Month',
              selected: selectedTab == WaterHistoryTab.month,
              onTap: () => onSelected(WaterHistoryTab.month),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.accent : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.accent : Colors.grey.shade400,
          ),
        ),
        child: selected
            ? const Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

class _AnalyticsSkeleton extends StatelessWidget {
  const _AnalyticsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(
          4,
          (_) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineSkeleton extends StatelessWidget {
  const _TimelineSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          4,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
