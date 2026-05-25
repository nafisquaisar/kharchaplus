import 'package:expense_tracker/features/Track/WaterTracking/presentation/screens/water_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/water_tracking_entity.dart';
import '../../providers/water_tracking/water_tracking_home_providers.dart';

class WaterTrackingCard extends ConsumerWidget {
  const WaterTrackingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    final snapshot = ref.watch(waterTrackingHomeNotifierProvider);
    final drinking = snapshot.maybeWhen(
      data: (data) => data,
      orElse: () => null,
    );

    final todayMl = drinking?.todayIntakeMl ?? 0;
    final goalMl = drinking?.dailyGoalMl ?? 0;
    final progress = _safeProgress(drinking);
    final progressText = _formatPercent(progress);

    final intakeText = _formatLiters(todayMl);
    final goalText = _formatLiters(goalMl);

    final expenseValue = drinking?.monthlyExpense ?? 0;
    final expensePercent = drinking?.expensePercentChange ?? 0;
    final expenseTrend = _parseTrend(drinking?.expenseTrend);
    final expenseText = _formatCurrency(expenseValue);
    final trendText = _formatTrendPercent(expensePercent);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 6,
      ),
      padding: EdgeInsets.all(
        width * 0.03,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 TOP ROW
          InkWell(

            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const WaterScreen())
              );
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D8C82).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.water_drop_rounded,
                        size: 16,
                        color: const Color(0xFF2D8C82),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    Text(
                      "Water Tracking",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: width * 0.065,
                ),
              ],
            ),
          ),

          SizedBox(height: width * 0.02),

          /// 💧 DRINKING CARD
          _waterCard(
            context: context,
            width: width,
            icon: Icons.local_drink_rounded,
            title: "Drinking",
            value: intakeText,
            subValue: "/ $goalText",
            progress: progress,
            progressText: progressText,
            iconBg: const Color(0xFF2D8C82).withOpacity(0.12),
            iconColor: const Color(0xFF2D8C82),
          ),

          SizedBox(height: width * 0.02),

          /// 🚰 WATER MANAGEMENT
          Container(
            padding: EdgeInsets.all(
              width * 0.03,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                /// ICON
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D8C82).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.water_rounded,
                    color: const Color(0xFF2D8C82),
                    size: width * 0.06,
                  ),
                ),

                SizedBox(width: width * 0.03),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Water Management",
                        style: TextStyle(
                            color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.036,
                        ),
                      ),
                      SizedBox(
                        height: width * 0.008,
                      ),
                      Text(
                        expenseText,
                        style: TextStyle(
                            color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.055,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 📈 PERCENT
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D8C82).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _trendIcon(expenseTrend),
                        color: const Color(
                          0xFF2D8C82,
                        ),
                        size: width * 0.04,
                      ),
                      Text(
                        trendText,
                        style: TextStyle(
                          color: const Color(
                            0xFF2D8C82,
                          ),
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _safeProgress(WaterTrackingHomeEntity? data) {
    if (data == null) {
      return 0;
    }
    final value = data.intakePercent;
    if (value.isNaN || value.isInfinite) {
      return 0;
    }
    return value.clamp(0.0, 1.0);
  }

  String _formatLiters(int ml) {
    final liters = ml / 1000.0;
    final isWhole = (liters - liters.roundToDouble()).abs() < 0.01;
    final value = liters.toStringAsFixed(isWhole ? 0 : 1);
    return '${value}L';
  }

  String _formatPercent(double progress) {
    final percent = (progress * 100).round();
    return '${percent.clamp(0, 100)}%';
  }

  String _formatCurrency(double value) {
    final rounded = value.round();
    return '₹$rounded';
  }

  String _formatTrendPercent(double percent) {
    final safe = percent.isNaN || percent.isInfinite ? 0.0 : percent.abs();
    return '${safe.round()}%';
  }

  WaterExpenseTrend _parseTrend(String? value) {
    if (value == null) {
      return WaterExpenseTrend.flat;
    }
    return waterExpenseTrendFromValue(value);
  }

  IconData _trendIcon(WaterExpenseTrend trend) {
    switch (trend) {
      case WaterExpenseTrend.down:
        return Icons.arrow_downward_rounded;
      case WaterExpenseTrend.flat:
        return Icons.horizontal_rule_rounded;
      case WaterExpenseTrend.up:
      default:
        return Icons.arrow_upward_rounded;
    }
  }

  Widget _waterCard({
    required BuildContext context,
    required double width,
    required IconData icon,
    required String title,
    required String value,
    required String subValue,
    required double progress,
    required String progressText,
    required Color iconBg,
    required Color iconColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(
        width * 0.03,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: width * 0.06,
            ),
          ),

          SizedBox(width: width * 0.03),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.036,
                  ),
                ),
                SizedBox(
                  height: width * 0.006,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.06,
                        ),
                      ),
                      TextSpan(
                        text: " $subValue",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 📊 PROGRESS
          SizedBox(
            height: width * 0.18,
            width: width * 0.18,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: width * 0.18,
                  width: width * 0.18,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    backgroundColor: colorScheme.outlineVariant,
                    valueColor: AlwaysStoppedAnimation(
                      iconColor,
                    ),
                  ),
                ),
                Text(
                  progressText,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.w700,
                    fontSize: width * 0.04,
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
