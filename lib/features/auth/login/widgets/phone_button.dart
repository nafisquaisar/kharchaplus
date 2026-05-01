import 'package:flutter/material.dart';
import '../../phone/phone_screen.dart';

class PhoneButton extends StatelessWidget {
  const PhoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: const BorderSide(color: Colors.blue),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PhoneScreen()),
          );
        },
        child: const Text("Login with Phone Number"),
      ),
    );
  }
}