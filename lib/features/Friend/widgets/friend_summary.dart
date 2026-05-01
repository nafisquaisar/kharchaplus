import 'package:flutter/material.dart';

class FriendSummary extends StatelessWidget {
  final double totalOwe;
  final double totalGet;

  const FriendSummary({
    super.key,
    required this.totalOwe,
    required this.totalGet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _box("You Owe", totalOwe, Colors.red.shade100),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _box("You'll Get", totalGet, Colors.green.shade100),
          ),
        ],
      ),
    );
  }

  Widget _box(String title, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 6),
          Text(
            "₹ ${value.toStringAsFixed(0)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}