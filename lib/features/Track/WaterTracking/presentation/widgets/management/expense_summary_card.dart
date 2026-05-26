import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../providers/analytics/water_analytics_provider.dart';
import '../../providers/filters/expense_filter_provider.dart';
import '../../../domain/enum/purchase_type.dart';

class ExpenseSummaryCard extends ConsumerWidget {
  const ExpenseSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(expenseAnalyticsProvider);
    final analytics = analyticsState.data;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selected = ref.watch(selectedMonthProvider);
    final selectedDate = DateTime(selected.year, selected.month, 1);
    final previousMonth = DateTime(selected.year, selected.month - 1, 1);
    final monthLabel = _monthName(selected.month);
    final prevMonthLabel = _monthName(previousMonth.month);

    final currentTotal = analytics.monthlyExpense;
    final totalPurchases = analytics.totalPurchases;
    final tankerQty =
        analytics.purchaseCountByType[PurchaseType.tanker] ?? 0;
    final previousTotal = analytics.previousMonthExpense;
    final hasPrevious = previousTotal > 0;
    final diff = currentTotal - previousTotal;
    final percent = hasPrevious ? ((diff / previousTotal) * 100).abs() : 0.0;
    final isIncrease = diff >= 0;

    final isLoading = analyticsState.isLoading;
    final error = analyticsState.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // TOP HEADER
          // =========================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'This Month Expense',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),

              GestureDetector(
                onTap: () => _openMonthYearPicker(context, ref),
                child: Row(
                  children: [
                    Text(
                      '$monthLabel ${selectedDate.year}',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                     SizedBox(width: 2),

                     Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (isLoading)
             Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else if (error != null)
             Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Failed to load summary',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 14),

          // =========================
          // MAIN CONTENT
          // =========================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // LEFT MAIN AMOUNT
              // =========================

              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  Icon(
                            Icons.account_balance_wallet_outlined,
                            color: colorScheme.onSurface,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            '₹${currentTotal.toStringAsFixed(0)}',
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Text(
                          'vs $prevMonthLabel ${previousMonth.year}',
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Icon(
                          isIncrease
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 14,
                          color: isIncrease ? Colors.red : Colors.green,
                        ),

                        const SizedBox(width: 2),

                        Text(
                          '${percent.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isIncrease ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // =========================
              // RIGHT SMALL STATS
              // =========================

              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildMiniInfo(
                      context,
                      icon: Icons.local_drink_outlined,
                      title: 'Purchases',
                      value: '$totalPurchases',
                    ),

                    const SizedBox(height: 8),

                    _buildMiniInfo(
                      context,
                      icon: Icons.water_drop_outlined,
                      title: 'Tanker',
                      value: '$tankerQty',
                    ),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildMiniInfo(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              icon,
              size: 14,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  Future<void> _openMonthYearPicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const _MonthYearPickerSheet();
      },
    );
  }
}

class _MonthYearPickerSheet extends ConsumerStatefulWidget {
  const _MonthYearPickerSheet();

  @override
  ConsumerState<_MonthYearPickerSheet> createState() =>
      _MonthYearPickerSheetState();
}

class _MonthYearPickerSheetState extends ConsumerState<_MonthYearPickerSheet> {
  late FixedExtentScrollController _yearController;
  late List<int> _years;

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final selected = ref.read(selectedMonthProvider);
    final startYear = now.year - 20;
    final endYear = now.year + 20;

    _years = List.generate(
      endYear - startYear + 1,
      (index) => startYear + index,
    );

    final initialIndex =
        (selected.year - startYear).clamp(0, _years.length - 1);
    _yearController = FixedExtentScrollController(
      initialItem: initialIndex,
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  void _updateSelection({
    int? month,
    int? year,
  }) {
    final current = ref.read(selectedMonthProvider);
    final next = MonthYear(
      month: month ?? current.month,
      year: year ?? current.year,
    );

    if (next.month == current.month && next.year == current.year) {
      return;
    }

    ref.read(selectedMonthProvider.notifier).state = next;
  }

  void _jumpToCurrentMonth() {
    final now = DateTime.now();
    final startYear = _years.first;
    final index = now.year - startYear;

    if (index >= 0 && index < _years.length) {
      _yearController.animateToItem(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }

    _updateSelection(month: now.month, year: now.year);
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedMonthProvider);
    final now = DateTime.now();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4,
              width: 36,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Month',
                style: textTheme.titleSmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red.withOpacity(0.6),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_months.length, (index) {
              final monthIndex = index + 1;
              final isSelected = selected.month == monthIndex;
              final isCurrent =
                  now.month == monthIndex && selected.year == now.year;

              return ChoiceChip(
                label: Text(_months[index]),
                selected: isSelected,
                onSelected: (_) => _updateSelection(month: monthIndex),
                selectedColor: AppColors.accent,
                backgroundColor: colorScheme.surfaceContainerHighest,
                side: BorderSide(
                  color: isSelected
                      ? AppColors.accent
                      : isCurrent
                          ? AppColors.accent
                          : colorScheme.outlineVariant,
                ),
                labelStyle: TextStyle(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            'Year',
            style: textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: ListWheelScrollView.useDelegate(
              controller: _yearController,
              itemExtent: 36,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                _updateSelection(year: _years[index]);
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: _years.length,
                builder: (context, index) {
                  final year = _years[index];
                  final isSelected = year == selected.year;
                  final isCurrentYear = year == now.year;

                  return Center(
                    child: Text(
                      '$year',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.accent
                            : isCurrentYear
                                ? AppColors.colorText
                                : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: _jumpToCurrentMonth,
                child: const Text(
                  'This Month',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Done'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
