import 'package:flutter/material.dart';

/// Dark obsidian & neon palette constants.
abstract final class AppColors {
  static const background = Color(0xFF0B1218);
  static const surface = Color(0xFF141F27);
  static const elevatedSurface = Color(0xFF1B2932);
  static const accent = Color(0xFF61E4D3);
  static const accentMuted = Color(0xFF244B4D);
  static const brandSurface = Color(0xFF17383B);
  static const workoutSurface = Color(0xFF352B42);
  static const workoutAccent = Color(0xFFD2A9FF);
  static const textPrimary = Color(0xFFF3F7F7);
  static const textSecondary = Color(0xFF9EADB4);
  static const divider = Color(0xFF29363E);
  static const success = Color(0xFF91E6A8);
}

/// Dynamic daylight & athletic slate palette constants for light mode.
abstract final class AppColorsLight {
  static const background = Color(0xFFF5F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const elevatedSurface = Color(0xFFE9F0F3);
  static const accent = Color(0xFF00897B);
  static const accentMuted = Color(0xFFE0F2F1);
  static const brandSurface = Color(0xFFD7F4F0);
  static const workoutSurface = Color(0xFFF2EAF9);
  static const workoutAccent = Color(0xFF7E38B7);
  static const textPrimary = Color(0xFF122026);
  static const textSecondary = Color(0xFF5A717D);
  static const divider = Color(0xFFE1E8EC);
  static const success = Color(0xFF1E8E42);
}

/// ThemeExtension providing type-safe, theme-aware semantic colors across widgets.
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.accent,
    required this.accentMuted,
    required this.brandSurface,
    required this.workoutSurface,
    required this.workoutAccent,
    required this.elevatedSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.success,
    required this.progressRingBackground,
  });

  final Color accent;
  final Color accentMuted;
  final Color brandSurface;
  final Color workoutSurface;
  final Color workoutAccent;
  final Color elevatedSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color success;
  final Color progressRingBackground;

  static const dark = AppThemeColors(
    accent: AppColors.accent,
    accentMuted: AppColors.accentMuted,
    brandSurface: AppColors.brandSurface,
    workoutSurface: AppColors.workoutSurface,
    workoutAccent: AppColors.workoutAccent,
    elevatedSurface: AppColors.elevatedSurface,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    divider: AppColors.divider,
    success: AppColors.success,
    progressRingBackground: AppColors.elevatedSurface,
  );

  static const light = AppThemeColors(
    accent: AppColorsLight.accent,
    accentMuted: AppColorsLight.accentMuted,
    brandSurface: AppColorsLight.brandSurface,
    workoutSurface: AppColorsLight.workoutSurface,
    workoutAccent: AppColorsLight.workoutAccent,
    elevatedSurface: AppColorsLight.elevatedSurface,
    textPrimary: AppColorsLight.textPrimary,
    textSecondary: AppColorsLight.textSecondary,
    divider: AppColorsLight.divider,
    success: AppColorsLight.success,
    progressRingBackground: Color(0xFFE2EBEF),
  );

  @override
  ThemeExtension<AppThemeColors> copyWith({
    Color? accent,
    Color? accentMuted,
    Color? brandSurface,
    Color? workoutSurface,
    Color? workoutAccent,
    Color? elevatedSurface,
    Color? textPrimary,
    Color? textSecondary,
    Color? divider,
    Color? success,
    Color? progressRingBackground,
  }) {
    return AppThemeColors(
      accent: accent ?? this.accent,
      accentMuted: accentMuted ?? this.accentMuted,
      brandSurface: brandSurface ?? this.brandSurface,
      workoutSurface: workoutSurface ?? this.workoutSurface,
      workoutAccent: workoutAccent ?? this.workoutAccent,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      progressRingBackground:
          progressRingBackground ?? this.progressRingBackground,
    );
  }

  @override
  ThemeExtension<AppThemeColors> lerp(
    covariant ThemeExtension<AppThemeColors>? other,
    double t,
  ) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t) ?? accentMuted,
      brandSurface:
          Color.lerp(brandSurface, other.brandSurface, t) ?? brandSurface,
      workoutSurface:
          Color.lerp(workoutSurface, other.workoutSurface, t) ?? workoutSurface,
      workoutAccent:
          Color.lerp(workoutAccent, other.workoutAccent, t) ?? workoutAccent,
      elevatedSurface:
          Color.lerp(elevatedSurface, other.elevatedSurface, t) ??
              elevatedSurface,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      success: Color.lerp(success, other.success, t) ?? success,
      progressRingBackground:
          Color.lerp(
            progressRingBackground,
            other.progressRingBackground,
            t,
          ) ??
          progressRingBackground,
    );
  }
}
