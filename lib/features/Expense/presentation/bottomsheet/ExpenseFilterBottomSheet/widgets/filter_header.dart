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

    return Row(

      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        const Text(

          'Filters',

          style: TextStyle(
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