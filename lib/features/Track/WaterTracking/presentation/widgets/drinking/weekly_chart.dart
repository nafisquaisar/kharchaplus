import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../screens/water_intake_history_screen.dart';

import '../../providers/analytics/water_analytics_provider.dart';

class WeeklyChart extends ConsumerWidget {
  const WeeklyChart({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final analyticsState = ref.watch(
      weeklyChartAnalyticsProvider,
    );

    final data = analyticsState.data.litersByWeekday;

    final isLoading = analyticsState.isLoading;
    final error = analyticsState.error;
    final isEmpty = data.every((value) => value == 0) && !isLoading;

    final days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    final today = DateTime.now().weekday;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================
          // HEADER
          // ======================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const WaterIntakeHistoryScreen();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.06),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                },
                child: const Text(
                  'View History',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else if (error != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'Failed to load weekly data',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else if (isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'No intake this week',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // ======================
          // CHART
          // ======================

          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                data.length,
                (index) {
                  final value = data[index];

                  final normalized = value > 3.0 ? 3.0 : value;

                  final barHeight = (normalized / 3.0) * 42 + 14;

                  final isSelected = today == index + 1;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${value.toStringAsFixed(1)}L',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 300,
                          ),
                          width: 14,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient:
                                isSelected ? AppColors.kharchaGradient : null,
                            color: isSelected
                                ? null
                                : AppColors.primary.withValues(
                                    alpha: 0.25,
                                  ),
                            borderRadius: BorderRadius.circular(
                              3,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          days[index],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.black
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
