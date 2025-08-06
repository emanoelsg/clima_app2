// app/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clima_app2/app/core/theme/colors/app_colors.dart';
import 'package:clima_app2/app/core/theme/texts/text_theme.dart';

/// 🎨 Tema principal da aplicação
/// Define estilos para modo escuro, incluindo cores, tipografia e componentes
class AppTheme {
  /// 🔧 Tema de teste simples (sem GoogleFonts)
  static final ThemeData test = ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(), // Apenas estrutura básica
  );

  /// 🌙 Tema escuro completo
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,

    // 🖼️ Cores de fundo
    scaffoldBackgroundColor: AppColors.backgroundTop,
    primaryColor: AppColors.iconColor,
    cardColor: AppColors.surface,

    // 🧭 AppBar personalizada
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

    // 🎨 Esquema de cores
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.iconColor,
      secondary: AppColors.textSecondary,
      surface: AppColors.surface,
    ),

    // 📝 Tipografia
    textTheme: AppTextTheme.darkTextTheme,

    // 🎯 Ícones
    iconTheme: const IconThemeData(color: AppColors.iconColor),

    // 🔘 Botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    ),

    // 🧾 Campos de texto
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: AppColors.textFaded),
    ),
  );
}
