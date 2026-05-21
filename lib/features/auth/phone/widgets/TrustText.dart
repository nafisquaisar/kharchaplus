import 'package:flutter/material.dart';

class TrustText extends StatelessWidget {
  const TrustText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 16, color: Colors.grey),
        SizedBox(width: 6),
        Text(
          "Your number is safe with us",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}