import 'package:flutter/material.dart';
import 'package:expense_tracker/core/constants/AppColors.dart';

class ExpenseOverview extends StatelessWidget {
  const ExpenseOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 TITLE
          Text(
            "Overview This Month",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 14),

          // 📊 GRID
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Expanded(
                child: _overviewCard(
                  context,
                  icon: Icons.account_balance_wallet_rounded,
                  iconBg: const Color(0xFFE7F8F7),
                  iconColor: AppColors.primary,
                  title: "Total Expense",
                  value: "₹12,450",
                  change: "12%",
                  isUp: false,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _overviewCard(
                  context,
                  icon: Icons.trending_up_rounded,
                  iconBg: const Color(0xFFEAF8EC),
                  iconColor: const Color(0xFF22C55E),
                  title: "Total Income",
                  value: "₹16,650",
                  change: "8%",
                  isUp: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _overviewCard(
                  context,
                  icon: Icons.bolt_rounded,
                  iconBg: const Color(0xFFFFF4E5),
                  iconColor: const Color(0xFFF59E0B),
                  title: "Electricity Units",
                  value: "66 Units",
                  change: "22%",
                  isUp: false,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _overviewCard(
                  context,
                  icon: Icons.water_drop_rounded,
                  iconBg: const Color(0xFFE8F3FF),
                  iconColor: const Color(0xFF3B82F6),
                  title: "Water Intake",
                  value: "84 L",
                  change: "10%",
                  isUp: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewCard(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String value,
    required String change,
    required bool isUp,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final resolvedIconBg = isDark ? iconColor.withOpacity(0.15) : iconBg;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🔥 ICON
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: resolvedIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),

          const SizedBox(height: 14),

          // 🔤 TITLE
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 4),

          // 💰 VALUE
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          // 📈 CHANGE
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUp
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 12,
                color:
                isUp ? const Color(0xFF22C55E) : Colors.red,
              ),

              const SizedBox(width: 2),

              Text(
                "$change vs Apr",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color:
                  isUp ? const Color(0xFF22C55E) : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}