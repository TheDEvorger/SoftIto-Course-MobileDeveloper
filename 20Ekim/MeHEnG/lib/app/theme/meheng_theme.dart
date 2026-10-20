import 'package:flutter/material.dart';

abstract final class MehengColors {
  static const forest = Color(0xFF193E38);
  static const canvas = Color(0xFFF5F2EB);
  static const copper = Color(0xFFD57C52);
  static const sage = Color(0xFF9EB8A9);
  static const ink = Color(0xFF263331);

  // Dark Mode Tokens
  static const darkCanvas = Color(0xFF121B19);
  static const darkSurface = Color(0xFF1A2825);
  static const darkSurfaceVariant = Color(0xFF233632);
  static const darkInk = Color(0xFFE5EDE9);
  static const darkCopper = Color(0xFFE28B62);
  static const darkSage = Color(0xFFB0C9BC);
}

abstract final class MehengSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double maxContentWidth = 1120.0;
}

abstract final class MehengRadii {
  static const double sm = 10.0;
  static const double md = 16.0;
  static const double lg = 24.0;
}

abstract final class MehengTheme {
  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: MehengColors.forest,
      onPrimary: Colors.white,
      secondary: MehengColors.copper,
      onSecondary: Colors.white,
      surface: MehengColors.canvas,
      onSurface: MehengColors.ink,
      surfaceContainerHighest: Color(0xFFE8E4DA),
    ),
    scaffoldBackgroundColor: MehengColors.canvas,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MehengRadii.sm),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: MehengColors.canvas,
      foregroundColor: MehengColors.ink,
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MehengRadii.md),
        side: const BorderSide(color: Color(0xFFE4DFD5)),
      ),
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: MehengColors.sage,
      onPrimary: MehengColors.darkCanvas,
      secondary: MehengColors.darkCopper,
      onSecondary: MehengColors.darkCanvas,
      surface: MehengColors.darkSurface,
      onSurface: MehengColors.darkInk,
      surfaceContainerHighest: MehengColors.darkSurfaceVariant,
    ),
    scaffoldBackgroundColor: MehengColors.darkCanvas,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MehengColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MehengRadii.sm),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: MehengColors.darkCanvas,
      foregroundColor: MehengColors.darkInk,
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: MehengColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MehengRadii.md),
        side: const BorderSide(color: MehengColors.darkSurfaceVariant),
      ),
    ),
  );
}
