import 'package:flutter/material.dart';
import 'widgets/login_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF5F6FA),
      body: SafeArea(
        child: LoginCard(),   // 👈 FULL SCREEN
      ),
    );
  }
}
