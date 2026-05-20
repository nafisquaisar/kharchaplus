import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';
import '../../../Profile/data/models/profile_achievement_model.dart';
import 'achievement_badge.dart';

class AchievementCard extends StatelessWidget {
  final ProfileAchievementModel achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final progress = _progressValue(achievement);

    final gradient = achievement.isUnlocked
        ? LinearGradient(
            colors: [
              AppColors.accent.withAlpha(18),
              AppColors.accent.withAlpha(10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        final isSmall = cardWidth < 180;

        /// RESPONSIVE SIZES
        final badgeSize = isSmall ? 78.0 : 96.0;

        final titleFont = isSmall ? 13.0 : 15.0;

        final descFont = isSmall ? 11.0 : 12.0;

        final chipFont = isSmall ? 9.0 : 10.0;

        final horizontalPadding = isSmall ? 8.0 : 12.0;

        final verticalPadding = isSmall ? 10.0 : 14.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: achievement.isUnlocked
                  ? AppColors.accent.withAlpha(90)
                  : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP ROW
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// BADGE
                  GestureDetector(
                    onTap: () => _showBadgePreview(context),
                    child: RepaintBoundary(
                      child: Hero(
                        tag: achievement.achievementId,
                        child: _BadgeFrame(
                          achievementId: achievement.achievementId,
                          unlocked: achievement.isUnlocked,
                          size: badgeSize,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// STATUS CHIP
                  Align(
                    alignment: Alignment.topRight,
                    child: _StatusChip(
                      isUnlocked: achievement.isUnlocked,
                      fontSize: chipFont,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmall ? 10 : 14),

              /// TITLE
              Text(
                achievement.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleFont,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: AppColors.colorText,
                ),
              ),

              SizedBox(height: isSmall ? 6 : 8),

              /// DESCRIPTION
              Expanded(
                child: Text(
                  achievement.description,
                  maxLines: isSmall ? 3 : 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: descFont,
                    height: 1.45,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: isSmall ? 10 : 12),

              /// META ROW
              _MetaRow(
                category: achievement.category,
                label: _progressLabel(
                  achievement,
                  progress,
                ),
              ),

              const SizedBox(height: 10),

              /// PROGRESS BAR
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: achievement.isUnlocked ? 1 : progress,
                  minHeight: 7,
                  backgroundColor: AppColors.border,
                  color: achievement.isUnlocked
                      ? AppColors.accent
                      : AppColors.accent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// BADGE PREVIEW
  void _showBadgePreview(BuildContext context) {
    /// ONLY UNLOCKED
    if (!achievement.isUnlocked) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Badge Preview',
      barrierColor: Colors.black.withOpacity(0.75),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: 0.7,
                  end: 1,
                ),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Hero(
                  tag: achievement.achievementId,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withOpacity(0.18),
                          AppColors.accent.withOpacity(0.10),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.25),
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: _BadgeFrame(
                        achievementId: achievement.achievementId,
                        unlocked: true,
                        size: 300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  double _progressValue(ProfileAchievementModel achievement) {
    if (achievement.goal <= 0) return 0;

    return (achievement.progress / achievement.goal).clamp(0.0, 1.0);
  }

  String _progressLabel(
    ProfileAchievementModel achievement,
    double progress,
  ) {
    if (achievement.isUnlocked) return 'Unlocked';

    return '${(progress * 100).toStringAsFixed(0)}% complete';
  }
}

class AchievementListItem extends StatelessWidget {
  final ProfileAchievementModel achievement;

  const AchievementListItem({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final progress = achievement.goal <= 0
        ? 0.0
        : (achievement.progress / achievement.goal).clamp(0.0, 1.0);

    final gradient = achievement.isUnlocked
        ? LinearGradient(
            colors: [
              AppColors.accent.withAlpha(16),
              AppColors.accent.withAlpha(8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: achievement.isUnlocked
              ? AppColors.accent.withAlpha(82)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// BADGE
          RepaintBoundary(
            child: _BadgeFrame(
              achievementId: achievement.achievementId,
              unlocked: achievement.isUnlocked,
              size: 58,
            ),
          ),

          const SizedBox(width: 12),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _StatusChip(
                          isUnlocked: achievement.isUnlocked,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                _MetaRow(
                  category: achievement.category,
                  label: achievement.isUnlocked
                      ? 'Unlocked'
                      : '${(progress * 100).toStringAsFixed(0)}% complete',
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: achievement.isUnlocked ? 1 : progress,
                    minHeight: 5,
                    backgroundColor: AppColors.border,
                    color: achievement.isUnlocked
                        ? AppColors.accent
                        : AppColors.accent,
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

class _BadgeFrame extends StatelessWidget {
  final String achievementId;
  final bool unlocked;
  final double size;

  const _BadgeFrame({
    required this.achievementId,
    required this.unlocked,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: unlocked
              ? [
                  AppColors.accent.withOpacity(0.16),
                  AppColors.accent.withOpacity(0.10),
                ]
              : [
                  AppColors.border.withOpacity(0.35),
                  AppColors.border.withOpacity(0.18),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: unlocked
                ? AppColors.accent.withOpacity(0.10)
                : Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AchievementBadge(
        achievementId: achievementId,
        unlocked: unlocked,
        size: size - (size * 0.24),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isUnlocked;
  final double fontSize;

  const _StatusChip({
    required this.isUnlocked,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final background = isUnlocked
        ? AppColors.accent.withOpacity(0.12)
        : AppColors.border.withOpacity(0.6);

    final foreground = isUnlocked ? AppColors.accent : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isUnlocked ? 'Unlocked' : 'Locked',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String category;
  final String label;

  const _MetaRow({
    required this.category,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _prettyCategory(category),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.colorText,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 3,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _prettyCategory(String value) {
    switch (value) {
      case 'water':
        return 'Water';

      case 'electricity':
        return 'Electricity';

      case 'expense':
        return 'Expense';

      case 'savings':
        return 'Savings';

      case 'streak':
        return 'Streak';

      default:
        return value;
    }
  }
}
