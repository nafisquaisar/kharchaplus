import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class HelpFaqTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const HelpFaqTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),

            const SizedBox(width: 10),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}