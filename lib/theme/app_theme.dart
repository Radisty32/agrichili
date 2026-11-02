import 'package:flutter/material.dart';

class AppTheme {
  // Primary Agri Green Palette
  static const Color primaryGreen = Color(0xFF0F5A36);
  static const Color primaryDark = Color(0xFF083D23);
  static const Color primaryLight = Color(0xFF19794B);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color mintBackground = Color(0xFFEAF5EE);
  static const Color scaffoldBackground = Color(0xFFF3F6F3);
  static const Color cardBackground = Colors.white;
  static const Color cardBorder = Color(0xFFE2EBE2);

  // Status & Alert Colors
  static const Color statusOptimalBg = Color(0xFFE8F5E9);
  static const Color statusOptimalText = Color(0xFF15803D);
  static const Color statusWarningBg = Color(0xFFFEF3C7);
  static const Color statusWarningText = Color(0xFFB45309);
  static const Color statusDangerBg = Color(0xFFFEE2E2);
  static const Color statusDangerText = Color(0xFFB91C1C);
  static const Color statusInfoBg = Color(0xFFE0F2FE);
  static const Color statusInfoText = Color(0xFF0369A1);

  // Text Colors
  static const Color textDark = Color(0xFF0F172A);
  static const Color textBody = Color(0xFF334155);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Gauge & Chart Colors
  static const Color gaugeDry = Color(0xFFF59E0B); // < 60% Kering
  static const Color gaugeIdeal = Color(0xFF0F5A36); // 60 - 80% Ideal
  static const Color gaugeWet = Color(0xFF0284C7); // > 80% Jenuh

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: accentGreen,
        surface: cardBackground,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: primaryGreen),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: cardBorder, width: 1),
        ),
      ),
    );
  }
}
