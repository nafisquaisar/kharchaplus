import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _lightPrimary = Color(0xFF2EC4B6);
  static const Color _lightSecondary = Color(0xFF1B7F8C);
  static const Color _lightTertiary = Color(0xFF38BDF8);
  static const Color _lightBackground = Color(0xFFF4FBFA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightSurfaceVariant = Color(0xFFE0F2F1);
  static const Color _lightOutline = Color(0xFFE0F2F1);
  static const Color _lightOnSurface = Color(0xFF0B1F23);
  static const Color _lightCard = Color(0xFFFFFFFF);

  static const Color _darkPrimary = Color(0xFF2EC4B6);
  static const Color _darkSecondary = Color(0xFF38BDF8);
  static const Color _darkTertiary = Color(0xFF155E75);
  static const Color _darkBackground = Color(0xFF0F151E);
  static const Color _darkSurface = Color(0xFF111827);
  static const Color _darkSurfaceVariant = Color(0xFF1A2330);
  static const Color _darkOutline = Color(0x1FFFFFFF);
  static const Color _darkOnSurface = Color(0xFFE2E8F0);
  static const Color _darkCard = Color(0xFF1A2330);

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: _lightPrimary,
    brightness: Brightness.light,
  ).copyWith(
    primary: _lightPrimary,
    onPrimary: const Color(0xFFFFFFFF),
    secondary: _lightSecondary,
    onSecondary: const Color(0xFFFFFFFF),
    tertiary: _lightTertiary,
    onTertiary: const Color(0xFF0B1F23),
    surface: _lightSurface,
    onSurface: _lightOnSurface,
    onSurfaceVariant: const Color(0xFF4F676C),
    outline: _lightOutline,
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: _darkPrimary,
    brightness: Brightness.dark,
  ).copyWith(
    primary: _darkPrimary,
    onPrimary: const Color(0xFF0B1F23),
    secondary: _darkSecondary,
    onSecondary: const Color(0xFF0B1F23),
    tertiary: _darkTertiary,
    onTertiary: const Color(0xFFE2E8F0),
    surface: _darkSurface,
    onSurface: _darkOnSurface,
    onSurfaceVariant: const Color(0xFFB5C4D2),
    outline: _darkOutline,
  );

  static ThemeData lightTheme = _buildTheme(
    _lightScheme,
    isDark: false,
    cardColor: _lightCard,
    backgroundColor: _lightBackground,
    inputFillColor: _lightSurfaceVariant,
  );

  static ThemeData darkTheme = _buildTheme(
    _darkScheme,
    isDark: true,
    cardColor: _darkCard,
    backgroundColor: _darkBackground,
    inputFillColor: _darkSurfaceVariant,
  );

  static ThemeData _buildTheme(
    ColorScheme scheme, {
    required bool isDark,
    required Color cardColor,
    required Color backgroundColor,
    required Color inputFillColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: backgroundColor,
      canvasColor: scheme.surface,
      shadowColor: scheme.shadow,
      textTheme: _textTheme(scheme, isDark),
      iconTheme: IconThemeData(
        color: scheme.onSurfaceVariant,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        surfaceTintColor: scheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.error,
          ),
        ),
        labelStyle: TextStyle(
          color: scheme.onSurfaceVariant,
        ),
        hintStyle: TextStyle(
          color: scheme.onSurfaceVariant,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surface,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: 14,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surface,
        modalBackgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withAlpha(36),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        selectedIconTheme: IconThemeData(
          color: scheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          color: scheme.onSurfaceVariant,
        ),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: scheme.onInverseSurface,
        ),
        actionTextColor: scheme.primary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary.withAlpha(90)
              : inputFillColor,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(
          scheme.onPrimary,
        ),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.outline,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        selectedColor: scheme.primary,
        selectedTileColor: scheme.primary.withAlpha(20),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        surfaceTintColor: scheme.surface,
        textStyle: TextStyle(
          color: scheme.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(
            color: scheme.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme, bool isDark) {
    final base = isDark
        ? Typography.material2021().white
        : Typography.material2021().black;
    return base.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      decorationColor: scheme.onSurface,
    );
  }
}