import 'package:flutter/material.dart';
import '../../../../../../core/constants/KharchaThemeColors.dart';

class DateTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final IconData? icon;

  const DateTile({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == "Select date";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          children: [
            /// 🔥 ICON
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon ?? Icons.calendar_today,
                size: 18,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 12),

            /// 🔥 TEXT SECTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  /// VALUE
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isEmpty
                          ? AppColors.textSecondary
                          : AppColors.colorText,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 ARROW (UX improvement)
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}