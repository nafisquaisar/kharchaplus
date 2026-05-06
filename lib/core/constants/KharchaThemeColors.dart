import 'package:flutter/material.dart';

class AppColors {
  // 🌫️ Background
  static const Color background = Color(0xFFF4FBFA); // light teal tint

  // 🧱 Card
  static const Color card = Colors.white;

  // 🌈 Primary Colors (updated)
  static const Color primary = Color(0xFF2EC4B6);
  static const Color accent = Color(0xFF1B7F8C);
  static const Color primarybg = Color(0xFFF4FEFE);
  static const Color map = Color(0xFFDBF8F8);

  // 🔮 Gradient (used in containers / dashboard)
  static const Color totalContainerStart = Color(0xFF2EC4B6);
  static const Color totalContainerEnd = Color(0xFF1B7F8C);

  static const LinearGradient totalContainerGradient = LinearGradient(
    colors: [totalContainerStart, totalContainerEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 🔥 Auth Header Gradient (updated)
  static const Color authGradientStart = Color(0xFF2EC4B6);
  static const Color authGradientEnd = Color(0xFF1B7F8C);

  static const LinearGradient authGradient = LinearGradient(
    colors: [authGradientStart, authGradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 📝 Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF5F7F85); // muted teal-grey
  static const Color colorText = Color(0xFF1B7F8C); // muted teal-grey

  // ❌ Error
  static const Color deleteBackground = Color(0xFFE53935);

  // 🔥 Button Gradient (updated)
  static const Color buttonGradientStart = Color(0xFF2EC4B6);
  static const Color buttonGradientEnd = Color(0xFF1B7F8C);

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [buttonGradientStart, buttonGradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // 💧 KHARCHA PLUS Gradient (main branding)
  static const Color kharchaGradientStart = Color(0xFF2EC4B6);
  static const Color kharchaGradientEnd = Color(0xFF1B7F8C);

  static const LinearGradient kharchaGradient = LinearGradient(
    colors: [kharchaGradientStart, kharchaGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 💧 Extra UI helpers (optional but useful)
  static const Color highlight = Color(0xFF00AFA3);
  static const Color border = Color(0xFFE0F2F1);

  const AppColors._();
}