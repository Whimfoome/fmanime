import 'package:flutter/material.dart';

/*
  ~ Colors for Tako theme
  ~ Original color scheme by ghostbear
  ~
  ~ Key colors:
  ~ Primary #F3B375
  ~ Secondary #F3B375
  ~ Tertiary #66577E
  ~ Neutral #21212E
*/

ThemeData appTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFF3B375),
    canvasColor: const Color(0xFF21212E),
    colorScheme: const ColorScheme(
      primary: Color(0xFFF3B375),
      onPrimary: Color(0xFF38294E),
      primaryContainer: Color(0xFF38294E),
      onPrimaryContainer: Color(0xFF38294E),
      secondary: Color(0xFFF3B375),
      onSecondary: Color(0xFF38294E),
      secondaryContainer: Color(0xFFF3B375),
      tertiary: Color(0xFF66577E),
      onTertiary: Color(0xFFF3B375),
      tertiaryContainer: Color(0xFF4E4065),
      onTertiaryContainer: Color(0xFFEDDCFF),
      background: Color(0xFF21212E),
      onBackground: Color(0xFFE3E0F2),
      surface: Color(0xFF21212E),
      onSurface: Color(0xFFE3E0F2),
      surfaceVariant: Color(0xFF49454E),
      onSurfaceVariant: Color(0xFFCBC4CE),
      outline: Color(0xFF958F99),
      inversePrimary: Color(0xFF84531E),
      inverseSurface: Color(0xFFE5E1E6),
      onInverseSurface: Color(0xFF1B1B1E),
      error: Color(0xFFB00020),
      onError: Color(0xFFB00020),
      brightness: Brightness.dark,
    ),
  );
}
