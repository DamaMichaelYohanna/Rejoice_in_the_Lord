import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors extracted from "Rejoice in the Lord 3rd Edition" cover
  static const Color cyanPrimary = Color(0xFF0096D6);
  static const Color cyanDark = Color(0xFF006899);
  static const Color cyanLight = Color(0xFFE0F4FC);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color cloudWhite = Color(0xFFF9FCFD);
  static const Color darkBackground = Color(0xFF0F1A24);
  static const Color darkSurface = Color(0xFF182836);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cyanPrimary,
        primary: cyanPrimary,
        onPrimary: Colors.white,
        secondary: goldAccent,
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: cloudWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: cyanPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cyanLight,
        selectedColor: cyanPrimary,
        secondarySelectedColor: cyanPrimary,
        labelStyle: const TextStyle(color: cyanDark, fontWeight: FontWeight.w600),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: cyanPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cyanPrimary,
        primary: cyanPrimary,
        onPrimary: Colors.white,
        secondary: goldAccent,
        surface: darkSurface,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 4,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF203647),
        selectedColor: cyanPrimary,
        labelStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: cyanPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
