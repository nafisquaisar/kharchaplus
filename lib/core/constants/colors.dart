import 'package:flutter/material.dart';

class AppColors {
  // 🌫️ Background
  static const Color background = Color(0xFFF5F7FF);

  // 🧱 Card
  static const Color card = Colors.white;

  // 🌈 Primary Colors
  static const Color primary = Color(0xFF4F46E5);
  static const Color accent = Color(0xFF7C3AED);

  // 🔮 Gradient (existing)
  static const Color totalContainerStart = Color(0xFF4F46E5);
  static const Color totalContainerEnd = Color(0xFF7C3AED);

  // 🔥 NEW: Auth Header Gradient
  static const Color authGradientStart = Color(0xff7B61FF); // purple-blue
  static const Color authGradientEnd = Color(0xff2196F3);   // blue

  // 📝 Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF71829A);

  // ❌ Error
  static const Color deleteBackground = Color(0xFFEF4444);

  // 🔥 Button Gradient
  static const Color buttonGradientStart = Color(0xff7B61FF);
  static const Color buttonGradientEnd = Color(0xff2196F3);

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [buttonGradientStart, buttonGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient authGradient = LinearGradient(
    colors: [authGradientStart, authGradientEnd],
  );





  const AppColors._();
}