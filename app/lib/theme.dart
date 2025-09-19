import 'package:flutter/material.dart';

// Shoply color system (60/30/10)
class ShoplyColors {
  static const Color background = Color(0xFFF9F9F9); // 60%
  static const Color primary = Color(0xFFA8E6CF); // 30%
  static const Color accent = Color(0xFFFFD5C2); // 10%
  static const Color highlight = Color(0xFFFFB347); // offers
  
  static const Color text = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color error = Color(0xFFE57373);
  static const Color shadow = Color(0x1A000000);
}

ThemeData buildShoplyTheme() {
  return ThemeData(
    colorScheme: ColorScheme.light(
      background: ShoplyColors.background,
      surface: ShoplyColors.background,
      primary: ShoplyColors.primary,
      secondary: ShoplyColors.accent,
      tertiary: ShoplyColors.highlight,
      onBackground: ShoplyColors.text,
      onSurface: ShoplyColors.text,
      onPrimary: ShoplyColors.text,
      error: ShoplyColors.error,
    ),
    scaffoldBackgroundColor: ShoplyColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: ShoplyColors.background,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: ShoplyColors.text,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: ShoplyColors.text),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ShoplyColors.primary,
        foregroundColor: ShoplyColors.text,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: ShoplyColors.text, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: ShoplyColors.text, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: ShoplyColors.text, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: ShoplyColors.text),
      bodyMedium: TextStyle(color: ShoplyColors.textSecondary),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shadowColor: ShoplyColors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ShoplyColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ShoplyColors.primary, width: 2),
      ),
    ),
  );
}