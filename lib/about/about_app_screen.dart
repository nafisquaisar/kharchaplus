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
    final media = MediaQuery.of(context);
    final bottomPadding = media.padding.bottom + 24;

    return Scaffold(
      backgroundColor: AppColors.background,

      /// 🔥 COMMON APP BAR
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            CommonAppBar(
              title: "About App",
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