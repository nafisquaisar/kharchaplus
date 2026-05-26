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
            bestStreak: streakAnalytics.isLoading
                ? 0
                : streakAnalytics.data.bestStreak,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.04),
                blurRadius: 8,
                offset:  Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Icon(
                Icons.track_changes_outlined,
                size: 18,
                color: colorScheme.onSurface,
              ),

               SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Text(
                      'Daily Goal',
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      isLoading ? '...' : goalText,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children:  [
                        Text(
                          'Edit Goal',
                          style: textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),

                        SizedBox(width: 3),

                        Icon(
                          Icons.edit_outlined,
                          size: 12,
                          color: colorScheme.onSurface,
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
  final int bestStreak;

  const _StreakCard({
    required this.streakText,
    required this.bestStreak,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
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
                 Text(
                  'Streak',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  streakText,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Best: $bestStreak Days',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          const Text(
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