import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class WaterCalendarWidget extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final Map<int, int> dayTotalsByDay;
  final int dailyGoalMl;
  final ValueChanged<DateTime> onDaySelected;

  const WaterCalendarWidget({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.dayTotalsByDay,
    required this.dailyGoalMl,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final year = month.year;
    final monthIndex = month.month;
    final firstDay = DateTime(year, monthIndex, 1);
    final daysInMonth = DateTime(year, monthIndex + 1, 0).day;
    final leadingEmpty = firstDay.weekday - 1;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const _WeekdayHeader(),
          const SizedBox(height: 8),
          GridView.builder(
            itemCount: leadingEmpty + daysInMonth,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.05,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              if (index < leadingEmpty) {
                return const SizedBox.shrink();
              }

              final day = index - leadingEmpty + 1;
              final date = DateTime(year, monthIndex, day);
              final total = dayTotalsByDay[day] ?? 0;
              final ratio = dailyGoalMl == 0 ? 0.0 : total / dailyGoalMl;
              final isSelected = _isSameDay(date, selectedDate);

              final color = _heatColor(
                total: total,
                ratio: ratio,
                emptyColor: colorScheme.surfaceContainerHighest,
              );

              return GestureDetector(
                onTap: () => onDaySelected(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.18),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _textColorForBackground(
                          color,
                          emptyColor: colorScheme.surfaceContainerHighest,
                          emptyText: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _HeatLegend(noDataColor: colorScheme.surfaceContainerHighest),
        ],
      ),
    );
  }

  Color _heatColor({
    required int total,
    required double ratio,
    required Color emptyColor,
  }) {
    if (total <= 0) {
      return emptyColor;
    }
    if (ratio >= 1.0) {
      return const Color(0xFF37B56A);
    }
    if (ratio >= 0.5) {
      return const Color(0xFF2E8AE6);
    }
    return const Color(0xFFE65C5C);
  }

  Color _textColorForBackground(
    Color color, {
    required Color emptyColor,
    required Color emptyText,
  }) {
    if (color == emptyColor) {
      return emptyText;
    }
    return Colors.white;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _HeatLegend extends StatelessWidget {
  final Color noDataColor;

  const _HeatLegend({required this.noDataColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _LegendItem(
          color: Color(0xFF37B56A),
          label: 'Goal',
        ),
        const _LegendItem(
          color: Color(0xFF2E8AE6),
          label: 'Partial',
        ),
        const _LegendItem(
          color: Color(0xFFE65C5C),
          label: 'Missed',
        ),
        _LegendItem(
          color: noDataColor,
          label: 'No Data',
          labelColor: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final Color? labelColor;

  const _LegendItem({
    required this.color,
    required this.label,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: labelColor ?? AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
