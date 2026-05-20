
import 'package:expense_tracker/about/widgets/about_action_list.dart';
import 'package:expense_tracker/about/widgets/about_app_info_section.dart';
import 'package:expense_tracker/about/widgets/about_footer_section.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/AppColors.dart';
import '../core/Common/CommonAppBar.dart';


class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔥 COMMON APP BAR
      body: Column(
        children: [
          CommonAppBar(
            title: "About App",
            isHome: false,
            onMenuTap: () => Navigator.pop(context),
            onNotificationTap: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: Column(
                children: const [
                  AboutAppInfoSection(),

                  SizedBox(height: 28),

                  AboutActionList(),

                  SizedBox(height: 40),

                  AboutFooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}