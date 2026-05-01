import 'package:flutter/material.dart';

class DateInfoCard extends StatelessWidget {
  final String title;
  final String date;

  const DateInfoCard({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(date,
              style:
              const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}