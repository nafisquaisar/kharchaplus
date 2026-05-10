import 'package:flutter/material.dart';
import 'SectionCard.dart';
import '../../../../../../core/constants/AppColors.dart';

class DetailsSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController notesController;

  const DetailsSection({
    super.key,
    required this.titleController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔥 SECTION TITLE
        Text(
          "Details",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 10),

        /// 🔥 CARD
        SectionCard(
          child: Column(
            children: [

              /// 🔥 TITLE FIELD
              _InputField(
                label: "Title",
                hint: "e.g. Home Expenses",
                controller: titleController,
                icon: Icons.title,
              ),

              const SizedBox(height: 14),

              /// 🔥 NOTES FIELD
              _InputField(
                label: "Notes",
                hint: "Add description (optional)",
                controller: notesController,
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

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;

  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔥 LABEL
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 6),

        /// 🔥 INPUT FIELD
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14),

          decoration: InputDecoration(
            hintText: hint,

            prefixIcon: Icon(icon, size: 18),

            filled: true,
            fillColor: AppColors.background,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}