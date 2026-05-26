import 'package:expense_tracker/features/Expense/presentation/widgets/ExpenseDetail/summary_header.dart';
import 'package:expense_tracker/features/Expense/presentation/widgets/ExpenseDetail/summary_stats_row.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String startDate;
  final String endDate;

  final double totalExpense;
  final double totalIncome;
  final double balance;

  final String trendText;

  const SummaryCard({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.totalExpense,
    required this.totalIncome,
    required this.balance,
    required this.trendText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.09),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [

          /// 🔥 HEADER + TREND (IMPORTANT CHANGE)
          Align(
            alignment: Alignment.centerLeft,

            child: SummaryHeader(

              startDate: startDate,

              endDate: endDate,

              trendText: trendText,
            ),
          ),


          Container(
            height: 1,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: colorScheme.outlineVariant,
          ),

          /// 🔥 STATS
          SummaryStatsRow(
            totalExpense: totalExpense,
            totalIncome: totalIncome,
            balance: balance,
          ),
        ],
      ),
    );
  }
}