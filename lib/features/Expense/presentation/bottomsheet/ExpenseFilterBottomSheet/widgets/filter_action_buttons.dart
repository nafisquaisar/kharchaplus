import 'package:flutter/material.dart';

class FilterActionButtons
    extends StatelessWidget {

  final VoidCallback onCancel;
  final VoidCallback onApply;

  const FilterActionButtons({
    super.key,
    required this.onCancel,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {

    return Row(

      children: [

        Expanded(

          child: OutlinedButton(

            onPressed: onCancel,

            child: const Text(
              'Cancel',
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(

          child: ElevatedButton(

            onPressed: onApply,

            child: const Text(
              'Apply Filters',
            ),
          ),
        ),
      ],
    );
  }
}