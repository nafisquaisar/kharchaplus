import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class ElectricityEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onAction;
  final String actionLabel;

  const ElectricityEmptyState({
    super.key,
    this.title = 'No Records Yet',
    this.message = 'Start tracking your electricity usage to see insights.',
    this.onAction,
    this.actionLabel = 'Add Electricity',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.bolt_rounded, color: AppColors.primary),
            ),

            const SizedBox(height: 16),

            Text(
              title,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
