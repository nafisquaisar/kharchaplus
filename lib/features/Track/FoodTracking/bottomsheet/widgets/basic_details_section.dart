import 'package:flutter/material.dart';

import 'custom_text_field.dart';
import 'section_card.dart';
import 'section_title.dart';

class BasicDetailsSection extends StatelessWidget {
  final TextEditingController titleController;

  final TextEditingController notesController;

  const BasicDetailsSection({
    super.key,
    required this.titleController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const SectionTitle(title: "Basic Details"),

        SectionCard(
          height: 190,
          child: Column(
            children: [
              CustomTextField(
                controller: titleController,

                hint: "e.g Hostel Mess",

                icon: Icons.title,
              ),

              const SizedBox(height: 14),

              CustomTextField(
                controller: notesController,

                hint: "Add notes (optional)",

                icon: Icons.notes,

                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
