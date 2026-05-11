import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../domain/entities/electricity_entity.dart';

class ElectricityStatusBadge extends StatelessWidget {
  final ElectricityEntity entity;

  const ElectricityStatusBadge({
    super.key,
    required this.entity,
  });

  @override
  Widget build(BuildContext context) {
    final status = _label(entity);
    final color = _color(entity);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _label(ElectricityEntity entity) {
    if (entity.isDeleted) {
      return 'Deleted';
    }
    if (!entity.isSynced || entity.isEdited || entity.isOfflineCreated) {
      return 'Pending';
    }
    return entity.isActive ? 'Active' : 'Inactive';
  }

  Color _color(ElectricityEntity entity) {
    if (entity.isDeleted) {
      return AppColors.deleteBackground;
    }
    if (!entity.isSynced || entity.isEdited || entity.isOfflineCreated) {
      return AppColors.accent;
    }
    return AppColors.kharchaGradientStart;
  }
}

