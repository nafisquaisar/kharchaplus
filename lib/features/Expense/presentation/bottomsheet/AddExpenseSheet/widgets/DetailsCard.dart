/// 📄 DetailsCard.dart
library;

import 'package:flutter/material.dart';

import 'DetailCard/DatePickerField.dart';
import 'DetailCard/LocationField.dart';
import 'DetailCard/NoteField.dart';

class DetailsCard extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  final TextEditingController noteController;

  const DetailsCard({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [

          /// 📅 Date
          DatePickerField(
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
          ),

          const SizedBox(height: 16),

          /// 📝 Note
          NoteField(
            controller: noteController,
          ),

          const SizedBox(height: 16),

          /// 📍 Location
          const LocationField(),
        ],
      ),
    );
  }
}