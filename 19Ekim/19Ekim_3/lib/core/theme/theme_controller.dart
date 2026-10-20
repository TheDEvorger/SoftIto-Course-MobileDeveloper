import 'package:flutter/material.dart';

/// Uygulama ömrü boyunca yaşayan tekil tema durumu.
class ThemeController {
  ThemeController._();

  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  void toggle({required bool isDark}) {
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  void setMode(ThemeMode mode) => themeMode.value = mode;
}
