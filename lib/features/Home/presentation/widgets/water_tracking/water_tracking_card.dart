import 'package:expense_tracker/features/Track/WaterTracking/presentation/screens/water_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../../../Track/WaterTracking/WaterTrackingScreen.dart';

class WaterTrackingCard extends StatelessWidget {
  const WaterTrackingCard({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 TOP ROW
          InkWell(

            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const WaterScreen())
              );
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFEAF7F6,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.water_drop_rounded,
                        size: 16,
                        color: const Color(0xFF2D8C82),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    Text(
                      "Water Tracking",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: width * 0.065,
                ),
              ],
            ),
          ),

          SizedBox(height: width * 0.02),

          /// 💧 DRINKING CARD
          _waterCard(
            width: width,
            icon: Icons.local_drink_rounded,
            title: "Drinking",
            value: "2.4L",
            subValue: "/ 3L",
            progress: 0.8,
            progressText: "80%",
            iconBg: const Color(0xFFEAF7F6),
            iconColor: const Color(0xFF2D8C82),
          ),

          SizedBox(height: width * 0.02),

          /// 🚰 WATER MANAGEMENT
          Container(
            padding: EdgeInsets.all(
              width * 0.03,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFD),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(
                  0xFFF1F3F5,
                ),
              ),
            ),
            child: Row(
              children: [
                /// ICON
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFEAF7F6,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.water_rounded,
                    color: const Color(0xFF2D8C82),
                    size: width * 0.06,
                  ),
                ),

                SizedBox(width: width * 0.03),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Water Management",
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.036,
                        ),
                      ),
                      SizedBox(
                        height: width * 0.008,
                      ),
                      Text(
                        "This Month Expense",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.032,
                        ),
                      ),
                      SizedBox(
                        height: width * 0.012,
                      ),
                      Text(
                        "₹880",
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.055,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 📈 PERCENT
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFEAF7F6,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        color: const Color(
                          0xFF2D8C82,
                        ),
                        size: width * 0.04,
                      ),
                      Text(
                        "12%",
                        style: TextStyle(
                          color: const Color(
                            0xFF2D8C82,
                          ),
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.035,
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
    );
  }

  Widget _waterCard({
    required double width,
    required IconData icon,
    required String title,
    required String value,
    required String subValue,
    required double progress,
    required String progressText,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(
        width * 0.03,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(
            0xFFF1F3F5,
          ),
        ),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: width * 0.06,
            ),
          ),

          SizedBox(width: width * 0.03),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.036,
                  ),
                ),
                SizedBox(
                  height: width * 0.006,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.06,
                        ),
                      ),
                      TextSpan(
                        text: " $subValue",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 📊 PROGRESS
          SizedBox(
            height: width * 0.18,
            width: width * 0.18,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: width * 0.18,
                  width: width * 0.18,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    backgroundColor: const Color(
                      0xFFF1F3F5,
                    ),
                    valueColor: AlwaysStoppedAnimation(
                      iconColor,
                    ),
                  ),
                ),
                Text(
                  progressText,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.w700,
                    fontSize: width * 0.04,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
