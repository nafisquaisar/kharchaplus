import 'package:flutter/material.dart';

class ToggleTab extends StatelessWidget {
  final String selected;
  final Function(String) onChange;

  const ToggleTab({
    super.key,
    required this.selected,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _tab("owe", "You Owe"),
            _tab("get", "You'll Get"),
          ],
        ),
      ),
    );
  }

  Widget _tab(String value, String label) {
    final isActive = selected == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChange(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.deepPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}