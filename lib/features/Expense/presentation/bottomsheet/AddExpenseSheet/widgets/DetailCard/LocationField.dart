/// 📄 LocationField.dart
library;

import 'package:flutter/material.dart';

import '../../../../../../../core/constants/AppColors.dart';


class LocationField extends StatelessWidget {
  const LocationField({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [

          Icon(
            Icons.location_on_outlined,
            color: AppColors.primary,
            size: 20,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              "Add location",
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Text(
            "Optional",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}