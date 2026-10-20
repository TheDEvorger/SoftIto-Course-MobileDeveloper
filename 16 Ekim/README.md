# Dil Rotası · Kelime Atölyesi 2.0

Üç ekranlı, beş platform hedefli Flutter kelime öğrenme uygulaması. Warm editorial / botanik çalışma defteri tasarımı. Google Fonts veya ağ üzerinden yüklenen görsel yoktur. Türkçe arayüzle Almanca ve İngilizce kelime çalışılır.

## Ekranlar

1. **Başlangıç:** Günlük hedef ve tekrar durumu, üç istatistik, iki dilin ilerlemesi, günün kelimesi.
2. **Kelime Defterim:** Tam metin arama, dil ve öğrenme aşaması filtreleri, tekrarlama, öğrenildi işaretleme, silme.
3. **Kelime Ekle:** Dil seçimi, iki zorunlu alan, örnek cümle, anlık önizleme, form doğrulaması.

## Özellikler

- Flutter + Dart, Material 3. Tasarım paleti `lib/core/palette.dart` içinde.
- Windows, Web, Android, iOS ve macOS proje klasörleri mevcut.
- Telefonlarda alt navigasyon, geniş ekranlarda yan menü.
- Ortak state `MainShell` içinde `setState`, ekranlar callback ile konuşur.
- Veriler `shared_preferences` ile *yalnızca kullanılan cihazda/tarayıcıda* tutulur. Otomatik bulut eşitleme yoktur.
- Önceki Dil Rotası v1 sürümüyle aynı `dil_rotasi_words_v1` ve `dil_rotasi_daily_goal_v1` kayıt anahtarları kullanılır. **Aynı uygulama kimliği ve tarayıcı origin'i altında** çalıştırılıyorsa mevcut veriler okunabilir. Yeni klasör, farklı tarayıcı, farklı uygulama kimliği veya temiz kurulum aynı verileri garanti etmez.
- İlk kurulumda 12 örnek kelime vardır. Bunlar kullanıcı eklediği kelimeler gibi düzenlenebilir aşamalara sahiptir ve silinebilir.

## VS Code'da çalıştırma

ZIP'i çıkar; **içindeki DilRotasi klasörünü** VS Code'da aç. `pubspec.yaml` dosyası açtığın klasörün kökünde olmalı.

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Windows masaüstü uygulaması için Visual Studio C++ desktop workload gerekebilir:

```powershell
flutter run -d windows
```

Android için Android SDK + açık emülatör veya USB cihaz gereklidir:

```powershell
flutter devices
flutter run -d <CIHAZ_ID>
```

iOS ve macOS derlemesi için macOS ve Xcode gereklidir. Windows bilgisayarda bu platformları derleyemezsin; kaynak klasörlerinin ZIP'te yer alması onların gerçek cihazda test edildiği anlamına gelmez.

Flutter SDK bu üretim ortamında kurulmadığı için gerçek `flutter analyze`, `flutter test`, `flutter run` yürütülemedi. Komutları kendi bilgisayarında çalıştırıp varsa çıktıyı paylaş.

## Hoca için State özeti

`lib/main.dart` içindeki `MainShell` `StatefulWidget` bütün ekranların ortak kelime listesini, seçili ekranı ve günlük hedefi tutar. `_addWord`, `_reviewWord`, `_deleteWord`, `_changeStage`, `_setGoal` işlemleri `setState` ile arayüzü günceller. Veriler `WordRepository` arayüzü üzerinden saklanır; kayıtlar sıralı kuyruğa alınır. `DictionaryScreen` kendi filtre state'ine, `AddWordScreen` form state'ine sahiptir; `DashboardScreen` sadece gelen veriyi gösterir.

## Güvenlik / dağıtım notu

Bu sürüm cihazda kayıt tutan ders/portföy projesidir. Kullanıcı hesabı, izleme SDK'sı, reklam, dış API bağlantısı ve gizli anahtar içermez. `shared_preferences` kritik/gizli veri için şifreli depo değildir. Android `applicationId` ve iOS bundle identifier gibi alanlar örnek kimliklerdir; mağazaya yayınlama, imzalama ve cihaz testleri daha sonra yapılmalıdır. Android release build yapılandırmasında test kolaylığı için debug signing kullanılmıştır; **yayınlamadan önce release signing yapılandırılmalıdır**.

## Dosya ağacı

```text
DilRotasi/
├── android/  ios/  macos/  web/  windows/
├── lib/
│   ├── core/palette.dart
│   ├── data/word_repository.dart
│   ├── models/vocabulary_word.dart
│   ├── screens/dashboard_screen.dart
│   ├── screens/dictionary_screen.dart
│   ├── screens/add_word_screen.dart
│   ├── widgets/ui_parts.dart
│   └── main.dart
├── test/widget_test.dart
├── pubspec.yaml
└── README.md
```
