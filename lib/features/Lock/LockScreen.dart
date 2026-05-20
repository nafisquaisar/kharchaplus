import 'package:expense_tracker/MainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/services/fingerprint/BiometricService.dart';

class LockScreen extends StatefulWidget {

  final VoidCallback onUnlocked;

  const LockScreen({
    super.key,
    required this.onUnlocked,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final biometric = BiometricService();

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool success = await biometric.authenticate();

    if (success) {
      widget.onUnlocked();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Icon(
          Icons.fingerprint,
          size: 100,
        ),
      ),
    );
  }
}