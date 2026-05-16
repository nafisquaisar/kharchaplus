import 'package:flutter/material.dart';
import 'package:expense_tracker/core/constants/AppColors.dart';

class AchievementSection extends StatelessWidget {
  const AchievementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                  color: AppColors.black,
                ),
              ),

              Text(
                "View All",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🏆 ACHIEVEMENTS
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 10,
            runSpacing: 18,
            children: const [
              _AchievementItem(
                icon: Icons.water_drop_rounded,
                color: Color(0xFF14B8A6),
                title: "7 Days",
                subtitle: "Water Goal",
              ),

              _AchievementItem(
                icon: Icons.bolt_rounded,
                color: Color(0xFF0EA5E9),
                title: "On Time",
                subtitle: "Bill Payer",
              ),

              _AchievementItem(
                icon: Icons.star_rounded,
                color: Color(0xFFF59E0B),
                title: "Budget",
                subtitle: "Maintainer",
              ),

              _AchievementItem(
                icon: Icons.track_changes_rounded,
                color: Color(0xFF8B5CF6),
                title: "Expense",
                subtitle: "Tracker",
              ),

              _AchievementItem(
                icon: Icons.local_fire_department_rounded,
                color: Color(0xFFF97316),
                title: "Streak",
                subtitle: "Master",
              ),
            ],
          ),


        ],
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _AchievementItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          // 🔥 ICON BOX
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.9),
                  color,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.circular(16),

              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                ),
              ),

              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 🔤 TITLE
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 2),

          // 🔤 SUBTITLE
          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              height: 1.15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}