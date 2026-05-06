import 'package:flutter/material.dart';
import 'package:expense_tracker/core/constants/KharchaThemeColors.dart';

class ExpenseOverview extends StatelessWidget {
  const ExpenseOverview({super.key});

  Widget item(String title, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          // 🔥 ICON CONTAINER
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.kharchaGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),

          const SizedBox(height: 8),

          // 🔤 TITLE
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 2),

          // 💰 VALUE
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.colorText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 SECTION TITLE
          Text(
            "Expense Overview",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.colorText,
            ),
          ),

          const SizedBox(height: 14),

          // 📊 ROW ITEMS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              item("This Month", "₹12,450", Icons.account_balance_wallet),
              item("Daily Avg", "₹415", Icons.bar_chart),
              item("Top Category", "Food", Icons.pie_chart),
            ],
          ),
        ],
      ),
    );
  }
}