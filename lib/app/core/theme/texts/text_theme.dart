// app/core/theme/texts/text_theme.dart

import 'package:flutter/material.dart';
import 'package:clima_app2/app/core/theme/colors/app_colors.dart';

/// 🎨 Tema de texto personalizado para modo escuro
/// Utiliza a fonte 'Poppins' e as cores definidas em [AppColors]
class AppTextTheme {
  static TextTheme get darkTextTheme => const TextTheme(
    // 🌡️ Temperatura principal
    displayLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 64,
      fontWeight: FontWeight.w300,
      color: AppColors.textPrimary,
    ),

    // 🌤️ Temperatura secundária ou destaque
    displayMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 48,
      fontWeight: FontWeight.w300,
      color: AppColors.textPrimary,
    ),

    // 🧭 Título de seção (ex: "Hoje", "Previsão")
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),

    // 🏙️ Nome da cidade ou data
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    ),

    // 📊 Detalhes principais (umidade, pressão, vento)
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),

    // 📌 Detalhes secundários ou legendas
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: AppColors.textSecondary,
    ),

    // 🧾 Informações desabilitadas ou apagadas
    labelSmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: AppColors.textFaded,
    ),
  );
}