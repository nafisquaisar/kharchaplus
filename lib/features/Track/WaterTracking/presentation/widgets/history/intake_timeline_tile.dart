import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/AppColors.dart';
import '../../../domain/entities/water_intake_entity.dart';
import 'intake_action_buttons.dart';

class IntakeTimelineTile extends StatelessWidget {
  final WaterIntakeEntity intake;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const IntakeTimelineTile({
    super.key,
    required this.intake,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeLabel = DateFormat('hh:mm a').format(intake.dateTime);
    final source = intake.sourceType;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: AppColors.primarybg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _iconForSource(source),
              color: AppColors.accent,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      timeLabel,
                      style:  TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${intake.amountMl} ml',
                      style:  TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  source,
                  style:  TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IntakeActionButtons(
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }

  IconData _iconForSource(String sourceType) {
    switch (sourceType.toLowerCase()) {
      case 'quick add':
        return Icons.flash_on_rounded;
      case 'bottle':
        return Icons.sports_bar_rounded;
      case 'glass':
        return Icons.local_bar_rounded;
      case 'other':
        return Icons.water_drop_outlined;
      case 'manual':
      default:
        return Icons.edit_note_rounded;
    }
  }
}
