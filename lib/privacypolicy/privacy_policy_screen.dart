  /// 📁 privacy_policy_screen.dart
library;

  import 'package:flutter/material.dart';

  import '../core/constants/AppColors.dart';
  import '../core/Common/CommonAppBar.dart';

  class PrivacyPolicyScreen extends StatelessWidget {
    const PrivacyPolicyScreen({super.key});

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
              /// 🔥 APP BAR
              CommonAppBar(
                title: "Privacy Policy",
                isHome: false,
                onMenuTap: () => Navigator.pop(context),
                onNotificationTap: () {},
              ),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final contentPadding =
                        (constraints.maxWidth * 0.04).clamp(12.0, 20.0).toDouble();

                    return Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            contentPadding,
                            12,
                            contentPadding,
                            bottomPadding,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.border,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.05),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),

                            child: Column(
                              children: [
                                /// =========================
                                /// 🔥 HEADER
                                /// =========================

                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: contentPadding,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.accent.withOpacity(.08),
                                        AppColors.accent.withOpacity(.02),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),

                                  child: Column(
                                    children: [
                                      /// ICON
                                      Builder(
                                        builder: (context) {
                                          final iconBoxSize =
                                              (media.size.width * 0.22).clamp(64.0, 90.0).toDouble();
                                          final iconSize = (iconBoxSize * 0.65).clamp(40.0, 56.0).toDouble();

                                          return Container(
                                            width: iconBoxSize,
                                            height: iconBoxSize,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient:
                                              AppColors.kharchaGradient,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.accent
                                                      .withOpacity(.25),
                                                  blurRadius: 24,
                                                  offset:
                                                  const Offset(0, 10),
                                                ),
                                              ],
                                            ),

                                            child: Icon(
                                              Icons.lock_rounded,
                                              color: Colors.white,
                                              size: iconSize,
                                            ),
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 28),

                                      Text(
                                        "Your Privacy Matters",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color:
                                          AppColors.colorText,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "We are committed to protecting your personal information and being transparent about how we use it.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.7,
                                          color: AppColors
                                              .textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: contentPadding,
                                    vertical: 24,
                                  ),
                                  child: Column(
                                    children: [
                                      _policyTile(
                                        context,
                                        icon:
                                        Icons.shield_outlined,
                                        title:
                                        "Information We Collect",
                                        description:
                                        "We collect only the information necessary to provide and improve our services. This may include basic account information and app usage data.",
                                      ),

                                      _divider(),

                                      _policyTile(
                                        context,
                                        icon: Icons.lock_outline,
                                        title:
                                        "How We Use Information",
                                        description:
                                        "Your information is used to provide, maintain, and improve our app experience. We never sell your personal data.",
                                      ),

                                      _divider(),

                                      _policyTile(
                                        context,
                                        icon:
                                        Icons.verified_user_outlined,
                                        title: "Data Security",
                                        description:
                                        "We use industry-standard security measures to protect your data from unauthorized access or disclosure.",
                                      ),

                                      _divider(),

                                      _policyTile(
                                        context,
                                        icon:
                                        Icons.person_outline,
                                        title: "Your Choices",
                                        description:
                                        "You can review, update, or delete your information anytime from within the app settings.",
                                      ),

                                      _divider(),

                                      _policyTile(
                                        context,
                                        icon:
                                        Icons.mail_outline_rounded,
                                        title: "Contact Us",
                                        description:
                                        "If you have questions about this Privacy Policy, contact us at kharchaplus@gmail.com",
                                      ),

                                      const SizedBox(height: 26),

                                      /// 🔥 NOTE BOX
                                      Container(
                                        width: double.infinity,
                                        padding:
                                        const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          color: AppColors.primarybg,
                                          borderRadius:
                                          BorderRadius.circular(
                                              18),
                                        ),

                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color:
                                              AppColors.accent,
                                              size: 24,
                                            ),

                                            const SizedBox(width: 14),

                                            Expanded(
                                              child: Text(
                                                "This policy may be updated from time to time. Please check this page regularly for updates.",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  height: 1.6,
                                                  color: AppColors
                                                      .textSecondary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 28),

                                      /// 🔥 LAST UPDATED
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: AppColors
                                                .textSecondary,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: "Last updated: ",
                                            ),
                                            TextSpan(
                                              text: "May 20, 2026",
                                              style: TextStyle(
                                                color:
                                                AppColors.accent,
                                                fontWeight:
                                                FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

    Widget _policyTile(
        BuildContext context, {
          required IconData icon,
          required String title,
          required String description,
        }) {
      final media = MediaQuery.of(context);
      final iconBoxSize =
          (media.size.width * 0.11).clamp(36.0, 44.0).toDouble();
      final iconSize = (iconBoxSize * 0.65).clamp(22.0, 30.0).toDouble();

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: AppColors.primarybg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.accent,
              size: iconSize,
            ),
          ),

          const SizedBox(width: 18),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                    AppColors.colorText,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget _divider() {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
        ),
        child: Divider(
          height: 1,
          color: Colors.grey.shade200,
        ),
      );
    }
  }

