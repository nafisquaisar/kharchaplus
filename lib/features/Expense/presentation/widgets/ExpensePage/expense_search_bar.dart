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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        /// 🔥 SHADOW (PRO LEVEL)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: TextField(
        controller: controller,
        onChanged: onChanged,

        decoration: InputDecoration(
          hintText: "Search expenses...",
          prefixIcon: const Icon(Icons.search),

          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.close),
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