import 'package:flutter/material.dart';
import 'package:expense_tracker/core/constants/KharchaThemeColors.dart';

class UtilitiesSection extends StatelessWidget {
  const UtilitiesSection({super.key});

  Widget card(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.border),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 ICON WITH BACKGROUND
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 10),

            // 🔤 TITLE
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 4),

            // 💰 VALUE
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.colorText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 SECTION HEADER
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            "Utilities Tracking",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.colorText,
            ),
          ),
        ),

        // 📦 GRID STYLE ROW
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: const [
              Expanded(child: SizedBox()), // spacing balance trick
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              card("Mess", "20 Tiffin", Icons.fastfood),
              card("Water", "₹350", Icons.water_drop),
              card("Electric", "₹1240", Icons.flash_on),
              card("Rent", "₹5000", Icons.home),
            ],
          ),
        ),
      ],
    );
  }
}