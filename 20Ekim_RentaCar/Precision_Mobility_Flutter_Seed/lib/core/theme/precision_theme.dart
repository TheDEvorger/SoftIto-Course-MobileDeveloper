import 'package:flutter/material.dart';
import 'palette.dart';
import 'precision_tokens.dart';

abstract final class PrecisionTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final background = dark ? Palette.carbonBlack : Palette.arcticWhite;
    final surface = dark ? Palette.smokedGraphite : Colors.white;
    final ink = dark ? Palette.arcticWhite : Palette.carbonBlack;
    final primary = dark ? Palette.coldPlatinum : Palette.smokedGraphite;
    final scheme = ColorScheme.fromSeed(
      seedColor: Palette.precisionBlueGrey,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: dark ? Palette.carbonBlack : Colors.white,
      secondary: Palette.precisionBlueGrey,
      onSecondary: Colors.black,
      surface: surface,
      onSurface: ink,
      onSurfaceVariant: dark ? Palette.coldPlatinum : Palette.deepNobleOlive,
      outline: dark ? Palette.coldPlatinum : Palette.precisionBlueGrey,
      error: dark ? const Color(0xFFFFB4AB) : const Color(0xFF9C2727),
      onError: dark ? Palette.carbonBlack : Colors.white,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(PrecisionSpace.md),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: PrecisionTypography.apply(base.textTheme),
      scaffoldBackgroundColor: background,
      appBarTheme:
          AppBarTheme(backgroundColor: background, foregroundColor: ink),
      cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: scheme.outline.withValues(alpha: 0.35)))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(PrecisionSpace.md)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PrecisionSpace.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PrecisionSpace.md),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: const Size(
            PrecisionSpace.controlHeight, PrecisionSpace.controlHeight),
        shape: buttonShape,
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        minimumSize: const Size(
            PrecisionSpace.controlHeight, PrecisionSpace.controlHeight),
        side: BorderSide(color: scheme.outline),
        shape: buttonShape,
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: const Size(
            PrecisionSpace.controlHeight, PrecisionSpace.controlHeight),
        shape: buttonShape,
      )),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: surface),
      dividerColor: scheme.outline.withValues(alpha: 0.35),
    );
  }
}
