import 'package:flutter/material.dart';
import 'header_wave.dart' hide GoogleButton;
import 'google_button.dart';
import 'phone_button.dart';
import 'social_footer.dart';
import 'email_button.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HeaderWave(),
          Expanded(
            child: Center(
              child: _Content(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: const [
          Text(
            "Welcome !",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GoogleButton(),
          // SizedBox(height: 15),
          // EmailButton(),
          SizedBox(height: 15),
          PhoneButton(),
          SizedBox(height: 20),
          SocialFooter(),
        ],
      ),
    );
  }
}