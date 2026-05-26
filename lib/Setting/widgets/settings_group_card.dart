import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class SettingsGroupCard extends StatelessWidget {

  final List<Widget> children;

  const SettingsGroupCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {

    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(

      decoration: BoxDecoration(

        color: colorScheme.surface,

        borderRadius:
        BorderRadius.circular(10),

        boxShadow: [

          BoxShadow(

            color: colorScheme.shadow
                .withOpacity(.05),

            blurRadius: 20,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: children,
      ),
    );
  }
}

/// 🔥 Divider

class SettingsDivider extends StatelessWidget {

  const SettingsDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final colorScheme =
        Theme.of(context).colorScheme;

    return Divider(

      height: 1,

      color: colorScheme.outlineVariant,

      indent: 20,

      endIndent: 20,
    );
  }
}