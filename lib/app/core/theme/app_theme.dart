import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clima_app2/app/core/theme/colors/app_colors.dart';
import 'package:clima_app2/app/core/theme/texts/text_theme.dart';

class AppTheme {

  static final ThemeData test = ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(), // sem GoogleFonts
  );

  static ThemeData dark = ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundTop,
        primaryColor: AppColors.iconColor,
        cardColor: AppColors.surface,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: AppColors.iconColor,
          secondary: AppColors.textSecondary,
          surface: AppColors.surface,
        ),
        textTheme: AppTextTheme.darkTextTheme,
        iconTheme: const IconThemeData(color: AppColors.iconColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: AppColors.textFaded),
        ),
      ) ;
}