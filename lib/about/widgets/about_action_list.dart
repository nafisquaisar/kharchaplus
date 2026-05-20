import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';
import '../../help_support/help_support_screen.dart';
import 'about_action_tile.dart';

class AboutActionList extends StatelessWidget {
  const AboutActionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          AboutActionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: "help_support",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpSupportScreen()));
            },
          ),

          _divider(),

          AboutActionTile(
            icon: Icons.star_rounded,
            title: "Rate App",
            onTap: () => showComingSoonDialog(context),
          ),

          _divider(),

          AboutActionTile(
            icon: Icons.share_rounded,
            title: "Share App",
            onTap: () => showComingSoonDialog(context),
          ),
        ],
      ),
    );
  }

  void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: AppColors.accent,
                  size: 34,
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Coming Soon 🚀",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorText,
                ),
              ),

              const SizedBox(height: 12),

              /// MESSAGE
              const Text(
                "This feature will be available after the production release.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Got It",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 20,
      endIndent: 20,
    );
  }
}