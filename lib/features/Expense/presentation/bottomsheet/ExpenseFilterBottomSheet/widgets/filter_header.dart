import 'package:flutter/material.dart';

class FilterHeader
    extends StatelessWidget {

  final VoidCallback onReset;

  const FilterHeader({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    return Row(

      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Text(

          'Filters',

          style: textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        TextButton(
          onPressed: onReset,
          child: const Text('Reset'),
        ),
      ],
    );
  }
}