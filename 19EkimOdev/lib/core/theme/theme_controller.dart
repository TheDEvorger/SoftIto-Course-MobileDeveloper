import 'package:flutter/material.dart';

/// Uygulama temasını (Sistem / Aydınlık / Karanlık) yönetir.
///
/// `MaterialApp`, bu notifier'ı `ValueListenableBuilder` ile dinler;
/// böylece tema değişince tüm ekranlar anında güncellenir.
class ThemeController {
  ThemeController({ThemeMode initialMode = ThemeMode.system})
      : mode = ValueNotifier<ThemeMode>(initialMode);

  final ValueNotifier<ThemeMode> mode;

  void setMode(ThemeMode newMode) => mode.value = newMode;

  void dispose() => mode.dispose();
}

/// Tema seçeneklerinin Türkçe etiketleri ve ikonları.
extension ThemeModeLabel on ThemeMode {
  String get label => switch (this) {
        ThemeMode.system => 'Sistem',
        ThemeMode.light => 'Aydınlık',
        ThemeMode.dark => 'Karanlık',
      };

  IconData get icon => switch (this) {
        ThemeMode.system => Icons.brightness_auto_outlined,
        ThemeMode.light => Icons.light_mode_outlined,
        ThemeMode.dark => Icons.dark_mode_outlined,
      };
}
