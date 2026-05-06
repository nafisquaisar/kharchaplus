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
    return Row(
      children: [
        _item(
          "Total Expense",
          totalExpense,
          Colors.red,
          Icons.arrow_downward,
          Colors.red.withOpacity(0.1),
        ),

        _divider(),

        _item(
          "Total Income",
          totalIncome,
          Colors.green,
          Icons.trending_up,
          Colors.green.withOpacity(0.1),
        ),

        _divider(),

        _item(
          "Balance",
          balance,
          Colors.black,
          Icons.remove,
          Colors.blue.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.grey.shade300,
    );
  }

  Widget _item(
      String title,
      double value,
      Color textColor,
      IconData icon,
      Color bgColor,
      ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
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
