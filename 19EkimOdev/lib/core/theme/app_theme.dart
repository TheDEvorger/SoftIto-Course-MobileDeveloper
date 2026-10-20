import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ColorScheme'de karşılığı olmayan VenaFlow'a özgü renkler.
///
/// Kullanım: `Theme.of(context).extension<VenaPalette>()!`
/// ya da kısaca `context.palette` (aşağıdaki extension).
@immutable
class VenaPalette extends ThemeExtension<VenaPalette> {
  const VenaPalette({
    required this.amber,
    required this.coral,
    required this.success,
    required this.secondaryText,
    required this.primaryDark,
    required this.heroStart,
    required this.heroEnd,
  });

  final Color amber;
  final Color coral;
  final Color success;
  final Color secondaryText;
  final Color primaryDark;
  final Color heroStart;
  final Color heroEnd;

  static const VenaPalette light = VenaPalette(
    amber: AppColors.lightAmber,
    coral: AppColors.lightCoral,
    success: AppColors.lightSuccess,
    secondaryText: AppColors.lightSecondaryText,
    primaryDark: AppColors.lightPrimaryDark,
    heroStart: AppColors.heroStartLight,
    heroEnd: AppColors.heroEndLight,
  );

  static const VenaPalette dark = VenaPalette(
    amber: AppColors.darkAmber,
    coral: AppColors.darkCoral,
    success: AppColors.darkSuccess,
    secondaryText: AppColors.darkSecondaryText,
    primaryDark: AppColors.darkPrimaryDark,
    heroStart: AppColors.heroStartDark,
    heroEnd: AppColors.heroEndDark,
  );

  @override
  VenaPalette copyWith({
    Color? amber,
    Color? coral,
    Color? success,
    Color? secondaryText,
    Color? primaryDark,
    Color? heroStart,
    Color? heroEnd,
  }) {
    return VenaPalette(
      amber: amber ?? this.amber,
      coral: coral ?? this.coral,
      success: success ?? this.success,
      secondaryText: secondaryText ?? this.secondaryText,
      primaryDark: primaryDark ?? this.primaryDark,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
    );
  }

  @override
  VenaPalette lerp(ThemeExtension<VenaPalette>? other, double t) {
    if (other is! VenaPalette) return this;
    return VenaPalette(
      amber: Color.lerp(amber, other.amber, t)!,
      coral: Color.lerp(coral, other.coral, t)!,
      success: Color.lerp(success, other.success, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      heroStart: Color.lerp(heroStart, other.heroStart, t)!,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t)!,
    );
  }
}

/// `context.palette` kısayolu.
extension VenaPaletteContext on BuildContext {
  VenaPalette get palette => Theme.of(this).extension<VenaPalette>()!;
}

/// Uygulamanın açık ve koyu Material 3 temaları.
abstract final class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        primary: AppColors.lightPrimary,
        primaryDark: AppColors.lightPrimaryDark,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        secondaryText: AppColors.lightSecondaryText,
        outline: AppColors.lightOutline,
        coral: AppColors.lightCoral,
        amber: AppColors.lightAmber,
        palette: VenaPalette.light,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        primaryDark: AppColors.darkPrimaryDark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        secondaryText: AppColors.darkSecondaryText,
        outline: AppColors.darkOutline,
        coral: AppColors.darkCoral,
        amber: AppColors.darkAmber,
        palette: VenaPalette.dark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color primaryDark,
    required Color background,
    required Color surface,
    required Color secondaryText,
    required Color outline,
    required Color coral,
    required Color amber,
    required VenaPalette palette,
  }) {
    final bool isDark = brightness == Brightness.dark;

    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: isDark ? AppColors.darkBackground : Colors.white,
      secondary: primaryDark,
      onSecondary: isDark ? AppColors.darkBackground : Colors.white,
      tertiary: amber,
      error: coral,
      surface: surface,
      onSurface: primaryDark,
      onSurfaceVariant: secondaryText,
      outline: outline,
      outlineVariant: outline,
      surfaceContainerLowest: surface,
      surfaceContainerLow: background,
    );

    final TextTheme baseText =
        (isDark ? Typography.material2021().white : Typography.material2021().black)
            .apply(bodyColor: primaryDark, displayColor: primaryDark);

    final TextTheme textTheme = baseText.copyWith(
      headlineMedium: baseText.headlineMedium
          ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineSmall: baseText.headlineSmall
          ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
      titleLarge: baseText.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: baseText.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: baseText.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: baseText.bodyMedium?.copyWith(height: 1.4),
      bodySmall: baseText.bodySmall?.copyWith(color: secondaryText),
      labelLarge: baseText.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );

    final RoundedRectangleBorder rounded16 =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
    final RoundedRectangleBorder rounded12 =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: background,
      extensions: <ThemeExtension<dynamic>>[palette],
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: primaryDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: outline),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: rounded12,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: rounded12,
          side: BorderSide(color: outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: rounded12,
          textStyle: textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: scheme.onPrimary,
        shape: rounded16,
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: coral),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: coral, width: 1.6),
        ),
        hintStyle: TextStyle(color: secondaryText),
        prefixIconColor: secondaryText,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primary.withValues(alpha: isDark ? 0.24 : 0.12),
        side: BorderSide(color: outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: textTheme.labelLarge?.copyWith(color: primaryDark),
        checkmarkColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: primary.withValues(alpha: isDark ? 0.24 : 0.14),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => textTheme.labelMedium?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? primary
                : secondaryText,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? primary
                : secondaryText,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: isDark ? 0.24 : 0.14),
        selectedIconTheme: IconThemeData(color: primary),
        unselectedIconTheme: IconThemeData(color: secondaryText),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(color: primary),
        unselectedLabelTextStyle:
            textTheme.labelLarge?.copyWith(color: secondaryText),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.darkPrimaryDark : primaryDark,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.darkBackground : Colors.white,
        ),
        actionTextColor: isDark ? AppColors.lightPrimary : AppColors.darkPrimary,
        shape: rounded12,
      ),
      dividerTheme: DividerThemeData(color: outline, space: 1, thickness: 1),
      listTileTheme: ListTileThemeData(
        shape: rounded12,
        iconColor: secondaryText,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor:
              primary.withValues(alpha: isDark ? 0.24 : 0.14),
          selectedForegroundColor: primary,
          side: BorderSide(color: outline),
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }
}
