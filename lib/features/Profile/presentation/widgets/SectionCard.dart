import 'package:flutter/material.dart';
import '../../../../core/constants/KharchaThemeColors.dart';
import '../../../../core/constants/colors.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;
  final Widget? action;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 HEADER ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: AppColors.primary),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              /// 🔹 OPTIONAL ACTION (e.g. "View All")
              if (action != null) action!,
            ],
          ),

          const SizedBox(height: 1),

          /// 🔹 DIVIDER (structure improve karta hai)
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.6),
          ),

          const SizedBox(height: 4),

          /// 🔹 CONTENT
          child,
        ],
      ),
    );
  }
}