/// 📁 help_support_screen.dart

import 'package:expense_tracker/help_support/widgets/help/help_banner_card.dart';
import 'package:expense_tracker/help_support/widgets/help/help_bottom_contact.dart';
import 'package:expense_tracker/help_support/widgets/help/help_contact_section.dart';
import 'package:expense_tracker/help_support/widgets/help/help_faq_section.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/AppColors.dart';
import '../core/Common/CommonAppBar.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          /// 🔥 COMMON APP BAR
          CommonAppBar(
            title: "Help Center",
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  HelpBannerCard(),

                  SizedBox(height: 34),

                  HelpContactSection(),

                  SizedBox(height: 34),

                  HelpFaqSection(),

                  SizedBox(height: 40),

                  HelpBottomContact(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}