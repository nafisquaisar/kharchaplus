import 'package:flutter/material.dart';

import '../../../../core/constants/AppColors.dart';

class HelpBannerCard extends StatelessWidget {
  const HelpBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: AppColors.kharchaGradient,
        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Stack(
        children: [
          /// 🔥 BACKGROUND CIRCLES
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.05),
              ),
            ),
          ),

          Positioned(
            bottom: -40,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(.04),
              ),
            ),
          ),

          /// 🔥 CONTENT
          Row(
            children: [
              /// 🔥 ICON SECTION
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(.14),
                  border: Border.all(
                    color: Colors.white.withOpacity(.18),
                    width: 1,
                  ),
                ),

                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),

              const SizedBox(width: 12),

              /// 🔥 TEXT SECTION
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "How can we help you?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "We're here to answer your questions and help you with anything related to Kharcha Plus.",
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}