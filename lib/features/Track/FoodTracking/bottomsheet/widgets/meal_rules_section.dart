import 'package:flutter/material.dart';

import 'custom_dropdown.dart';
import 'section_card.dart';
import 'section_title.dart';

class MealRulesSection
    extends StatelessWidget {

  final String sundayOption;

  final Function(String?)
  onSundayChanged;

  const MealRulesSection({
    super.key,
    required this.sundayOption,
    required this.onSundayChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const SectionTitle(
          title: "Sunday Meal Rules",
        ),

        SectionCard(

          child: CustomDropdown(

            value: sundayOption,

            items: const [

              "2 Meals",

              "1 Meal",

              "Off",
            ],

            onChanged:
            onSundayChanged,
          ),
        ),
      ],
    );
  }
}