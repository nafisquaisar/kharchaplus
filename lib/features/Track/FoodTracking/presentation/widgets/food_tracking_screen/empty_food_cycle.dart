import 'package:flutter/material.dart';

class EmptyFoodCycle
    extends StatelessWidget {

  const EmptyFoodCycle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    return Center(

      child: Text(

        "No Food Cycles Yet",

        style: TextStyle(
          fontSize: 16,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}