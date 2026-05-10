import 'package:flutter/material.dart';
import '../../../../core/constants/AppColors.dart';
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
          side: const BorderSide(color: AppColors.colorText),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PhoneScreen()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, color: AppColors.colorText, size: 20),
            SizedBox(width: 4),
            const Text("Login with Phone Number" , style: TextStyle(color: AppColors.colorText),),
          ],
        ),
      ),
    );
  }
}