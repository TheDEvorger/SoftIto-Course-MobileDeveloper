import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/theme_controller.dart';

void main() {
  group('ThemeController', () {
    late ThemeController controller;

    setUp(() {
      controller = ThemeController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('defaults to dark mode initially', () {
      expect(controller.themeMode.value, ThemeMode.dark);
      expect(controller.isDark, isTrue);
    });

    test('toggleTheme toggles between dark and light', () {
      controller.toggleTheme();
      expect(controller.themeMode.value, ThemeMode.light);
      expect(controller.isDark, isFalse);

      controller.toggleTheme();
      expect(controller.themeMode.value, ThemeMode.dark);
      expect(controller.isDark, isTrue);
    });

    test('setThemeMode updates themeMode explicitly', () {
      controller.setThemeMode(ThemeMode.light);
      expect(controller.themeMode.value, ThemeMode.light);

      controller.setThemeMode(ThemeMode.system);
      expect(controller.themeMode.value, ThemeMode.system);
      expect(controller.isDark, isFalse);
    });
  });
}
