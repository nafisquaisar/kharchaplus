import 'package:flutter/material.dart';

import 'calendar_day.dart';
import 'meal_date_key.dart';
import 'week_header.dart';

class CalendarWidget extends StatefulWidget {
  final Map<String, Map<String, bool>> mealData;
  final DateTime selectedDate;
  final DateTime cycleStartDate;
  final DateTime cycleEndDate;
  final ValueChanged<DateTime> onDateTap;

  const CalendarWidget({
    super.key,
    required this.mealData,
    required this.selectedDate,
    required this.cycleStartDate,
    required this.cycleEndDate,
    required this.onDateTap,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime visibleMonth;

  @override
  void initState() {
    super.initState();
    visibleMonth = _monthStart(widget.selectedDate);
  }

  @override
  void didUpdateWidget(covariant CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameMonth(oldWidget.selectedDate, widget.selectedDate)) {
      visibleMonth = _monthStart(widget.selectedDate);
    }
  }

  DateTime _monthStart(DateTime date) => DateTime(date.year, date.month);

  bool _sameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  DateTime get _minMonth => _monthStart(widget.cycleStartDate);
  DateTime get _maxMonth => _monthStart(widget.cycleEndDate);

  bool get canGoPrevious => visibleMonth.isAfter(_minMonth);
  bool get canGoNext => visibleMonth.isBefore(_maxMonth);

  void _changeMonth(int offset) {
    final next = DateTime(visibleMonth.year, visibleMonth.month + offset);
    if (next.isBefore(_minMonth) || next.isAfter(_maxMonth)) {
      return;
    }
    setState(() => visibleMonth = next);
  }

  List<DateTime> _monthDates() {
    final start = normalizeDate(widget.cycleStartDate);
    final end = normalizeDate(widget.cycleEndDate);
    final dates = widget.mealData.keys
        .map(dateFromKey)
        .whereType<DateTime>()
        .where((date) {
          final normalized = normalizeDate(date);
          final insideRange =
              !normalized.isBefore(start) && !normalized.isAfter(end);
          final insideMonth = normalized.year == visibleMonth.year &&
              normalized.month == visibleMonth.month;
          return insideRange && insideMonth;
        })
        .toList()
      ..sort((a, b) => a.compareTo(b));
    return dates;
  }

  String get _monthTitle {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${names[visibleMonth.month - 1]} ${visibleMonth.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dates = _monthDates();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Row(
            children: [
              IconButton(
                onPressed: canGoPrevious ? () => _changeMonth(-1) : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  _monthTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: canGoNext ? () => _changeMonth(1) : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        const WeekHeader(),
        Expanded(
          child: dates.isEmpty
              ? const Center(child: Text('No dates in this month'))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: dates.length,
                  itemBuilder: (_, i) {
                    final date = dates[i];
                    final key = getKey(date);
                    final data = widget.mealData[key] ?? {
                      'lunch': false,
                      'dinner': false,
                    };

                    return CalendarDay(
                      date: date,
                      selected: isSameDay(date, widget.selectedDate),
                      lunch: data['lunch'] ?? false,
                      dinner: data['dinner'] ?? false,
                      onTap: () => widget.onDateTap(date),
                    );
                  },
                ),
        ),
      ],
    );
  }
}