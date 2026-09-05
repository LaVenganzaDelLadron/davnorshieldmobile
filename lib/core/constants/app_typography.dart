import 'package:flutter/material.dart';

class AppTypography {
  static const fontFamily = 'Inter';

  static TextTheme textTheme(Color bodyColor) {
    return const TextTheme(
      headlineMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.8),
      bodyLarge: TextStyle(fontSize: 16, height: 1.45, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ).apply(
      fontFamily: fontFamily,
      bodyColor: bodyColor,
      displayColor: bodyColor,
    );
  }
}
