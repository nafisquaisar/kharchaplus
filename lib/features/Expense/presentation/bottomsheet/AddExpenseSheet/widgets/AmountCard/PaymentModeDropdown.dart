/// 📄 PaymentModeDropdown.dart
library;

import 'package:flutter/material.dart';

import '../../../../../../../core/constants/AppColors.dart';
import '../../../../../data/model/ExpenseModel.dart';


class PaymentModeDropdown extends StatelessWidget {
  final PaymentMode selected;
  final Function(PaymentMode) onChanged;

  const PaymentModeDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<PaymentMode>(
          value: selected,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
            size: 18,
          ),

          items: PaymentMode.values.map((mode) {
            return DropdownMenuItem(
              value: mode,
              child: Text(
                mode.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),

          onChanged: (val) {
            if (val != null) {
              onChanged(val);
            }
          },
        ),
      ),
    );
  }
}