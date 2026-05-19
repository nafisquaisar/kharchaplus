import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/profile_streak_viewmodel.dart';
import '../viewmodel/profile_achievement_viewmodel.dart';

class ProfileStreakLifecycleHandler extends StatefulWidget {
  final Widget child;

  const ProfileStreakLifecycleHandler({
    super.key,
    required this.child,
  });

  @override
  State<ProfileStreakLifecycleHandler> createState() =>
      _ProfileStreakLifecycleHandlerState();
}

class _ProfileStreakLifecycleHandlerState
    extends State<ProfileStreakLifecycleHandler>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _recordOpen();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recordOpen();
    }
  }

  void _recordOpen() {
    if (!mounted) {
      return;
    }
    context.read<ProfileStreakViewModel>().recordAppOpen();
    context.read<ProfileAchievementViewModel>().evaluateAndSync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
