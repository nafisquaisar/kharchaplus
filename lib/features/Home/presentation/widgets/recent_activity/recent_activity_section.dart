import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: 6,
      ),

      padding: EdgeInsets.all(
        width * 0.03,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          /// 🔥 HEADER
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Recent Activity",

                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025,
                  vertical: width * 0.01,
                ),

                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF5F7FA,
                  ),

                  borderRadius:
                  BorderRadius.circular(30),
                ),

                child: Text(
                  "View All",

                  style: TextStyle(
                    color:
                    const Color(0xFF475467),

                    fontWeight:
                    FontWeight.w600,

                    fontSize: width * 0.03,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: width * 0.02),

          /// 📌 ITEMS
          _activityItem(
            width: width,
            icon: Icons.water_drop_rounded,
            title: "Water Tanker",
            subtitle: "5000L • May 27, 2026",
            amount: "₹700",
            iconBg: const Color(0xFFEAF7F6),
            iconColor: const Color(0xFF2D8C82),
          ),

          _divider(),

          _activityItem(
            width: width,
            icon: Icons.bolt_rounded,
            title: "Electricity Bill",
            subtitle: "May 26, 2026",
            amount: "₹660",
            iconBg: const Color(0xFFFFF4E8),
            iconColor: const Color(0xFFE58A00),
          ),

          _divider(),

          _activityItem(
            width: width,
            icon: Icons.restaurant_rounded,
            title: "Food Cycle Added",
            subtitle: "Apna Mess • May 26, 2026",
            amount: "₹3,600",
            iconBg: const Color(0xFFEEF4FF),
            iconColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ),

      height: 1,

      color: const Color(0xFFF1F3F5),
    );
  }

  Widget _activityItem({
    required double width,
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: width * 0.012,
      ),

      child: Row(
        children: [
          /// 🔥 ICON
          Container(
            height: 42,
            width: 42,

            decoration: BoxDecoration(
              color: iconBg,

              borderRadius:
              BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: width * 0.05,
            ),
          ),

          SizedBox(width: width * 0.03),

          /// 🔤 TEXT
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight:
                    FontWeight.w700,

                    fontSize: width * 0.037,
                  ),
                ),

                SizedBox(
                  height: width * 0.004,
                ),

                Text(
                  subtitle,

                  style: TextStyle(
                    color:
                    AppColors.textSecondary,

                    fontSize: width * 0.029,

                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// 💰 AMOUNT
          Text(
            amount,

            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
              fontSize: width * 0.038,
            ),
          ),
        ],
      ),
    );
  }
}