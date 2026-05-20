import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';
import 'achievement_badge.dart';

class AchievementEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onRefresh;

  const AchievementEmptyState({
    super.key,
    this.title = 'No achievements yet',
    this.subtitle = 'Start tracking to unlock your first badge.',
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: AchievementBadge(
                achievementId: '30_day_streak',
                unlocked: false,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

