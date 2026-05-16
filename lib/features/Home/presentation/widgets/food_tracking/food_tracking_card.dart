import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';
import '../../../../Track/FoodTracking/presentation/screens/food_tracking_screen.dart';

class FoodTrackingCard extends StatelessWidget {
  const FoodTrackingCard({
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
                  MaterialPageRoute(builder: (context) => const FoodTrackingScreen())
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
                          0xFFFFF4E8,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 16,
                        color: const Color(0xFFE58A00),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    Text(
                      "Food Tracking",
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

          /// 📊 CONTENT
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Active Mess",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: width * 0.033,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: width * 0.003),
                    Text(
                      "Apna Mess",
                      style: TextStyle(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: width * 0.004),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.022,
                        vertical: width * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFFFF4E8,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "43 Meals Left",
                        style: TextStyle(
                          color: const Color(0xFFE58A00),
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔵 RIGHT PROGRESS
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
                        value: 0.85,
                        strokeWidth: 4,
                        backgroundColor: const Color(
                          0xFFF3F4F6,
                        ),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFFE58A00),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "85%",
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.04,
                          ),
                        ),
                        Text(
                          "Completed",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: width * 0.02,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: width * 0.015),

          /// 💰 PRICE
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "₹3,600",
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: width * 0.055,
                  ),
                ),
                TextSpan(
                  text: " / ₹4,000",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.04,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: width * 0.02),

          /// 📈 PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.85,
              minHeight: 4,
              backgroundColor: const Color(0xFFF1F3F5),
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFFE58A00),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
