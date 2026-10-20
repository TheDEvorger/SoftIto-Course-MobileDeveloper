import 'package:flutter/material.dart';

/// Manages application-wide theme mode (dark vs. light)
/// using Flutter's native [ValueNotifier] without third-party state packages.
class ThemeController {
  ThemeController({ThemeMode initialMode = ThemeMode.dark})
      : themeMode = ValueNotifier<ThemeMode>(initialMode);

  final ValueNotifier<ThemeMode> themeMode;

  bool get isDark => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    if (themeMode.value != mode) {
      themeMode.value = mode;
    }
  }

  void dispose() {
    themeMode.dispose();
  }
}
