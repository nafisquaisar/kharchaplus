import 'package:expense_tracker/core/constants/AppColors.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = "Please wait...",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarybg, // 👈 light primary
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon (optional)
            Image.asset(
              "assets/images/green.png",
              width: 80,
              height: 80,
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.teal,
            ),

            const SizedBox(height: 20),

            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}