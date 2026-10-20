import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

abstract final class AppTheme {
  static final ThemeData dark = _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.neonCyan,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.neonCyan,
      secondary: AppColors.neonLime,
      surface: AppColors.obsidianSurface,
      onSurface: AppColors.darkOnSurface,
      error: AppColors.error,
    ),
    AppColors.obsidian,
  );

  static final ThemeData light = _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.deepWater,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.deepWater,
      secondary: AppColors.freshLime,
      surface: AppColors.frostSurface,
      onSurface: AppColors.lightOnSurface,
      error: AppColors.error,
    ),
    AppColors.frost,
  );

  static ThemeData _build(ColorScheme scheme, Color background) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: scheme.onSurface,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
