import 'package:flutter/material.dart';

abstract final class PrecisionSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const controlHeight = 48.0;
}

abstract final class PrecisionTypography {
  static TextTheme apply(TextTheme base) => base.copyWith(
        headlineMedium: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        bodyLarge: base.bodyLarge?.copyWith(height: 1.5),
        bodyMedium: base.bodyMedium?.copyWith(height: 1.5),
        labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      );
}
