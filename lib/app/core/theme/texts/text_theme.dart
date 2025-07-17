import 'package:flutter/material.dart';
import 'package:clima_app2/app/core/theme/colors/app_colors.dart';

class AppTextTheme {
  static TextTheme get darkTextTheme => TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 64,
          fontWeight: FontWeight.w300,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 48,
          fontWeight: FontWeight.w300,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: AppColors.textFaded,
        ),
      );
}