import 'package:flutter/material.dart';
import '../../domain/models/student_preferences.dart';

class AppThemeController {
  AppThemeController._();
  static final AppThemeController instance = AppThemeController._();

  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  void updateFromPreference(ThemeModePreference pref) {
    switch (pref) {
      case ThemeModePreference.system:
        themeModeNotifier.value = ThemeMode.system;
        break;
      case ThemeModePreference.light:
        themeModeNotifier.value = ThemeMode.light;
        break;
      case ThemeModePreference.dark:
        themeModeNotifier.value = ThemeMode.dark;
        break;
    }
  }
}
