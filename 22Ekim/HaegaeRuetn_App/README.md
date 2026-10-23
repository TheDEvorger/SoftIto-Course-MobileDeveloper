# ÖNEMLİ: Hâlâ eski v0.1.0 klasörünü çalıştırıyorsan
Terminal `HaegaeRuetn_v0.1.0 %` gösteriyorsa, bu paketin kodları değil eski kodlar çalışır.
Bu ZIP içindeki `HaegaeRuetn_App` klasörünü aç, terminali bu klasörde başlat.
Önce `flutter create --platforms=web .`, `flutter pub get`, sonra `flutter analyze` ve `flutter run -d chrome` çalıştır.
Eski klasöründe kalmak istiyorsan `scripts/fix_haega_mac.sh` yardımcı betiği iki kritik hatayı o klasörde düzeltir.

# HægæRûetn v0.2.1 (Mac uyum düzeltmeleri)

Mac üzerinde çalıştırma için önce **MAC_CALISTIR.md** dosyasını oku.
iOS için [IOS_CALISTIR.md](IOS_CALISTIR.md) yönergelerini kullan.

# HægæRûetn

HægæRûetn, Ałek’ryŧhæ evreninde geçen fantastik bir alışkanlık, ahit ve kişisel gelişim uygulamasıdır.

## Bu sürümde neler var?
- 5 ana ekran: Vazifeler, Ahitler, Meydan, Rehber, Kronik
- 6 çağ / 24 seviye ilerleme sistemi
- 24 rozet tanımı
- Vazife ekleme, düzenleme, tamamlama ve arşivleme
- Ahit oluşturma ve takip etme
- Yerel veri saklama
- Premium fantastik arayüz katmanı:
  - süslü düğmeler
  - bezemeli kartlar
  - konsept görsel başlıklar
  - yaldızlı alt menü
  - parşömen stili bildiriler

## Sınırlamalar
- Dart analizi ve 8 test yerelde doğrulandı; iOS çalıştırma ayrıntıları
  `docs/roadmap/progress.md` dosyasında tutulur.
- Gerçek topluluk ve uzak yapay zekâ bağlantısı bu sürümde prototip seviyesindedir.

## Sonraki adım
1. `flutter create .` veya eksik platform dosyalarını oluştur.
2. `flutter pub get`
3. `flutter analyze`
4. `flutter test`
5. `flutter run`

## Varlıklar
`assets/art/` klasöründeki görseller HægæRûetn için üretilmiş özgün konsept ekranlardır ve arayüzün sanat yönünü temsil eder.
