import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class AboutFooterSection extends StatelessWidget {
  const AboutFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Made with",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(width: 6),

            Icon(
              Icons.favorite_rounded,
              color: AppColors.deleteBackground,
              size: 18,
            ),
          ],
        ),

        SizedBox(height: 4),

        const Text(
          "Thank you for using Kharcha Plus",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}