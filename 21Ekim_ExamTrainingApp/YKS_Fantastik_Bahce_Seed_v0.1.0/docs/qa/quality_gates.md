# Kalite kapıları

## Her görev

- `dart format lib test` / format kontrolü
- `flutter pub get`
- `flutter analyze`: hata ve kritik lint sıfır
- `flutter test`: geçen testler ve kapsamla ilgili yeni test
- Kırık asset dosyası, desteklenmeyen link, kullanılmayan import yok
- TASK belgelerinde kabul kriterleri gerçek olarak sağlandı

## Ekranlarda

- 360px telefon, büyük telefon, tablet (geniş ekran), yatay döndürme
- Light + dark tema; min. 200% text scaling'de kritik işlev kaybolmamalı
- Ekran okuyucu: anlamlı label, durumlar salt renge bağlı değil
- Türkçe metin ve klavye; Türkçe karakterler
- Örnek veriler gerçek veri sanılmamalı
- Başlat/Pause/Reset, kaydet/geri al, filtre gibi eylemler gerçekten çalışmalı
- Assetler release paketinde ve çevrimdışı erişilebilir

## Önemli iş mantığı testleri

- TYT doğru 30 yanlış 8 -> net 28; 0/0 -> 0.
- Yanlış/boş soru üst sınırını aşan değerler reddedilir.
- Deneme silme/düzenleme analiz verilerini senkronize eder.
- Aynı gün kaydedilen farklı denemeler kronolojik doğru sıralanır.
- Pomodoro duraklatma, arka plan dönüşü ve tamamlanma mantığı sınanır.
- Sınav tarihi ayarlanmadıysa uydurma geri sayım yok.

## Release

- `flutter build apk --release` Android araç zinciri varsa
- `flutter build web --release` Web hedef varsa
- `flutter build windows --release` yalnız Windows makinede
- iOS ancak macOS + Xcode üzerinde
- Dosya/arayüz/sessiz veri toplama güvenlik kontrolleri ve gerçek cihaz denemesi
- Başarısız araç zincirine sahte olumlu sonuç yazma
