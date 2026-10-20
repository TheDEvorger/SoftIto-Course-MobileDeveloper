import 'package:flutter/material.dart';

/// VenaFlow renk tokenları.
///
/// Bu sınıf yalnızca token TANIMLAR. Widget'lar renkleri doğrudan buradan
/// değil, `Theme.of(context)` üzerinden (ColorScheme / VenaPalette) okur.
abstract final class AppColors {
  // --- Açık tema ---
  static const Color lightPrimary = Color(0xFF087F8C);
  static const Color lightPrimaryDark = Color(0xFF143348);
  static const Color lightBackground = Color(0xFFF5F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSecondaryText = Color(0xFF627584);
  static const Color lightAmber = Color(0xFFE7A84B);
  static const Color lightCoral = Color(0xFFD96572);
  static const Color lightSuccess = Color(0xFF27836A);
  static const Color lightOutline = Color(0xFFDCE5EA);

  // --- Koyu tema ---
  static const Color darkPrimary = Color(0xFF5DD3D5);
  static const Color darkPrimaryDark = Color(0xFFDDEDF0);
  static const Color darkBackground = Color(0xFF0E1921);
  static const Color darkSurface = Color(0xFF172833);
  static const Color darkSecondaryText = Color(0xFFACBFCA);
  static const Color darkAmber = Color(0xFFF1BC6F);
  static const Color darkCoral = Color(0xFFFF8996);
  static const Color darkSuccess = Color(0xFF64D6AC);
  static const Color darkOutline = Color(0xFF26404F);

  // --- Üst panel (hero) gradient ---
  static const Color heroStartLight = Color(0xFF087F8C);
  static const Color heroEndLight = Color(0xFF143348);
  static const Color heroStartDark = Color(0xFF0C5560);
  static const Color heroEndDark = Color(0xFF112A3A);
}
