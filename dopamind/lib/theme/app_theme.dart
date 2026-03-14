import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Light theme colors
  static const Color lightBackground = Color(0xFFF9F9F9);
  static const Color lightForeground = Color(0xFF000000);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE5E5E5);
  static const Color lightMuted = Color(0xFFF3F3F3);
  static const Color lightMutedForeground = Color(0xFF737373);
  static const Color lightPrimary = Color(0xFFFF5722); // Keep orange as primary accent
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF000000); // Pure Black
  static const Color darkForeground = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF0A0A0A); // Very dark gray
  static const Color darkBorder = Color(0xFF1A1A1A);
  static const Color darkMuted = Color(0xFF121212);
  static const Color darkMutedForeground = Color(0xFF737373);
  static const Color darkPrimary = Color(0xFFFF5722); // Vibrant Orange

  // Gradients
  static const List<Color> orangeGradient = [Color(0xFFFF8A65), Color(0xFFFF5722)];
  
  // Semantic
  static const Color dopamineLow = Color(0xFF4CAF50);
  static const Color dopamineMedium = Color(0xFFFFA726);
  static const Color dopamineHigh = Color(0xFFEF5350);
  static const Color success = Color(0xFF66BB6A);

  // Chart colors
  static const Color chart1 = Color(0xFFFF5722);
  static const Color chart2 = Color(0xFF4CAF50);
  static const Color chart3 = Color(0xFF2196F3);
  static const Color chart4 = Color(0xFF9C27B0);
  static const Color chart5 = Color(0xFFFFC107);
}

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightPrimary,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightForeground,
        background: AppColors.lightBackground,
        onBackground: AppColors.lightForeground,
        outline: AppColors.lightBorder,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),
      dividerColor: AppColors.lightBorder,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkPrimary,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkForeground,
        background: AppColors.darkBackground,
        onBackground: AppColors.darkForeground,
        outline: AppColors.darkBorder,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      dividerColor: AppColors.darkBorder,
    );
  }
}
