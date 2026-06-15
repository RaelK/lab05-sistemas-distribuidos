import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    const primaryGreen = Color(0xFF0B7A3B);
    const darkGreen = Color(0xFF063B1E);
    const accentGreen = Color(0xFF20C76A);
    const background = Color(0xFFF3F7F4);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: accentGreen,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
