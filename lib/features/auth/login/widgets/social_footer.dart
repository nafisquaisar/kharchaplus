import 'package:flutter/material.dart';

class SocialFooter extends StatelessWidget {
  const SocialFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.facebook, size: 20),
            SizedBox(width: 10),
            Icon(Icons.g_mobiledata, size: 24),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "Sign in with another account",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}