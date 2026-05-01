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
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: const Icon(Icons.category, size: 18),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600)),
                Text(date,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12)),
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
