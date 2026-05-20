  /// 📁 settings_screen.dart

  import 'package:expense_tracker/Setting/widgets/logout_button.dart';
  import 'package:expense_tracker/Setting/widgets/settings_group_card.dart';
  import 'package:expense_tracker/Setting/widgets/settings_section_title.dart';
  import 'package:expense_tracker/Setting/widgets/settings_tile.dart';
  import 'package:expense_tracker/about/about_app_screen.dart';
  import 'package:expense_tracker/help_support/help_support_screen.dart';
  import 'package:expense_tracker/privacypolicy/privacy_policy_screen.dart';
  import 'package:flutter/material.dart';
  import '../../../core/constants/AppColors.dart';
  import '../core/Common/CommonAppBar.dart';
  import '../core/theme/theme_controller.dart';
import '../features/Lock/AppLockStorage.dart';


  class SettingsScreen extends StatefulWidget {
    const SettingsScreen({super.key});

    @override
    State<SettingsScreen> createState() => _SettingsScreenState();
  }

  class _SettingsScreenState extends State<SettingsScreen> {
    bool isAppLockEnabled = false;
    @override
    void initState() {
      super.initState();
      loadAppLock();
    }

    Future<void> loadAppLock() async {
      final enabled = await AppLockStorage.isEnabled();

      setState(() {
        isAppLockEnabled = enabled;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            /// 🔥 COMMON APP BAR
            CommonAppBar(
              title: "Settings",
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
                  children: [
                    /// 🔥 GENERAL
                    const SettingsSectionTitle(
                      title: "GENERAL",
                    ),

                    const SizedBox(height: 16),

                    SettingsGroupCard(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: ThemeController.isDark,
                          builder: (context, isDark, child) {
                            return SettingsTile(
                              icon: Icons.dark_mode_outlined,
                              title: "Dark Mode",
                              switchValue: isDark,
                              onSwitchChanged: (value) {
                                ThemeController.isDark.value = value;
                              },
                            );
                          },
                        ),
                      ],
                    ),



                    const SizedBox(height: 34),

                    /// 🔥 SECURITY
                    const SettingsSectionTitle(
                       title: "SECURITY",
                    ),

                    const SizedBox(height: 16),

                    SettingsGroupCard(
                      children: [
                        SettingsTile(
                          icon: Icons.fingerprint,
                          title: "Fingerprint Lock",
                          switchValue: isAppLockEnabled,
                          onSwitchChanged: (value) async {
                            await AppLockStorage.setEnabled(value);

                            setState(() {
                              isAppLockEnabled = value;
                            });
                          },
                        ),

                        const SettingsDivider(),

                        SettingsTile(
                          icon: Icons.lock_outline_rounded,
                          title: "Privacy And Security",
                          onTap: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const PrivacyPolicyScreen()));
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 34),

                    /// 🔥 SUPPORT
                    const SettingsSectionTitle(
                      title: "SUPPORT",
                    ),

                    const SizedBox(height: 16),

                    SettingsGroupCard(
                      children: [
                        SettingsTile(
                          icon: Icons.help_outline_rounded,
                          title: "Help Center",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const HelpSupportScreen()));
                          },
                        ),

                        // const SettingsDivider(),

                        // SettingsTile(
                        //   icon: Icons.chat_bubble_outline_rounded,
                        //   title: "Contact Us",
                        //   onTap: () {},
                        // ),

                        const SettingsDivider(),

                        SettingsTile(
                          icon: Icons.info_outline_rounded,
                          title: "About App",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutAppScreen()));
                          },
                        ),
                      ],
                    ),

                    // const SizedBox(height: 40),
                    //
                    // /// 🔥 LOGOUT
                    // LogoutButton(
                    //   onTap: () {},
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }