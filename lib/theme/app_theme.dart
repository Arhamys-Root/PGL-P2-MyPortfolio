import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF0B1023);
  static const primary = Color(0xFF9466FF);
  static const secondary = Color(0xFFFF4CC5);
  static const text = Color(0xFFF7F7FF);
  static const surface = Color(0xFF202440);

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      onSurface: text,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: text,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF151A30),
    ),
  );
}