import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette
  static const Color primaryDark = Color(0xFF0F2A4A);
  static const Color primaryMedium = Color(0xFF1E4A6B);
  static const Color primaryLight = Color(0xFF2D6A9A);
  static const Color primaryAccent = Color(0xFF4A90C2);
  static const Color secondaryAccent = Color(0xFF87CEEB);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color successGreen = Color(0xFF059669);
  static const Color warningRed = Color(0xFFFF6B6B);
  static const Color warningOrange = Color(0xFFFFA500);

  // Text Styles using Google Fonts
  static TextStyle get headingXL => GoogleFonts.poppins(
    fontSize: 25,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: 2.0,
    shadows: [
      const Shadow(
        offset: Offset(2, 2),
        blurRadius: 8,
        color: primaryAccent,
      ),
    ],
  );

  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 1.5,
    shadows: [
      const Shadow(
        offset: Offset(1, 1),
        blurRadius: 6,
        color: primaryAccent,
      ),
    ],
  );

  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 1.0,
  );

  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle get subtitle => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.8),
    letterSpacing: 1.0,
  );

  static TextStyle get bodyLarge => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.9),
    letterSpacing: 0.25,
  );

  static TextStyle get bodySmall => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white.withOpacity(0.7),
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle get buttonText => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 1.0,
  );

  static TextStyle get buttonSmall => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.8,
  );

  static TextStyle get linkText => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: accentCyan,
    letterSpacing: 0.5,
  );

  static TextStyle get labelText => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.8,
  );

  static TextStyle get caption => GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.6),
    letterSpacing: 0.4,
  );

  // Gradient Lists
  static List<Color> get backgroundGradient => [
    primaryDark,
    primaryMedium,
    primaryLight,
    primaryAccent,
  ];

  static List<Color> get buttonGradient => [
    primaryAccent,
    secondaryAccent,
  ];

  static List<Color> get cardGradient => [
    secondaryAccent.withOpacity(0.1),
    const Color(0xFF4169E1).withOpacity(0.05),
  ];

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryAccent,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: GoogleFonts.roboto().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryAccent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryAccent, width: 2),
        ),
        labelStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
        hintStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryAccent,
      scaffoldBackgroundColor: primaryDark,
      fontFamily: GoogleFonts.roboto().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.9),
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.7),
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryAccent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryAccent, width: 2),
        ),
        labelStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.8),
        ),
        hintStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}