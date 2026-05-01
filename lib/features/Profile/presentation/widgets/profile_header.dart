import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        /// Profile Image
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.person, size: 40),
        ),

        const SizedBox(height: 12),

        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          email,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}