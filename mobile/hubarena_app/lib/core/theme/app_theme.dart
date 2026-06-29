import 'package:flutter/material.dart';

class AppTheme {
  static const Color dark = Color(0xFF071A12);
  static const Color green = Color(0xFF0B7A3B);
  static const Color lightGreen = Color(0xFF24D26A);
  static const Color orange = Color(0xFFFF8A00);
  static const Color background = Color(0xFFF4F7F5);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: green,
        primary: green,
        secondary: orange,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: dark,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
