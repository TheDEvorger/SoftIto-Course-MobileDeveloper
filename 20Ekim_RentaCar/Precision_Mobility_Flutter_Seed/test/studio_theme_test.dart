import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/core/theme/studio_theme.dart';

double contrast(Color a, Color b) {
  final first = a.computeLuminance(), second = b.computeLuminance();
  return ((first > second ? first : second) + .05) /
      ((first > second ? second : first) + .05);
}

void main() {
  for (final dark in [false, true]) {
    test('studio text and controls dark=$dark', () {
      final theme = dark ? StudioTheme.dark() : StudioTheme.light();
      final c = theme.colorScheme;
      for (final pair in [
        (c.onSurface, c.surface),
        (c.onSurfaceVariant, c.surface),
        (c.onPrimary, c.primary),
        (c.onPrimaryContainer, c.primaryContainer),
        (c.onSecondary, c.secondary),
        (c.onSecondaryContainer, c.secondaryContainer),
        (c.onSurface, theme.scaffoldBackgroundColor)
      ]) {
        expect(contrast(pair.$1, pair.$2), greaterThanOrEqualTo(4.5));
      }
      expect(contrast(c.outline, c.surface), greaterThanOrEqualTo(3));
    });
  }
}
