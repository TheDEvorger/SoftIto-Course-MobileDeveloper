# HægæRûetn — iOS

23 Ekim 2026: iPhone 18 Pro / iOS 27.0 simülatöründe derleme, yükleme ve
açılış doğrulandı. `flutter analyze` temiz; 8 test geçti.

Proje kökünde çalıştır:

```bash
flutter pub get
flutter devices
flutter run -d <iPhone-cihaz-kimliği>
```

Simülatör kapalıysa `xcrun simctl list devices available` ile kimliğini bul,
`xcrun simctl boot <kimlik>` ile başlat. Ardından aynı kimliği `flutter run -d`
komutunda kullan. İlk Xcode derlemesi Swift paketlerini ve SDK önbelleklerini
hazırladığı için sonraki derlemelerden uzun sürebilir.

`ios/Runner.xcworkspace` Xcode ile açılabilir. Fiziksel iPhone için Xcode'da
Runner hedefinin Signing & Capabilities bölümünden kendi geliştirme takımını
seç. Simülatör çalıştırması geliştirme takımı gerektirmez.

Doğrulama komutları:

```bash
dart format lib test
flutter analyze
flutter test
```

`test/mobile_layout_test.dart`, iki iPhone ekran boyutunda beş sekmeyi ve
Rehber'de klavye açıkken mesaj göndermeyi sınar. Yerel kayıt anahtarı
`haegaruuetn_realm_v1` olarak korunur.
