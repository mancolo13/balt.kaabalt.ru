import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Baltbet Official Brand Colors
  static const Color primary = Color(0xFF4675A1); // Baltbet Signature Slate Blue
  static const Color primaryLight = Color(0xFF66B3FF); // Bright Accent Cyan/Blue
  static const Color primaryDark = Color(0xFF2E5375); // Deep Blue
  static const Color secondary = Color(0xFF4CAF50); // Sportsbook Field Green
  static const Color accentGold = Color(0xFFF7B000); // Baltbet Iconic Gold/Amber
  static const Color accentRose = Color(0xFFEB4250); // Baltbet Live Red
  static const Color accentOrange = Color(0xFFFF9100);

  // Background Surfaces matching baltbet.ru
  static const Color background = Color(0xFF1D242E); // Baltbet Main Slate Dark
  static const Color surface = Color(0xFF25313D); // Baltbet Header & Blocks
  static const Color surfaceCard = Color(0xFF2A3846); // Baltbet Elevated Cards
  static const Color surfaceBorder = Color(0xFF39434E); // Baltbet Subtle Border
  static const Color surfaceHighlight = Color(0xFF324354);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A99A8);
  static const Color textMuted = Color(0xFF5A6878);

  // Box Shadows
  static List<BoxShadow> get baltbetCardShadow => [
        BoxShadow(
          color: Colors.black.withAlpha(50),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];

  static List<BoxShadow> get goldGlow => [
        BoxShadow(
          color: accentGold.withAlpha(45),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ];

  static List<BoxShadow> get neonGlow => goldGlow;

  static List<BoxShadow> get blueGlow => [
        BoxShadow(
          color: primaryLight.withAlpha(45),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ];

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accentGold,
        surface: surface,
        error: accentRose,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: 0.4,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accentGold,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
