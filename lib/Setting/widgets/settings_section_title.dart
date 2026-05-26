import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class SettingsSectionTitle extends StatelessWidget {

  final String title;

  const SettingsSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    final colorScheme =
        Theme.of(context).colorScheme;

    final textTheme =
        Theme.of(context).textTheme;

    return Text(

      title,

      style:
      textTheme.bodySmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        color: AppColors.colorText,
      ),
    );
  }
}