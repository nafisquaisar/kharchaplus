import 'package:expense_tracker/features/Track/WaterTracking/presentation/screens/purchase_history_screen.dart';
import 'package:expense_tracker/features/Track/WaterTracking/presentation/screens/water_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../Setting/settings_screen.dart';
import '../../../../../core/constants/AppColors.dart';

import '../../../../Achievements/presentation/view/achievement_screen.dart';
import '../../../../Track/ElectricityTracking/presentation/screens/ElectricityTrackingScreen.dart';
import '../../../../Track/FoodTracking/presentation/screens/food_tracking_screen.dart';
import '../../../../Track/WaterTracking/presentation/screens/water_intake_history_screen.dart';


class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final actions = [
      {
        "title": "Water Intake",
        "subtitle": "Daily history",
        "icon": Icons.local_drink_rounded,
        "color": Colors.blue,
        "screen": const WaterIntakeHistoryScreen(),
      },
      {
        "title": "Water Manage",
        "subtitle": "Usage history",
        "icon": Icons.water_drop_rounded,
        "color": Colors.cyan,
        "screen": const WaterPurchaseHistoryScreen(),
      },
      {
        "title": "Electricity",
        "subtitle": "Track bills",
        "icon": Icons.bolt_rounded,
        "color": Colors.amber,
        "screen": const ElectricityTrackingScreen(),
      },
      {
        "title": "Food Track",
        "subtitle": "Food expenses",
        "icon": Icons.restaurant_rounded,
        "color": Colors.orange,
        "screen": const FoodTrackingScreen(),
      },
      {
        "title": "Water Track",
        "subtitle": "Track usage",
        "icon": Icons.opacity_rounded,
        "color": Colors.indigo,
        "screen": const WaterScreen(),
      },
      {
        "title": "Achievement",
        "subtitle": "Your progress",
        "icon": Icons.workspace_premium_rounded,
        "color": Colors.green,
        "screen": const AchievementScreen(),
      },
      {
        "title": "Settings",
        "subtitle": "App controls",
        "icon": Icons.settings_rounded,
        "color": AppColors.primary,
        "screen": const SettingsScreen(),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 8,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          /// HEADER
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    "Quick Actions",

                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "Access all important tools",

                    style: TextStyle(
                      fontSize: width * 0.03,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color:
                  AppColors.primary.withOpacity(0.08),

                  borderRadius:
                  BorderRadius.circular(12),
                ),

                child: Row(
                  children: [
                    Icon(
                      Icons.flash_on_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      "Quick",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.028,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: width * 0.04),

          /// GRID
          GridView.builder(
            shrinkWrap: true,

            physics:
            const NeverScrollableScrollPhysics(),

            itemCount: actions.length,

            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,

              crossAxisSpacing: width * 0.03,

              mainAxisSpacing: width * 0.03,

              childAspectRatio: 1.45,
            ),

            itemBuilder: (context, index) {
              final item = actions[index];

              return _actionCard(
                context: context,
                width: width,
                title: item["title"] as String,
                subtitle: item["subtitle"] as String,
                icon: item["icon"] as IconData,
                iconColor: item["color"] as Color,
                screen: item["screen"] as Widget,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required BuildContext context,
    required double width,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Widget screen,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(22),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => screen,
            ),
          );
        },

        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,

              colors: [
                Colors.white,
                iconColor.withOpacity(0.05),
              ],
            ),

            borderRadius:
            BorderRadius.circular(22),

            border: Border.all(
              color: iconColor.withOpacity(0.10),
            ),

            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withOpacity(0.035),

                blurRadius: 14,

                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: width * 0.03,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                /// TOP ROW
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [
                    Container(
                      padding:
                      const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color:
                        iconColor.withOpacity(0.12),

                        borderRadius:
                        BorderRadius.circular(14),
                      ),

                      child: Icon(
                        icon,
                        color: iconColor,
                        size: width * 0.05,
                      ),
                    ),

                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 16,
                      color:
                      AppColors.textSecondary,
                    ),
                  ],
                ),

                const Spacer(),

                /// TITLE
                Text(
                  title,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: width * 0.034,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 3),

                /// SUBTITLE
                Text(
                  subtitle,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: width * 0.026,
                    color:
                    AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}