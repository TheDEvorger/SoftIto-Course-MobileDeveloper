import 'package:flutter/material.dart';

/// Dil Rotası / Atelier: mat mürekkep, keten kâğıt ve botanik vurgular.
/// Bilerek neon, parlak gradient ve standart AI dashboard renklerinden uzak.
abstract final class Palette {
  static const ink = Color(0xFF263C33);
  static const forest = Color(0xFF213B30);
  static const forestDeep = Color(0xFF192D27);
  static const moss = Color(0xFF53715D);
  static const sage = Color(0xFFE1E8D9);
  static const olive = Color(0xFFBFC992);
  static const terracotta = Color(0xFFB85D43);
  static const coralLight = Color(0xFFF2DFD4);
  static const mustard = Color(0xFFDAB779);
  static const parchment = Color(0xFFF6F2EA);
  static const paper = Color(0xFFFFFDF8);
  static const border = Color(0xFFDDD8CC);
  static const muted = Color(0xFF6D796F);
  static const fog = Color(0xFFEDE9DE);
  static const white = Color(0xFFFFFFFF);

  // Eski bileşenlerle ve örnek kodlarla uyumlu renk adları.
  static const canvas = parchment;
  static const emerald = moss;
  static const emeraldDark = forest;
  static const tealSoft = sage;
  static const indigo = terracotta;
  static const indigoSoft = coralLight;
  static const amber = mustard;
  static const amberSoft = Color(0xFFF8EED7);
}

ThemeData buildAppTheme() {
  final colors = ColorScheme.fromSeed(
    seedColor: Palette.forest,
    brightness: Brightness.light,
    primary: Palette.forest,
    onPrimary: Palette.paper,
    surface: Palette.paper,
    onSurface: Palette.ink,
    secondary: Palette.terracotta,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: Palette.parchment,
    dividerColor: Palette.border,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontFamily: 'serif', fontSize: 39, height: 1.12, fontWeight: FontWeight.w700, color: Palette.ink),
      headlineMedium: TextStyle(fontFamily: 'serif', fontSize: 32, height: 1.18, fontWeight: FontWeight.w700, color: Palette.ink),
      titleLarge: TextStyle(fontFamily: 'serif', fontSize: 24, fontWeight: FontWeight.w700, color: Palette.ink),
      titleMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Palette.ink),
      bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: Palette.ink),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: Palette.ink),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.parchment,
      foregroundColor: Palette.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Palette.paper,
      indicatorColor: Palette.sage,
      height: 74,
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
        fontWeight: states.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w500,
        fontSize: 11,
        color: Palette.forest,
      )),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.paper,
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
      hintStyle: const TextStyle(color: Color(0xFF9D9C91)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Palette.moss, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.terracotta,
        foregroundColor: Palette.white,
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.terracotta,
        foregroundColor: Palette.white,
        elevation: 0,
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Palette.forestDeep,
      contentTextStyle: const TextStyle(color: Palette.paper),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Palette.paper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
    ),
  );
}
