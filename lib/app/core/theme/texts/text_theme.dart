import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clima_app2/app/core/theme/colors/app_colors.dart';

class AppTextTheme {
  static TextTheme get darkTextTheme => GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w300,
          color: AppColors.textPrimary,
        ),
        displayMedium: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          color: AppColors.textPrimary,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: AppColors.textSecondary,
        ),
        labelSmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: AppColors.textFaded,
        ),
      );
}