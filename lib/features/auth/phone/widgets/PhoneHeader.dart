
import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class PhoneHeader extends StatelessWidget {
  const PhoneHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.kharchaGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Phone Number",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "We will send you an OTP to verify",
            style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}