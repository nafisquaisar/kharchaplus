import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../../../core/constants/AppColors.dart';

import '../../providers/analytics/water_analytics_provider.dart';

class WaterProgressCard extends ConsumerWidget {
  const WaterProgressCard({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final analyticsState = ref.watch(
      waterIntakeAnalyticsProvider,
    );

    final analytics = analyticsState.data;

    final totalL = (analytics.todayMl / 1000).toStringAsFixed(1);
    final remainingL = analytics.remainingMl <= 0
        ? '0'
        : (analytics.remainingMl / 1000).toStringAsFixed(1);
    final percent = (analytics.intakePercent * 100).toInt();
    final progress = analytics.intakePercent.clamp(0.0, 1.0);

    final isLoading = analyticsState.isLoading;
    final error = analyticsState.error;
    final isEmpty = analytics.todayMl == 0 && !isLoading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
        children: [
          // =========================
          // TOP
          // =========================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                "Today's Progress",
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                "${DateTime.now().day} "
                "${_monthName(DateTime.now().month)}, "
                "${DateTime.now().year}",
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 1),

          if (isLoading)
             Padding(
              padding: EdgeInsets.only(top: 4),
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
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Failed to load data',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else if (isEmpty)
             Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'No intake yet today',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // =========================
          // MAIN CONTENT
          // =========================

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 7,
                  percent: progress,
                  animation: true,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: AppColors.border,
                  linearGradient: AppColors.kharchaGradient,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${totalL}L",
                        style:  TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "of ${(analytics.dailyGoalMl / 1000).toStringAsFixed(1)}L",
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        "$percent%",
                        style:  TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 75,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildInfoTile(
                      context,
                      icon: Icons.water_drop_outlined,
                      title: "${remainingL}L",
                      subtitle: "Remaining",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Divider(
                        color: colorScheme.outlineVariant,
                        height: 1,
                      ),
                    ),
                    _buildInfoTile(
                      context,
                      icon: Icons.track_changes_outlined,
                      title: "${(analytics.dailyGoalMl / 1000).toStringAsFixed(1)}L",
                      subtitle: "Daily Goal",
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 1),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Icon(
                  Icons.water_drop,
                  color: AppColors.primary,
                  size: 14,
                ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "Great job! Keep drinking water",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.onSurface,
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 9,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _monthName(
    int month,
  ) {
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
}
