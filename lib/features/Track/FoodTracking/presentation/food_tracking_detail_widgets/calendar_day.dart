import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarDay extends StatelessWidget {
  final DateTime date;
  final bool selected;
  final bool lunch;
  final bool dinner;
  final VoidCallback onTap;

  const CalendarDay({
    super.key,
    required this.date,
    required this.selected,
    required this.lunch,
    required this.dinner,
    required this.onTap,
  });

  Widget dot(Color c) => Container(
    width: 5,
    height: 5,
    margin: const EdgeInsets.symmetric(horizontal: 1),
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: selected ? Colors.deepPurple : null,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Text(
              "${date.day}",
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (lunch) dot(Colors.green),
              if (dinner) dot(Colors.orange),
            ],
          )
        ],
      ),
    );
  }
}