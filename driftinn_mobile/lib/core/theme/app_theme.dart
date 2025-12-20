import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors from HTML/CSS
  static const Color primary = Color(0xFF412BEE); // #412bee
  static const Color primaryHover = Color(
    0xFF3B27D6,
  ); // Slightly darker for hover
  static const Color backgroundDark = Color(0xFF121022); // #121022
  static const Color backgroundLight = Color(0xFFF6F6F8); // #f6f6f8

  static const Color backgroundCard = Color(
    0x0DFFFFFF,
  ); // rgba(255, 255, 255, 0.05)
  static const Color textMain = Color(
    0xFFFFFFFE,
  ); // Keeping text white/off-white for dark mode
  static const Color textMuted = Color(
    0xFFA7A9BE,
  ); // Matches typical muted text
  static const Color glassBorder = Color(
    0x1AFFFFFF,
  ); // rgba(255, 255, 255, 0.1)

  // New colors from HTML
  static const Color surfaceDark = Color(0xFF1C1A2E);
  static const Color deepIndigo = Color(0xFF4C51BF);
  static const Color electricTeal = Color(0xFF3CDBC0);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color nearBlack = Color(0xFF212529);
  static const Color mutedGray = Color(0xFF6C757D);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryHover,
        surface: backgroundCard,
        onSurface: textMain,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(bodyColor: textMain, displayColor: textMain),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0x08FFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary),
        ),
        hintStyle: const TextStyle(color: textMuted),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
