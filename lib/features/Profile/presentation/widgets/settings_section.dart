import 'package:flutter/material.dart';
import 'package:expense_tracker/core/constants/AppColors.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          _settingsTile(
            title: "Settings & Preferences",
            subtitle: "Manage app settings",
            icon: Icons.settings,
            iconColor: const Color(0xFF0F8B8D),
            bgColor: const Color(0xFFE6F7F7),
          ),

          _divider(),

          _settingsTile(
            title: "Data & Backup",
            subtitle: "Export, Backup & Restore",
            icon: Icons.cloud_upload_rounded,
            iconColor: const Color(0xFF1D9BF0),
            bgColor: const Color(0xFFEAF4FF),
          ),

          _divider(),

          _settingsTile(
            title: "Help & Support",
            subtitle: "FAQs, Contact Support",
            icon: Icons.help_rounded,
            iconColor: const Color(0xFF22C55E),
            bgColor: const Color(0xFFEAFBF0),
          ),

          _divider(),

          _settingsTile(
            title: "About App",
            subtitle: "Version 1.0.0",
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFF8B5CF6),
            bgColor: const Color(0xFFF3EEFF),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: AppColors.border.withOpacity(0.6),
    );
  }

  Widget _settingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      child: Row(
        children: [
          // 🔥 ICON
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // 🔤 TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // ➡️ ARROW
          Icon(
            Icons.chevron_right_rounded,
            size: 22,
            color: Colors.grey.shade500,
          ),
        ],
      ),
    );
  }
}