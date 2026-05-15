import 'package:flutter/material.dart';

import '../../../../../../core/constants/AppColors.dart';

class IntakeActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const IntakeActionButtons({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionIcon(
          icon: Icons.edit_outlined,
          color: AppColors.accent,
          onTap: onEdit,
        ),
        const SizedBox(width: 6),
        _ActionIcon(
          icon: Icons.delete_outline_rounded,
          color: Colors.redAccent,
          onTap: onDelete,
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 15,
          color: color,
        ),
      ),
    );
  }
}
