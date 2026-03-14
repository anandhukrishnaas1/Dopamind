import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Light theme colors
  static const Color lightBackground = Color(0xFFFBFBFB);
  static const Color lightForeground = Color(0xFF1A1A1A);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardForeground = Color(0xFF1A1A1A);
  static const Color lightPrimary = Color(0xFF1A1A1A);
  static const Color lightPrimaryForeground = Color(0xFFFBFBFB);
  static const Color lightSecondary = Color(0xFFF0F0F0);
  static const Color lightSecondaryForeground = Color(0xFF2D2D2D);
  static const Color lightMuted = Color(0xFFEBEBEB);
  static const Color lightMutedForeground = Color(0xFF6B6B6B);
  static const Color lightAccent = Color(0xFFE5E5E5);
  static const Color lightAccentForeground = Color(0xFF2D2D2D);
  static const Color lightDestructive = Color(0xFFDC2626);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightInput = Color(0xFFE5E5E5);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF1F1F1F);
  static const Color darkForeground = Color(0xFFF0F0F0);
  static const Color darkCard = Color(0xFF2A2A2A);
  static const Color darkCardForeground = Color(0xFFF0F0F0);
  static const Color darkPrimary = Color(0xFFF0F0F0);
  static const Color darkPrimaryForeground = Color(0xFF1F1F1F);
  static const Color darkSecondary = Color(0xFF363636);
  static const Color darkSecondaryForeground = Color(0xFFF0F0F0);
  static const Color darkMuted = Color(0xFF363636);
  static const Color darkMutedForeground = Color(0xFF999999);
  static const Color darkAccent = Color(0xFF404040);
  static const Color darkAccentForeground = Color(0xFFF0F0F0);
  static const Color darkDestructive = Color(0xFFB91C1C);
  static const Color darkBorder = Color(0xFF404040);
  static const Color darkInput = Color(0xFF363636);

  // Shared semantic colors
  static const Color dopamineLow = Color(0xFF4CAF50);
  static const Color dopamineMedium = Color(0xFFFFA726);
  static const Color dopamineHigh = Color(0xFFEF5350);
  static const Color focusActive = Color(0xFF42A5F5);
  static const Color success = Color(0xFF66BB6A);

  // Chart colors (light)
  static const Color chart1Light = Color(0xFF3B82F6);
  static const Color chart2Light = Color(0xFF10B981);
  static const Color chart3Light = Color(0xFFF59E0B);
  static const Color chart4Light = Color(0xFFA855F7);
  static const Color chart5Light = Color(0xFFEF4444);

  // Chart colors (dark)
  static const Color chart1Dark = Color(0xFF60A5FA);
  static const Color chart2Dark = Color(0xFF34D399);
  static const Color chart3Dark = Color(0xFFFBBF24);
  static const Color chart4Dark = Color(0xFFC084FC);
  static const Color chart5Dark = Color(0xFFF87171);
}

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightPrimaryForeground,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightSecondaryForeground,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightCardForeground,
        error: AppColors.lightDestructive,
        outline: AppColors.lightBorder,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.lightMutedForeground),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightPrimaryForeground,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightForeground,
          side: const BorderSide(color: AppColors.lightBorder),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimaryForeground;
          }
          return AppColors.lightMutedForeground;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return AppColors.lightMuted;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightForeground,
        ),
        iconTheme: const IconThemeData(color: AppColors.lightForeground),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkPrimaryForeground,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkSecondaryForeground,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkCardForeground,
        error: AppColors.darkDestructive,
        outline: AppColors.darkBorder,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.darkMutedForeground),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkPrimaryForeground,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkForeground,
          side: const BorderSide(color: AppColors.darkBorder),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimaryForeground;
          }
          return AppColors.darkMutedForeground;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary;
          }
          return AppColors.darkMuted;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkForeground,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkForeground),
      ),
    );
  }
}
