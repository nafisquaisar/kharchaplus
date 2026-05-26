import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class FoodBottomSheetHeader extends StatelessWidget {
  final String title;

  final String subtitle;

  final bool isUpdate;

  const FoodBottomSheetHeader({
    super.key,

    required this.title,

    this.subtitle = "Track meals ",

    this.isUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        /// 🔘 HANDLE
        Center(
          child: Container(
            width: 42,

            height: 5,

            margin: const EdgeInsets.only(bottom: 18),

            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,

              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),

        /// 🔥 HEADER CARD
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

          decoration: BoxDecoration(
            color: colorScheme.surface,

            borderRadius: BorderRadius.circular(10),

            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.12),

                blurRadius: 10,

                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              /// ICON BOX
              Container(
                height: 42,

                width: 42,

                decoration: BoxDecoration(
                  color: isUpdate
                      ? Colors.blue.withOpacity(0.12)
                      : AppColors.primarybg,

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  isUpdate ? Icons.edit_rounded : Icons.restaurant_rounded,

                  color: isUpdate ? Colors.blue : AppColors.primary,

                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              /// TITLE + SUBTITLE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: textTheme.titleSmall?.copyWith(
                        fontSize: 16,

                        fontWeight: FontWeight.w700,

                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      subtitle,

                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 12,

                        color: colorScheme.onSurfaceVariant,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              /// CLOSE BUTTON
              Container(
                height: 30,

                width: 30,

                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),

                  shape: BoxShape.circle,
                ),

                child: IconButton(
                  padding: EdgeInsets.zero,

                  onPressed: () {
                    Navigator.pop(context);
                  },

                  icon: const Icon(
                    Icons.close_rounded,

                    color: Colors.red,

                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
