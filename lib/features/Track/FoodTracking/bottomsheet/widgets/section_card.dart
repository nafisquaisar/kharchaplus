import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class SectionCard extends StatelessWidget {
  final Widget child;

  final double? height;

  const SectionCard({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: AppColors.card,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: AppColors.border),

        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.12),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: child,
    );
  }
}
