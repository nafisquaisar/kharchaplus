import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class AboutAppInfoSection extends StatelessWidget {
  const AboutAppInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔥 APP LOGO
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppColors.kharchaGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Image.asset(
            "assets/images/whiteicon1.png",
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 10),

        /// 🔥 APP NAME
        Text(
          "Kharcha Plus",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.colorText,
          ),
        ),

        const SizedBox(height: 4),

        /// 🔥 APP SUBTITLE
        Text(
          "Expense And Utility Tracking App",
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 22),

        /// 🔥 VERSION
        /// 🔥 PREMIUM VERSION CHIP
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(.12),
                AppColors.primary.withOpacity(.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primary.withOpacity(.18),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Current Version",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),


              Text(
                "v1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colorText,
                  letterSpacing: .3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        /// 🔥 DESCRIPTION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Kharcha Plus is your smart personal finance companion that helps you track daily expenses, monitor spending habits, manage budgets, and stay financially organized with ease.",
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 1.7,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}