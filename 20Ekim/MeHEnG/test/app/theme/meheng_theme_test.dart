import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/app/theme/meheng_theme.dart';
import 'package:meheng/app/theme/theme_provider.dart';

void main() {
  group('MehengTheme tokens and ThemeData', () {
    test('light theme has correct colors and brightness', () {
      final theme = MehengTheme.light;
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, MehengColors.forest);
      expect(theme.colorScheme.surface, MehengColors.canvas);
      expect(theme.colorScheme.secondary, MehengColors.copper);
      expect(theme.scaffoldBackgroundColor, MehengColors.canvas);
    });

    test('dark theme has correct colors and brightness', () {
      final theme = MehengTheme.dark;
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.surface, MehengColors.darkSurface);
      expect(theme.colorScheme.onSurface, MehengColors.darkInk);
      expect(theme.scaffoldBackgroundColor, MehengColors.darkCanvas);
    });

    test('spacing and radii tokens conform to design specifications', () {
      expect(MehengSpacing.xs, 8.0);
      expect(MehengSpacing.md, 16.0);
      expect(MehengSpacing.lg, 24.0);
      expect(MehengSpacing.maxContentWidth, 1120.0);
      expect(MehengRadii.sm, 10.0);
      expect(MehengRadii.md, 16.0);
      expect(MehengRadii.lg, 24.0);
    });

    test('themeModeProvider can switch between light, dark, and system', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.system);

      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), ThemeMode.dark);

      container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), ThemeMode.light);
    });
  });
}
