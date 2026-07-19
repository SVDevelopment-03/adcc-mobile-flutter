import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.softCream,

    primaryColor: AppColors.deepRed,

    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.deepRed,
      surfaceBright:AppColors.lightDeepRed,
      surface: AppColors.softCream,
      onSurface: AppColors.charcoal,
  
      secondary: AppColors.goldenOchre,
      onSecondaryContainer:AppColors.dustyRose
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.softCream,
      foregroundColor: AppColors.charcoal,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.charcoal),
      bodyMedium: TextStyle(color: AppColors.charcoal),
      titleLarge: TextStyle(
        color: AppColors.charcoal,
        fontWeight: FontWeight.bold,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.dustyRose.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.goldenOchre,
      unselectedLabelColor: AppColors.charcoal,
      indicatorColor: AppColors.goldenOchre,
    ),
  );
}
