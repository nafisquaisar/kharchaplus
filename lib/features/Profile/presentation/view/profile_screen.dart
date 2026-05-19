import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/AchievementSection.dart';
import '../widgets/DashboardStatsCard.dart';
import '../widgets/EditProfileScreen.dart';
import '../widgets/account_section.dart';
import '../widgets/expense_overview.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
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

            const ExpenseOverview(),

            const AchievementSection(),


            const SettingsSection(),



            const AccountSection(),

            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}