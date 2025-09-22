import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    fontFamily: 'Poppins',
    // Add elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF3A3A3C),
        fontWeight: FontWeight.w400,
        height: 1.0,
      ),
      bodyLarge: TextStyle(
        fontSize: 20,
        color: Color(0xFF3A3A3C),
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF000000),
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 28.07,
        fontWeight: FontWeight.bold, // Extra Bold
        height: 1.0, // 100% line height
        letterSpacing: 0,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontSize: 22.98,
        fontWeight: FontWeight.w400,
        fontFamily: 'Rubik',
        color: Color(0xFF22C45D),
      ),
    ),
  );
}
