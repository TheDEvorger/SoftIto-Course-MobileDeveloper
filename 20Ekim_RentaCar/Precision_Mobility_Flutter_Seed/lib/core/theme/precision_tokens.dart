import 'package:flutter/material.dart';

/// Uygulama genelinde tutarlı boşluk (spacing) ve boyutlandırma sabitleri.
abstract final class PrecisionSpace {
  /// Ekstra küçük boşluk: 4.0 dp
  static const xs = 4.0;

  /// Küçük boşluk: 8.0 dp
  static const sm = 8.0;

  /// Orta boşluk: 12.0 dp
  static const md = 12.0;

  /// Büyük boşluk: 16.0 dp
  static const lg = 16.0;

  /// Ekstra büyük boşluk: 24.0 dp
  static const xl = 24.0;

  /// 2X büyük boşluk: 32.0 dp
  static const xxl = 32.0;

  /// Butonlar ve giriş alanları için standart kontrol yüksekliği: 48.0 dp
  static const controlHeight = 48.0;
}

/// Tipografi hiyerarşisi ve stil yapılandırması.
abstract final class PrecisionTypography {
  /// Taban metin temasına özel ağırlık ve satır yüksekliği kurallarını uygular.
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
