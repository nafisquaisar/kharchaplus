import 'package:flutter/material.dart';

class SummaryStatsRow extends StatelessWidget {
  final double totalExpense;
  final double totalIncome;
  final double balance;

  const SummaryStatsRow({
    super.key,
    required this.totalExpense,
    required this.totalIncome,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        _item(
          "Total Expense",
          totalExpense,
          Colors.red,
          Icons.arrow_downward,
          Colors.red.withOpacity(0.1),
          colorScheme,
        ),

        _divider(colorScheme),

        _item(
          "Total Income",
          totalIncome,
          Colors.green,
          Icons.trending_up,
          Colors.green.withOpacity(0.1),
          colorScheme,
        ),

        _divider(colorScheme),

        _item(
          "Balance",
          balance,
          colorScheme.onSurface,
          Icons.remove,
          Colors.blue.withOpacity(0.1),
          colorScheme,
        ),
      ],
    );
  }

  Widget _divider(ColorScheme colorScheme) {
    return Container(
      height: 40,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: colorScheme.outlineVariant,
    );
  }

  Widget _item(
      String title,
      double value,
      Color textColor,
      IconData icon,
      Color bgColor,
      ColorScheme colorScheme,
      ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "₹${value.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 4),

          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: textColor, size: 16),
          ),
        ],
      ),
    );
  }
}
