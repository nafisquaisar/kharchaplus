import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

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
  State<CalendarWidget> createState() =>
      _CalendarWidgetState();
}

class _CalendarWidgetState
    extends State<CalendarWidget> {

  late DateTime visibleMonth;

  @override
  void initState() {

    super.initState();

    visibleMonth =
        _monthStart(widget.selectedDate);
  }

  @override
  void didUpdateWidget(
      covariant CalendarWidget oldWidget,
      ) {

    super.didUpdateWidget(oldWidget);

    if (!_sameMonth(
      oldWidget.selectedDate,
      widget.selectedDate,
    )) {

      visibleMonth =
          _monthStart(widget.selectedDate);
    }
  }

  DateTime _monthStart(DateTime date) {

    return DateTime(
      date.year,
      date.month,
    );
  }

  bool _sameMonth(
      DateTime a,
      DateTime b,
      ) {

    return a.year == b.year &&
        a.month == b.month;
  }

  DateTime get _minMonth =>
      _monthStart(widget.cycleStartDate);

  DateTime get _maxMonth =>
      _monthStart(widget.cycleEndDate);

  bool get canGoPrevious =>
      visibleMonth.isAfter(_minMonth);

  bool get canGoNext =>
      visibleMonth.isBefore(_maxMonth);

  void _changeMonth(int offset) {

    final next = DateTime(
      visibleMonth.year,
      visibleMonth.month + offset,
    );

    if (next.isBefore(_minMonth) ||
        next.isAfter(_maxMonth)) {

      return;
    }

    setState(() {

      visibleMonth = next;
    });
  }

  void _handleSwipe(
      DragEndDetails details,
      ) {

    final velocity =
        details.primaryVelocity ?? 0;

    // SWIPE RIGHT
    if (velocity > 0) {

      if (canGoPrevious) {
        _changeMonth(-1);
      }
    }

    // SWIPE LEFT
    else if (velocity < 0) {

      if (canGoNext) {
        _changeMonth(1);
      }
    }
  }


  List<DateTime?> _monthDates() {

    final start =
    normalizeDate(widget.cycleStartDate);

    final end =
    normalizeDate(widget.cycleEndDate);

    final firstDayOfMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month,
      1,
    );

    final lastDayOfMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    );

    // SUNDAY = 0
    final firstWeekday =
        firstDayOfMonth.weekday % 7;

    final List<DateTime?> dates = [];

    // EMPTY SPACES
    for (int i = 0; i < firstWeekday; i++) {

      dates.add(null);
    }

    // REAL DATES
    DateTime current = firstDayOfMonth;

    while (!current.isAfter(lastDayOfMonth)) {

      final normalized =
      normalizeDate(current);

      final insideRange =

          !normalized.isBefore(start) &&
              !normalized.isAfter(end);

      dates.add(
        insideRange ? current : null,
      );

      current = current.add(
        const Duration(days: 1),
      );
    }

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

    return
      '${names[visibleMonth.month - 1]} '
          '${visibleMonth.year}';
  }


  String _monthName(int month) {

    const months = [

      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",

      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {

    final dates = _monthDates();

    return GestureDetector(

        onHorizontalDragEnd:
        _handleSwipe,

      child: Container(

        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),

        decoration: BoxDecoration(

          color: AppColors.card,

          borderRadius:
          BorderRadius.circular(24),

          boxShadow: [

            BoxShadow(

              color:
              AppColors.accent.withOpacity(
                0.08,
              ),

              blurRadius: 18,

              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(

          children: [

            // =========================
            // MONTH HEADER
            // =========================

            Container(

              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),

              decoration: const BoxDecoration(

                gradient: AppColors.kharchaGradient,

                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),

              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  // =========================
                  // MONTH HEADER
                  // =========================

                  Row(

                    children: [

                      _navButton(

                        icon:
                        Icons.chevron_left_rounded,

                        enabled: canGoPrevious,

                        onTap: () {
                          _changeMonth(-1);
                        },
                      ),

                      Expanded(

                        child: Text(

                          _monthTitle,

                          textAlign: TextAlign.center,

                          style: const TextStyle(

                            fontSize: 17,

                            fontWeight: FontWeight.bold,

                            color: Colors.white,
                          ),
                        ),
                      ),

                      _navButton(

                        icon:
                        Icons.chevron_right_rounded,

                        enabled: canGoNext,

                        onTap: () {
                          _changeMonth(1);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // =========================
                  // DATE RANGE
                  // =========================

                  Text(

                    "${widget.cycleStartDate.day} "
                        "${_monthName(widget.cycleStartDate.month)}"
                        " → "
                        "${widget.cycleEndDate.day} "
                        "${_monthName(widget.cycleEndDate.month)}",

                    style: const TextStyle(

                      fontSize: 11,

                      color: Colors.white70,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // =========================
            // WEEK HEADER
            // =========================

            const Padding(

              padding:
              EdgeInsets.symmetric(
                horizontal: 10,
              ),

              child: WeekHeader(),
            ),

            const SizedBox(height: 4),

            // =========================
            // CALENDAR GRID
            // =========================

            Expanded(

              child: dates.isEmpty

                  ? Center(

                child: Text(

                  'No dates available',

                  style: TextStyle(

                    color:
                    AppColors.textSecondary,

                    fontSize: 14,
                  ),
                ),
              )

                  : GridView.builder(

                padding:
                const EdgeInsets.all(10),

                physics:
                const BouncingScrollPhysics(),

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 7,

                  childAspectRatio: 0.88,

                  mainAxisSpacing: 8,

                  crossAxisSpacing: 8,
                ),

                itemCount: dates.length,

                itemBuilder: (_, i) {

                  final date = dates[i];

                  if (date == null) {
                    return const SizedBox.shrink();
                  }

                  final key =
                  getKey(date);

                  final data =
                      widget.mealData[key] ??
                          {
                            'lunch': false,
                            'dinner': false,
                            'special': false,
                          };

                  return CalendarDay(

                    date: date,

                    selected: isSameDay(
                      date,
                      widget.selectedDate,
                    ),

                    lunch:
                    data['lunch'] ?? false,

                    dinner:
                    data['dinner'] ?? false,

                    special:
                    data['special'] ?? false,

                    onTap: () {

                      widget.onDateTap(date);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton({

    required IconData icon,

    required bool enabled,

    required VoidCallback onTap,
  }) {

    return InkWell(

      onTap:
      enabled ? onTap : null,

      borderRadius:
      BorderRadius.circular(12),

      child: Container(

        padding:
        const EdgeInsets.all(6),

        decoration: BoxDecoration(

          color: enabled

              ? Colors.white.withOpacity(
            0.18,
          )

              : Colors.white.withOpacity(
            0.08,
          ),

          borderRadius:
          BorderRadius.circular(12),
        ),

        child: Icon(

          icon,

          color: enabled
              ? Colors.white
              : Colors.white38,

          size: 22,
        ),
      ),
    );
  }
}