import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/core/theme/precision_theme.dart';

double contrast(Color a, Color b) {
  final first = a.computeLuminance();
  final second = b.computeLuminance();
  final high = first > second ? first : second;
  final low = first < second ? first : second;
  return (high + 0.05) / (low + 0.05);
}

void main() {
  for (final brightness in Brightness.values) {
    test('$brightness text and control contrast', () {
      final theme = brightness == Brightness.light
          ? PrecisionTheme.light()
          : PrecisionTheme.dark();
      final colors = theme.colorScheme;
      final textPairs = [
        (colors.onSurface, colors.surface),
        (colors.onSurfaceVariant, colors.surface),
        (colors.onPrimary, colors.primary),
        (colors.onSecondary, colors.secondary),
        (colors.onError, colors.error),
        (colors.error, colors.surface),
        (colors.onSurface, theme.scaffoldBackgroundColor),
      ];
      for (final (foreground, background) in textPairs) {
        expect(contrast(foreground, background), greaterThanOrEqualTo(4.5));
      }
      expect(contrast(colors.outline, colors.surface), greaterThanOrEqualTo(3));
      expect(contrast(colors.primary, colors.surface), greaterThanOrEqualTo(3));
      expect(theme.brightness, brightness);
      expect(theme.textTheme.headlineMedium?.fontWeight, FontWeight.w700);
    });
  }
}
