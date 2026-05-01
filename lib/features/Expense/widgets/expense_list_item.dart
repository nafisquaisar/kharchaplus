import 'package:flutter/material.dart';

class ExpenseListItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;

  const ExpenseListItem({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.category),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(date,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          Text(amount,
              style:
              const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}