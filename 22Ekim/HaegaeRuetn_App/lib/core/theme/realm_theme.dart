import 'package:flutter/material.dart';

class RealmPalette {
  static const parchment = Color(0xFFF8F1DD);
  static const parchmentDeep = Color(0xFFECDDBB);
  static const ink = Color(0xFF253036);
  static const gold = Color(0xFFCA9E42);
  static const goldSoft = Color(0xFFF2D389);
  static const navy = Color(0xFF233D73);
  static const forest = Color(0xFF355C4B);
  static const rose = Color(0xFFA56574);
}

ThemeData buildRealmTheme() {
  final scheme = ColorScheme.fromSeed(
          seedColor: RealmPalette.navy, brightness: Brightness.light)
      .copyWith(
    primary: RealmPalette.navy,
    secondary: RealmPalette.gold,
    surface: const Color(0xFFF7F3EA),
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF7F3EA),
    colorScheme: scheme,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.3,
          color: RealmPalette.ink),
      headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: RealmPalette.ink),
      headlineSmall: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w800, color: RealmPalette.ink),
      titleLarge: TextStyle(
          fontSize: 19, fontWeight: FontWeight.w800, color: RealmPalette.ink),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: RealmPalette.ink),
      bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: RealmPalette.ink),
      bodyMedium:
          TextStyle(fontSize: 14, height: 1.42, color: RealmPalette.ink),
      bodySmall:
          TextStyle(fontSize: 12, height: 1.32, color: Color(0xFF635C4F)),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side:
            BorderSide(color: const Color(0xFFDDD1B6).withValues(alpha: 0.85)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Color(0xFF908774)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFD9CEB8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFD9CEB8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: RealmPalette.gold, width: 1.4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFFD7CCB6)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelStyle:
          const TextStyle(fontWeight: FontWeight.w700, color: RealmPalette.ink),
      selectedColor: RealmPalette.parchmentDeep,
    ),
    dividerTheme:
        const DividerThemeData(color: Color(0xFFE1D8C6), thickness: 1),
  );
}
