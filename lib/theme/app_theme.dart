import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color accent = Color(0xFFFF8A00);

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF4F6F9),
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1565C0),
      secondary: accent,
      surface: Colors.white,
      onSurface: Color(0xFF1A1A1A),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFF4F6F9),
      elevation: 0,
      foregroundColor: const Color(0xFF1A1A1A),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A1A),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodyMedium: GoogleFonts.poppins(color: const Color(0xFF6B6B6B)),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121417),
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4C8DFF),
      secondary: accent,
      surface: Color(0xFF1E2126),
      onSurface: Color(0xFFEDEDED),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF121417),
      elevation: 0,
      foregroundColor: const Color(0xFFEDEDED),
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFEDEDED),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      bodyMedium: GoogleFonts.poppins(color: const Color(0xFFA0A0A0)),
    ),
  );

  // Style dédié au logo "Easymairie"
  static TextStyle logoStyle(Color color, {double size = 28}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      color: color,
    );
  }
}