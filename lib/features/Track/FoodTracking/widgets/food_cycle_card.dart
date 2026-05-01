import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodCycleCard extends StatelessWidget {
  final String title;
  final String cost;
  final String status;
  final bool highlight;
  final VoidCallback onTap;

  const FoodCycleCard({
    super.key,
    required this.title,
    required this.cost,
    required this.status,
    required this.highlight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: highlight ? Colors.orange.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: highlight ? Colors.orange : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),

            const Text("Total Cost", style: TextStyle(color: Colors.grey)),

            Text(cost,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 6),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status == "Active"
                      ? Colors.green.shade100
                      : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(status),
              ),
            ),
          ],
        ),
      ),
    );
  }
}