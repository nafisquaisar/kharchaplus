import 'package:flutter/material.dart';

import '../../../../data/model/ExpenseModel.dart';
import 'filter_section_title.dart';

class PaymentFilterSection
    extends StatelessWidget {

  final PaymentMode? selected;

  final Function(PaymentMode)
  onChanged;

  const PaymentFilterSection({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const FilterSectionTitle(
          title: 'Payment Mode',
        ),

        const SizedBox(height: 14),

        Wrap(

          spacing: 10,
          runSpacing: 10,

          children:
          PaymentMode.values
              .map((e) {

            return ChoiceChip(

              label: Text(e.name),

              selected:
              selected == e,

              onSelected: (_) {
                onChanged(e);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}