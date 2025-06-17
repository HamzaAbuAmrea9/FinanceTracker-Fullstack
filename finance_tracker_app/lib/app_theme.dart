import 'package:flutter/material.dart';

class AppTheme {
  // Define our custom colors
  static const Color primaryColor = Color(0xFF6A5AE0); // A nice purple
  static const Color accentColor = Color(0xFF2EC4B6); // A teal accent
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color textColor = Color(0xFF212529);
  static const Color lightTextColor = Color(0xFF6C757D);

  static ThemeData get theme {
    return ThemeData(
      fontFamily: 'Poppins', // Apply our custom font
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,

      
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        background: backgroundColor,
        surface: Colors.white,
        onBackground: textColor,
        onSurface: textColor,
        error: Colors.redAccent,
        onError: Colors.white,
      ),

      // Define text styles
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        titleLarge: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        titleMedium: TextStyle(fontWeight: FontWeight.w500, color: lightTextColor),
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: lightTextColor),
      ),

      // Define AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Define ElevatedButton theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        ),
      ),
      
      // Define Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),

      // Define input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: lightTextColor),
      ),
    );
  }
}