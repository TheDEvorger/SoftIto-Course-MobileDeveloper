import 'package:flutter/material.dart';

import 'garden_palette.dart';

abstract final class GardenTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: GardenPalette.mossEmerald,
      brightness: Brightness.light,
    ).copyWith(
      primary: GardenPalette.mossEmerald,
      secondary: GardenPalette.streamTurquoise,
      tertiary: GardenPalette.harvestGold,
      surface: GardenPalette.sandyPorcelain,
      onSurface: GardenPalette.inkPlum,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: GardenPalette.sproutMist,
      appBarTheme: const AppBarTheme(
        backgroundColor: GardenPalette.sproutMist,
        foregroundColor: GardenPalette.inkPlum,
      ),
      cardColor: GardenPalette.sandyPorcelain,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: GardenPalette.lavenderGlow,
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFFA4D49B),
      secondary: GardenPalette.streamTurquoise,
      tertiary: const Color(0xFFE4BC63),
      surface: GardenPalette.nightCard,
      onSurface: const Color(0xFFF8F2E8),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: GardenPalette.nightBackdrop,
      appBarTheme: const AppBarTheme(
        backgroundColor: GardenPalette.nightBackdrop,
        foregroundColor: Color(0xFFF8F2E8),
      ),
      cardColor: GardenPalette.nightCard,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
