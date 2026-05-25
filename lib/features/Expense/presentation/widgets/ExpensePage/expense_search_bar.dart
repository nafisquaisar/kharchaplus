import 'package:flutter/material.dart';

class ExpenseSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const ExpenseSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),

        /// 🔥 SHADOW (PRO LEVEL)
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: "Search expenses...",
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant,
          ),

          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
            onPressed: () {
              controller.clear();
              onChanged("");
            },
          )
              : null,

          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}