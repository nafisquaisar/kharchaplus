import 'package:expense_tracker/core/constants/AppColors.dart';
import 'package:flutter/material.dart';

class ElectricityEditAction extends StatelessWidget {

  final VoidCallback onTap;

  const ElectricityEditAction({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),

      child: IconButton(

        onPressed: onTap,

        icon: const Icon(
          Icons.edit_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}