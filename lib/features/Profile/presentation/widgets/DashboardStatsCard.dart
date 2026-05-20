import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/profile_streak_viewmodel.dart';
import '../../../Achievements/presentation/viewmodel/profile_achievement_viewmodel.dart';

class DashboardStatsCard extends StatelessWidget {
  const DashboardStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90, // increased a little
      margin: EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Selector<ProfileStreakViewModel, int>(
              selector: (_, vm) => vm.currentStreak,
              builder: (context, streak, _) {
                return _StatItem(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: Colors.orange,
                  value: streak.toString(),
                  title: "Day Streak",
                  subtitle: "Keep it up!",
                );
              },
            ),
          ),

          _buildDivider(),

          Expanded(
            child: Selector<ProfileAchievementViewModel, int>(
              selector: (_, vm) => vm.unlockedCount,
              builder: (context, count, _) {
                return _StatItem(
                  icon: Icons.emoji_events_rounded,
                  iconColor: Colors.amber,
                  value: count.toString(),
                  title: "Achievements",
                  subtitle: "",
                );
              },
            ),
          ),

          _buildDivider(),

          Expanded(
            child: Selector<ProfileStreakViewModel, String>(
              selector: (_, vm) => vm.monthlyGoalLabel,
              builder: (context, label, _) {
                return _StatItem(
                  icon: Icons.track_changes_rounded,
                  iconColor: Colors.blue,
                  value: label,
                  title: "Monthly Goal",
                  subtitle: "Completed",
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.grey.shade200,
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String title;
  final String subtitle;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 15,
              ),

              const SizedBox(width: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}