import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../providers/analytics/water_analytics_provider.dart';
import '../../bottomsheet/update_goal_sheet.dart';

class GoalStreakCards extends ConsumerWidget {
  const GoalStreakCards({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waterAnalytics = ref.watch(waterIntakeAnalyticsProvider);
    final streakAnalytics = ref.watch(streakAnalyticsProvider);

    final goalText =
        '${(waterAnalytics.data.dailyGoalMl / 1000).toStringAsFixed(1)} L';
    final streakText = streakAnalytics.isLoading
        ? '...'
        : '${streakAnalytics.data.currentStreak} Days';

    return Row(
      children: [
        Expanded(
          child: _GoalCard(
            goalText: goalText,
            isLoading: waterAnalytics.isLoading,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const UpdateGoalSheet(),
              );
            },
          ),
        ),

        SizedBox(width: 10),

        Expanded(
          child: _StreakCard(
            streakText: streakText,
          ),
        ),
      ],
    );
  }
}

// ==============================
// DAILY GOAL CARD
// ==============================

class _GoalCard extends StatelessWidget {
  final String goalText;
  final bool isLoading;
  final VoidCallback? onTap;

  const _GoalCard({
    required this.goalText,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.track_changes_outlined,
                size: 18,
                color: AppColors.colorText,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Daily Goal',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      isLoading ? '...' : goalText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: const [
                        Text(
                          'Edit Goal',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.colorText,
                          ),
                        ),

                        SizedBox(width: 3),

                        Icon(
                          Icons.edit_outlined,
                          size: 12,
                          color: AppColors.colorText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==============================
// STREAK CARD
// ==============================

class _StreakCard extends StatelessWidget {
  final String streakText;

  const _StreakCard({
    required this.streakText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Streak',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  streakText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'Best: 12 Days',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 6),

          Text(
            '🔥',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}