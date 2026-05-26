import 'package:flutter/material.dart';
import 'footer.dart';
import 'header_wave.dart' hide GoogleButton;
import 'google_button.dart';
import 'phone_button.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HeaderWave(),
          Expanded(
            child: SingleChildScrollView(
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Welcome!",
            style: textTheme.titleMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Track and manage your expenses easily.",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const GoogleButton(),
          // const SizedBox(height: 15),
          // const PhoneButton(),
          const SizedBox(height: 20),
          // SocialFooter(),
          Footer()
        ],
      ),
    );
  }
}