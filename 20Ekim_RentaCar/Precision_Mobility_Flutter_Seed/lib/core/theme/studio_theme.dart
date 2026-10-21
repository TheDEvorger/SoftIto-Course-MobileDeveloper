import 'package:flutter/material.dart';
import 'studio_colors.dart';

abstract final class StudioTheme {
  static ThemeData light({String? fontFamily}) => _build(false, fontFamily);
  static ThemeData dark({String? fontFamily}) => _build(true, fontFamily);

  static ThemeData _build(bool dark, String? fontFamily) {
    final ink = dark ? StudioColors.pale : StudioColors.ink;
    final primary = dark ? const Color(0xFFB2DABC) : StudioColors.forest;
    final surface = dark ? StudioColors.nightSurface : Colors.white;
    final scheme = ColorScheme.fromSeed(
            seedColor: StudioColors.forest,
            brightness: dark ? Brightness.dark : Brightness.light)
        .copyWith(
            primary: primary,
            onPrimary: dark ? StudioColors.night : Colors.white,
            primaryContainer: dark ? StudioColors.forest : StudioColors.mint,
            onPrimaryContainer: dark ? StudioColors.pale : StudioColors.forest,
            secondary: dark ? const Color(0xFFACDDE1) : StudioColors.teal,
            onSecondary: dark ? StudioColors.night : Colors.white,
            secondaryContainer: dark ? StudioColors.night : StudioColors.ice,
            onSecondaryContainer: ink,
            surface: surface,
            onSurface: ink,
            surfaceContainerHighest:
                dark ? StudioColors.night : StudioColors.canvas,
            surfaceContainerLow: surface,
            surfaceContainer: surface,
            onSurfaceVariant:
                dark ? const Color(0xFFB7C8BB) : StudioColors.muted,
            outline: dark ? const Color(0xFF9BAC9E) : StudioColors.outline,
            outlineVariant:
                dark ? const Color(0xFF3B4C41) : const Color(0xFFDCE2DA),
            error: dark ? const Color(0xFFFFB4A4) : const Color(0xFFA13625));
    final base = ThemeData(
        useMaterial3: true, colorScheme: scheme, fontFamily: fontFamily);
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
    final button = ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(48, 50)),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 22, vertical: 14)),
        shape: WidgetStatePropertyAll(shape));
    return base.copyWith(
      scaffoldBackgroundColor: dark ? StudioColors.night : StudioColors.canvas,
      textTheme: base.textTheme.copyWith(
          displaySmall: base.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w600, letterSpacing: -1.8, height: 1.08),
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700, letterSpacing: -1, height: 1.16),
          titleLarge: base.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600, letterSpacing: -.5),
          bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.55),
          bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.5)),
      appBarTheme: AppBarTheme(
          backgroundColor: surface,
          foregroundColor: ink,
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 72),
      cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: scheme.outlineVariant))),
      filledButtonTheme: FilledButtonThemeData(style: button),
      outlinedButtonTheme: OutlinedButtonThemeData(style: button),
      textButtonTheme: TextButtonThemeData(style: button),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: dark ? StudioColors.night : StudioColors.canvas,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: scheme.outline)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: primary, width: 2))),
      chipTheme: ChipThemeData(
          backgroundColor: surface,
          selectedColor: scheme.primaryContainer,
          labelStyle: base.textTheme.labelLarge?.copyWith(color: ink),
          side: BorderSide(color: scheme.outlineVariant),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: surface,
          height: 74,
          elevation: 0,
          indicatorColor: scheme.primaryContainer),
      dividerColor: scheme.outlineVariant,
    );
  }
}
