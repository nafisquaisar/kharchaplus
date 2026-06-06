/// 📁 help_support_screen.dart
library;

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
    final media = MediaQuery.of(context);
    final bottomPadding = media.padding.bottom + 24;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            /// 🔥 COMMON APP BAR
            CommonAppBar(
              title: "Help Center",
              isHome: false,
              onMenuTap: () => Navigator.pop(context),
              onNotificationTap: () {},
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding =
                      (constraints.maxWidth * 0.05).clamp(16.0, 24.0).toDouble();

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          24,
                          horizontalPadding,
                          bottomPadding,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}