import 'package:flutter/material.dart';

import '../../data/models/profile_achievement_model.dart';
import 'achievement_badge.dart';

/// Compact medal-only preview used on the Profile page.
///
/// Shows only large floating achievement badges.
class ProfileAchievementPreview extends StatelessWidget {
  final List<ProfileAchievementModel> items;
  final int maxBadges;

  const ProfileAchievementPreview({
    super.key,
    required this.items,
    this.maxBadges = 4,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = items.where((item) => item.isUnlocked).toList(growable: false)
      ..sort((a, b) {
        final aTime = a.unlockedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.unlockedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

    final preview = unlocked.take(maxBadges).toList(growable: false);

    if (preview.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 2.0; // reduced spacing

        final rawSize = (constraints.maxWidth - (spacing * 3)) / 4;
        final badgeSize = rawSize.clamp(68.0, 90.0);

        return RepaintBoundary(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: preview
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                  padding: EdgeInsets.only(
                    right: entry.key == preview.length - 1 ? 0 : spacing,
                  ),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    tween: Tween(begin: 0.9, end: 1),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: AchievementBadge(
                      achievementId: entry.value.achievementId,
                      unlocked: true,
                      size: badgeSize,
                    ),
                  ),
                ),
              )
                  .toList(growable: false),
            ),
          ),
        );
      },
    );
  }
}