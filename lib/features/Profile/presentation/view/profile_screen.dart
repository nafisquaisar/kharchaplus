import 'package:flutter/material.dart';

import '../widgets/AchievementSection.dart';
import '../widgets/DashboardStatsCard.dart';
import '../widgets/EditProfileScreen.dart';
import '../widgets/account_section.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPadding =
        (media.size.width * 0.05).clamp(2.0, 4.0).toDouble();
    final bottomSpacing =
        (media.padding.bottom + kBottomNavigationBarHeight + 24)
            .clamp(80.0, 140.0)
            .toDouble();

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            bottomSpacing,
          ),
          child: Column(
            children: [
              ProfileHeader(
                onEditTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(),
                    ),
                  );
                },
              ),
              DashboardStatsCard(),
              const AchievementSection(),
              const SettingsSection(),
              const AccountSection(),
            ],
          ),
        ),
      ),
    );
  }
}