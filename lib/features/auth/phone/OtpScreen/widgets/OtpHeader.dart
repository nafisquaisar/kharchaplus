import 'package:flutter/material.dart';

import '../../../../../core/constants/AppColors.dart';

class OtpHeader extends StatelessWidget {
  final String phone;

  const OtpHeader({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.kharchaGradient, // ✅ correct
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔐 Icon container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15), // 👈 match gradient
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lock_outline,
              color: Colors.white, // 👈 important
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          /// 📝 Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // 👈 fix visibility
                  ),
                ),
                const SizedBox(height: 4),

                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70, // 👈 readable on gradient
                    ),
                    children: [
                      const TextSpan(text: "OTP sent to "),
                      TextSpan(
                        text: phone,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
}