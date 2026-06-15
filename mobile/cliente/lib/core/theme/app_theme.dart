import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF0B7A3B);
  static const Color darkGreen = Color(0xFF05351A);
  static const Color neonGreen = Color(0xFF21D36B);
  static const Color sportOrange = Color(0xFFFF8A00);
  static const Color background = Color(0xFFF2F6F3);
  static const Color darkText = Color(0xFF17251C);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: sportOrange,
        tertiary: neonGreen,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sportOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.w900, color: darkText),
        titleLarge: TextStyle(fontWeight: FontWeight.w900, color: darkText),
        titleMedium: TextStyle(fontWeight: FontWeight.w800, color: darkText),
        bodyMedium: TextStyle(color: darkText),
      ),
    );
  }
}
