#Fitness su takip uygulaması
Bu doküman flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılım geliştiriciler için  bağlayıcı bir kılavuzdur. Projede üretilen bir kod satırı burdaki kurallara UYMAK ZORUNDADIR.


# Fitness Su takip Uygulaması

## 1.Proje Özeti ve Teknolojiler
- **Uygulama adı:** Susadım (akıllı su egzersiz ve kalori takibi uygulaması)

- **Hedef Platformlar:** İos ve android öncelikli ardından web ve masaüstü platformları.
- **Flutter SDK:** 3.29.0

- **Dart SDK:** 3.0.0
- **Tasarım dili:** Material 3, **Aydınlık + Karanlık tema desteği** (varsayılan: `ThemeMode.system`).
  - **Karanlık tema:** gece spor salonu paleti (dark obsidian & neon).
  - **Aydınlık tema:** gündüz salonu paleti (frost white & deep water).
  - Detaylar için bkz. **6. Tema Yönetimi**.

---

## 2.Mimari Yapı : Özellik bazlı
kodlar kesinlikle tek bir yerde toplanmayacaktır.Her modül kendi feature klasöründe kodlanacaktır.
Klasör isimleri `.agents/skills/SKILL.md` ile birebir aynıdır.

```text
lib/
  core/
    extensions/
    constants/
      app_colors.dart          # Aydınlık + karanlık renk paletleri
    theme/
      app_theme.dart           # AppTheme.light / AppTheme.dark
      theme_controller.dart    # ValueNotifier<ThemeMode>
      theme_toggle_button.dart # AppBar mod değiştirme butonu
  features/
    water_tracker/
      controllers/
      models/
      view/
      widgets/
    workout/
      controllers/
      models/
      view/
      widgets/
  main.dart                    # sadece uygulama başlatma ve tema bağlama
test/
  features/<feature_name>/     # her feature için birim + widget testleri
```

## 3.Kırmızı Çizgiler (Kesinlikle Uyulması Gerekenler)
1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır
Büyük build metodları yasaktır 40 satırı geçen build metotları özel widgetlara yazılacaktır.

3 - **Yasaklı Paketler:**
Projeye onay almadan harici ağır paketler EKLENMEMELİDİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

4 - **Tema Kuralları:**
Widget içinde `Colors.xxx`, `Color(0x...)` veya elle `TextStyle(color: ...)` YAZILMAYACAKTIR.
Renkler `Theme.of(context).colorScheme`, yazılar `Theme.of(context).textTheme` üzerinden okunur.
Her yeni ekran hem aydınlık hem karanlık modda kontrol edilmelidir.


## 4.Geliştime analiz ve test komutları
Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik kod analizi(0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```

* ** Birim ve widget testleri:
```bash
flutter test
```

* **Projeyi çalıştırma:
```bash
flutter run
```


## 5 Ajanın çıktı ve yanıt verme standartları

**Açıklama:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sonra basma; hedef satırları ve diff yapısını göster.
**Dosya yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
**Doğrulama:** Kod yazdıktan sonra kullanıcıyı "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.


## 6. Tema Yönetimi (Karanlık / Aydınlık Mod)

**Kurallar:**
- Tema durumu `ValueNotifier<ThemeMode>` ile yönetilir (Provider/Bloc vb. paket YOK).
- `main.dart` yalnızca `ValueListenableBuilder<ThemeMode>` ile `MaterialApp`'i sarar.
- Varsayılan mod `ThemeMode.system`'dir; kullanıcı AppBar'daki butonla değiştirir.
- Kalıcılık (uygulama kapanınca hatırlama) `shared_preferences` gerektirir; **onay alınmadan eklenmez**, o zamana kadar mod bellekte tutulur.

**`lib/core/constants/app_colors.dart`**
```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Karanlık tema — gece spor salonu (dark obsidian & neon)
  static const Color obsidian = Color(0xFF0B0D12);
  static const Color obsidianSurface = Color(0xFF151922);
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonLime = Color(0xFFB6FF3B);
  static const Color darkOnSurface = Color(0xFFE6EAF2);

  // Aydınlık tema — gündüz salonu (frost white & deep water)
  static const Color frost = Color(0xFFF5F8FC);
  static const Color frostSurface = Color(0xFFFFFFFF);
  static const Color deepWater = Color(0xFF006C80);
  static const Color freshLime = Color(0xFF4C7A00);
  static const Color lightOnSurface = Color(0xFF12161F);

  // Ortak
  static const Color error = Color(0xFFFF4D6D);
}
```

**`lib/core/theme/app_theme.dart`**
```dart
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

abstract final class AppTheme {
  static final ThemeData dark = _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.neonCyan,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.neonCyan,
      secondary: AppColors.neonLime,
      surface: AppColors.obsidianSurface,
      onSurface: AppColors.darkOnSurface,
      error: AppColors.error,
    ),
    AppColors.obsidian,
  );

  static final ThemeData light = _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.deepWater,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.deepWater,
      secondary: AppColors.freshLime,
      surface: AppColors.frostSurface,
      onSurface: AppColors.lightOnSurface,
      error: AppColors.error,
    ),
    AppColors.frost,
  );

  static ThemeData _build(ColorScheme scheme, Color background) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: scheme.onSurface,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
```

**`lib/core/theme/theme_controller.dart`**
```dart
import 'package:flutter/material.dart';

/// Uygulama ömrü boyunca yaşayan tekil tema durumu.
class ThemeController {
  ThemeController._();

  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  void toggle({required bool isDark}) {
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  void setMode(ThemeMode mode) => themeMode.value = mode;
}
```

**`lib/core/theme/theme_toggle_button.dart`**
```dart
import 'package:flutter/material.dart';

import 'theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? 'Aydınlık moda geç' : 'Karanlık moda geç',
      icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
      onPressed: () => ThemeController.instance.toggle(isDark: isDark),
    );
  }
}
```

**`lib/main.dart`**
```dart
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/water_tracker/view/water_tracker_view.dart';

void main() => runApp(const SusadimApp());

class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'Susadım',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: const WaterTrackerView(),
      ),
    );
  }
}
```