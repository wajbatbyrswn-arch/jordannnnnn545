import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color rockyPink = Color(0xFFCE796B); // Soft rock pink
  static const Color seaBlue = Color(0xFF005B96); // Deep sea blue
  static const Color background = Color(0xFFF9F7F6);
  static const Color textDark = Color(0xFF333333);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: seaBlue,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seaBlue,
        primary: seaBlue,
        secondary: rockyPink,
        surface: background,
      ),
      textTheme: GoogleFonts.tajawalTextTheme().apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: seaBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: rockyPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
