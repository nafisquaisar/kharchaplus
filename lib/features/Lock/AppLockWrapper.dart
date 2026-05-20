import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/services/fingerprint/BiometricService.dart';
import 'AppLockStorage.dart';
import 'LockScreen.dart';

class AppLockWrapper extends StatefulWidget {
  final Widget child;

  const AppLockWrapper({
    super.key,
    required this.child,
  });

  @override
  State<AppLockWrapper> createState() =>
      _AppLockWrapperState();
}

class _AppLockWrapperState
    extends State<AppLockWrapper> {

  bool isLoading = true;
  bool isUnlocked = false;

  @override
  void initState() {
    super.initState();
    _checkLock();
  }

  Future<void> _checkLock() async {
    bool enabled =
    await AppLockStorage.isEnabled();

    if (!enabled) {
      setState(() {
        isUnlocked = true;
        isLoading = false;
      });
      return;
    }

    final success =
    await BiometricService().authenticate();

    setState(() {
      isUnlocked = success;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    // if (isLoading) {
    //   return const Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    if (isLoading) {
      return widget.child;
    }

    if (!isUnlocked) {
      return LockScreen(
        onUnlocked: () {
          setState(() {
            isUnlocked = true;
          });
        },
      );
    }

    return widget.child;
  }
}