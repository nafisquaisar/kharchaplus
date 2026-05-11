import 'package:expense_tracker/core/constants/AppColors.dart';
import 'package:flutter/material.dart';

class ElectricityDeleteAction extends StatelessWidget {

  final VoidCallback onTap;

  const ElectricityDeleteAction({
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
        color: AppColors.deleteBackground,
        borderRadius: BorderRadius.circular(20),
      ),

      child: IconButton(

        onPressed: onTap,

        icon: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}