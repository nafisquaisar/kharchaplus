import 'package:flutter/material.dart';

class FilterDragHandle
    extends StatelessWidget {

  const FilterDragHandle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    return Center(

      child: Container(

        height: 5,
        width: 52,

        decoration: BoxDecoration(

          color: colorScheme.outlineVariant,

          borderRadius:
          BorderRadius.circular(100),
        ),
      ),
    );
  }
}
