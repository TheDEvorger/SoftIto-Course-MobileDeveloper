import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Extension methods on [BuildContext] to access theme colors and typography cleanly.
extension ThemeContextExtensions on BuildContext {
  /// Theme-aware semantic colors for the current active theme.
  AppThemeColors get colors =>
      Theme.of(this).extension<AppThemeColors>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? AppThemeColors.dark
          : AppThemeColors.light);

  /// Whether current theme is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Shorthand to Theme textTheme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Shorthand to Theme colorScheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
