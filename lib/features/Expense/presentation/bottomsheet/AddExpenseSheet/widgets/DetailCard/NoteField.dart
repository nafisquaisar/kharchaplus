/// 📄 NoteField.dart
library;

import 'package:flutter/material.dart';

import '../../../../../../../core/constants/AppColors.dart';


class NoteField extends StatelessWidget {
  final TextEditingController controller;

  const NoteField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,

      decoration: InputDecoration(
        hintText: "Add note...",

        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
        ),

        filled: true,
        fillColor: AppColors.background,

        contentPadding: const EdgeInsets.all(16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Icon(
            Icons.edit_note_rounded,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}