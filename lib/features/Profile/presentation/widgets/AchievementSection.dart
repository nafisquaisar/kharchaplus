import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/core/constants/AppColors.dart';

import '../../../Achievements/presentation/view/achievement_screen.dart';
import '../../../Achievements/presentation/viewmodel/profile_achievement_viewmodel.dart';
import '../../data/models/profile_achievement_model.dart';
import 'profile_achievement_preview.dart';

class AchievementSection extends StatelessWidget {
  const AchievementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [
          // 🔥 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Achievements",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AchievementScreen(),
                    ),
                  );
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Compact SVG-only medal preview (Profile-specific)
          Selector<ProfileAchievementViewModel, List<ProfileAchievementModel>>(
            selector: (_, vm) => vm.items,
            builder: (context, items, _) {
              return ProfileAchievementPreview(items: items, maxBadges: 4);
            },
          ),
        ],
      ),
    );
  }
}
