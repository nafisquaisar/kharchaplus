import 'package:flutter/material.dart';

import '../constants/AppColors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    floatingActionButtonTheme:
    const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
    ),

    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}