import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryGold = Color(0xFFC8922A);
  static const Color parchment = Color(0xFFFDF6E3);
  static const Color deepWalnut = Color(0xFF1C1008);
  static const Color richBrown = Color(0xFF3E1E00);
  static const Color terracotta = Color(0xFFA0522D);
  static const Color surfaceAmber = Color(0xFFF5E0B0);
  static const Color surfaceDark = Color(0xFF2C1A0A);
  static const Color wheatText = Color(0xFFF5DEB3);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGold,
        brightness: Brightness.light,
        primary: primaryGold,
        surface: parchment,
        onPrimary: Colors.white,
        onSurface: richBrown,
      ),
      scaffoldBackgroundColor: parchment,
      textTheme: GoogleFonts.tiroDevanagariMarathiTextTheme(
        ThemeData.light().textTheme.apply(
          bodyColor: richBrown,
          displayColor: richBrown,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGold,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.tiroDevanagariMarathi(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceAmber,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGold,
        brightness: Brightness.dark,
        primary: primaryGold,
        surface: deepWalnut,
        onPrimary: Colors.white,
        onSurface: wheatText,
      ),
      scaffoldBackgroundColor: deepWalnut,
      textTheme: GoogleFonts.tiroDevanagariMarathiTextTheme(
        ThemeData.dark().textTheme.apply(
          bodyColor: wheatText,
          displayColor: wheatText,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: wheatText,
        elevation: 0,
        titleTextStyle: GoogleFonts.tiroDevanagariMarathi(
          color: wheatText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
