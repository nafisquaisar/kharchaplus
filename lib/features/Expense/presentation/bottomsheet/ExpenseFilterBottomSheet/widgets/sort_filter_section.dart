import 'package:flutter/material.dart';

import '../../../../data/model/ExpenseFilterModel.dart';
import 'filter_section_title.dart';

class SortFilterSection
    extends StatelessWidget {

  final ExpenseSortType selected;

  final Function(ExpenseSortType)
  onChanged;

  const SortFilterSection({
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
          title: 'Sort By',
        ),

        const SizedBox(height: 14),

        Wrap(

          spacing: 10,
          runSpacing: 10,

          children:
          ExpenseSortType.values
              .map((e) {

            return ChoiceChip(

              label: Text(
                e.name.toUpperCase(),
              ),

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