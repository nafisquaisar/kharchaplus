import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final int totalMeals, lunch, dinner;
  final double cost;

  const SummaryRow({
    super.key,
    required this.totalMeals,
    required this.lunch,
    required this.dinner,
    required this.cost,
  });

  Widget box(String t, String v) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(t, style: const TextStyle(fontSize: 12)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          box("Total Meals", "$totalMeals"),
          const SizedBox(width: 8),
          box("Lunch", "$lunch"),
          const SizedBox(width: 8),
          box("Dinner", "$dinner"),
          const SizedBox(width: 8),
          box("Total Cost", "₹${cost.toStringAsFixed(0)}"),
        ],
      ),
    );
  }
}