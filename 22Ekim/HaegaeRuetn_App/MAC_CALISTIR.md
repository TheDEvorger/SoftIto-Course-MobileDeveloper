# HægæRûetn v0.2.1 • macOS Çalıştırma

> Klasör adı ASCII olmalı: `HaegaeRuetn_App`. Uygulamanın görünen adı değişmez.

## İlk deneme (Chrome / en kolay)

Terminali bu klasörde aç ve komutları tek tek çalıştır:

```bash
flutter create --platforms=web .
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

## Mac masaüstü uygulaması

Xcode ve ilgili macOS geliştirme araçları kuruluysa:

```bash
flutter create --platforms=macos .
flutter pub get
flutter run -d macos
```

## Android emülatörü

`emulator-5554` sadece Android emülatörü gerçekten çalışıyorsa kullanılabilir.

```bash
flutter emulators
flutter devices
```

Android Studio > Device Manager'dan sanal bir Android cihazı başlat. Sonra `flutter devices` çıktısındaki ID ile `flutter run -d <ID>` komutunu kullan.

## Sürüm notları

- `CardThemeData` tür uyuşmazlığı düzeltildi.
- Rehber ekranındaki yanlış asset (`kronik` -> `chronicle`) düzeltildi.
- Rehber mesaj gönderme düğmesindeki dar alan taşması giderildi.
- `withOpacity` API uyarıları `withValues(alpha: ...)` kullanımına geçirildi.
- Kullanılmayan importlar temizlendi.
- Meydan önizlemesindeki gerçek veriye dayanmayan Erdem puanı kaldırıldı.

**Not:** Bu ortamda Flutter SDK olmadığı için paket burada derlenemedi; `flutter analyze` ve `flutter test` sonuçları yerelde çalıştırılmalıdır.
Gerçek topluluk ve gerçek yapay zekâ hizmeti henüz bağlı değildir.
