import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // 🌙 DARK MODE FLAG
  static bool isDark = false;

  // 🌫️ Background
  static Color get background =>
      isDark ? const Color(0xFF0F151E) : const Color(0xFFF4FBFA);

  // 🧱 Card
  static Color get card => isDark ? const Color(0xFF1A2330) : Colors.white;

  // 🌈 Primary Colors
  static Color get primary => const Color(0xFF2EC4B6);

  static Color get accent =>
      isDark ? const Color(0xFF38BDF8) : const Color(0xFF1B7F8C);

  static Color get primarybg =>
      isDark ? const Color(0xFF102530) : const Color(0xFFF4FEFE);

  static Color get map =>
      isDark ? const Color(0xFF14313D) : const Color(0xFFDBF8F8);

  // 🔮 Gradient (Dashboard / Containers)
  static Color get totalContainerStart => const Color(0xFF2EC4B6);

  static Color get totalContainerEnd =>
      isDark ? const Color(0xFF155E75) : const Color(0xFF1B7F8C);

  static LinearGradient get totalContainerGradient => LinearGradient(
        colors: [
          totalContainerStart,
          totalContainerEnd,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // 🔥 Auth Header Gradient
  static LinearGradient get authGradient => isDark
      ? const LinearGradient(
          colors: [
            Color(0xFF0B1220),
            Color(0xFF12343B),
            Color(0xFF1B7F8C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      : const LinearGradient(
          colors: [
            Color(0xFF2EC4B6),
            Color(0xFF1B7F8C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

  // 📝 Text
  static Color get textPrimary => isDark ? Colors.white : Colors.white;

  static Color get black => isDark ? Colors.white : Colors.black;

  static Color get textSecondary =>
      isDark ? Colors.white70 : const Color(0xFF5F7F85);

  static Color get colorText =>
      isDark ? const Color(0xFF7DD3FC) : const Color(0xFF1B7F8C);

  // ❌ Error
  static Color get deleteBackground => const Color(0xFFE53935);

  // 🔥 Button Gradient
  static Color get buttonGradientStart => const Color(0xFF2EC4B6);

  static Color get buttonGradientEnd =>
      isDark ? const Color(0xFF155E75) : const Color(0xFF1B7F8C);

  static LinearGradient get buttonGradient => LinearGradient(
        colors: [
          buttonGradientStart,
          buttonGradientEnd,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  // 💧 KHARCHA PLUS Gradient

  // 💧 KHARCHA PLUS Gradient

  static LinearGradient get kharchaGradient => isDark
      ? const LinearGradient(
          colors: [
            Color(0xFF0F2027),
            Color(0xFF134E5E),
            Color(0xFF1B7F8C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [
            Color(0xFF2EC4B6),
            Color(0xFF1B7F8C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  // 💧 Extra UI Helpers
  static Color get highlight =>
      isDark ? const Color(0xFF2DD4BF) : const Color(0xFF00AFA3);

  static Color get border => isDark ? Colors.white12 : const Color(0xFFE0F2F1);

  // 🌙 Dark Specific
  static Color get primaryDark => const Color(0xFF0F151E);

  static Color get splashBackground =>
      isDark ? const Color(0xFF081018) : const Color(0xFF102530);

  static Color get accentDark => const Color(0xFF0E2E3D);
}
