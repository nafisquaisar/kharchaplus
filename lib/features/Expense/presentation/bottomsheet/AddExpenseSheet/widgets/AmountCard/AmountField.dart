import 'package:flutter/material.dart';
import '../../../../../../../core/constants/AppColors.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const AmountField({
    super.key,
    required this.controller,
    this.hintText = "0.00",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "Amount",
            style: textTheme.labelMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Container(
          height: 45,
          decoration: BoxDecoration(
            gradient: AppColors.kharchaGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(1.2),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              cursorColor: AppColors.primary,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                // ₹ Icon
                prefixIcon: Container(
                  margin: const EdgeInsets.all(10),
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primarybg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.currency_rupee_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                hintText: hintText,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),

                // INR
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      "INR",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}