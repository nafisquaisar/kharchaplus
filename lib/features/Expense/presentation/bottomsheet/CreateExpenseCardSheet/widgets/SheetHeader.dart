import 'package:flutter/material.dart';
import '../../../../../../core/constants/AppColors.dart';

class SheetHeader extends StatelessWidget {
  final bool isEdit;

  const SheetHeader({super.key, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        /// 🔥 DRAG HANDLE
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        const SizedBox(height: 16),

        /// 🔥 HEADER ROW
        Row(
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isEdit ? Icons.edit : Icons.add_card,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 12),

            /// TITLE + SUBTITLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? "Edit Expense Card" : "Create Expense Card",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEdit
                        ? "Update your expense details"
                        : "Track your spending smartly",
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 CLOSE BUTTON
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.close, size: 20 ,color: Colors.red,),
              ),
            ),
          ],
        ),
      ],
    );
  }
}