import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class AppTheme {
  static ThemeData light() => _theme(Brightness.light);
  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      brightness: brightness,
      primary: AppColors.emerald,
      secondary: AppColors.cyan,
      tertiary: AppColors.emeraldDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? AppColors.navyDark : AppColors.surfaceLight,
      textTheme: AppTypography.textTheme(isDark ? AppColors.textDark : AppColors.textLight),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? const Color(0xFFB7E6FF) : AppColors.navy,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
