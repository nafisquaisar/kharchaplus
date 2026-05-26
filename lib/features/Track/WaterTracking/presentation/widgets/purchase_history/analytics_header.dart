import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../providers/purchase_history/purchase_history_provider.dart';

class PurchaseHistoryAnalyticsHeader extends StatelessWidget {
  final PurchaseHistoryAnalytics analytics;

  const PurchaseHistoryAnalyticsHeader({
    super.key,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: colorScheme.surface,

        borderRadius: BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  title: 'Total Expense',
                  value:
                  '₹${analytics.totalExpense.toStringAsFixed(0)}',
                  icon: Icons.currency_rupee_rounded,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _MetricTile(
                  title: 'Purchases',
                  value: '${analytics.totalPurchases}',
                  icon: Icons.shopping_bag_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  title: 'Tanker Count',
                  value: '${analytics.tankerCount}',
                  icon: Icons.local_shipping_rounded,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _MetricTile(
                  title: 'Avg Monthly',
                  value:
                  '₹${analytics.averageMonthlyExpense.toStringAsFixed(0)}',
                  icon: Icons.bar_chart_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final valueFontSize =
    screenWidth < 360 ? 16.0 : 18.0;

    return Container(
      height: 68,

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        gradient: AppColors.kharchaGradient,

        borderRadius: BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color:
            AppColors.primary.withOpacity(0.10),

            blurRadius: 6,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),

              borderRadius:
              BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 10,

                    fontWeight: FontWeight.w500,

                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: valueFontSize,

                    fontWeight: FontWeight.w700,

                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}