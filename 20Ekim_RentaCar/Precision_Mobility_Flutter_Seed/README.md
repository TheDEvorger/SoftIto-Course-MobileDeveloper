# Precision · Araç Kiralama

Sunucu gerektirmeyen Flutter uygulaması. Açılışta araç koleksiyonu hazırdır.
Keşfet, Favoriler, Planlarım ve Profil ekranları doğrudan çalışır.

## Çalıştırma

```sh
flutter pub get
flutter run
```

Web için sabit tarayıcı adresiyle:

```sh
flutter run -d web-server --web-hostname localhost --web-port 8080
```

Python, API adresi veya çalışma alanı anahtarı gerekmez. Web geliştirme aracı
statik Flutter dosyalarını sunar; kiralama verileri için bir backend çağrısı yoktur.
Mac için bağımsız uygulama `flutter build macos --release` ile üretilir:
`build/macos/Build/Products/Release/precision_mobility.app`.

## Kullanım

- Marka/model/enerji arayın; şehir, kategori, tarih ve fiyat sıralaması seçin.
- Araç detayında özellikleri, alış noktasını ve günlük ücreti inceleyin.
- Kalp düğmesiyle favori ekleyin veya kaldırın.
- 1–7 günlük tarih seçip fiyat özetini onaylayarak rezervasyonu kaydedin.
- Planlarım'da kaydı görüntüleyin, özetini kopyalayın veya iptal edin.
- Profil'de plan/favori kısayollarını, şehir ve açık/koyu/sistem tercihlerini kullanın.

Yeni kullanıcıya uydurma rezervasyon veya favori eklenmez. İlk plan öncesinde
Planlarım'da araç önerileri ve çalışan planlama düğmeleri bulunur.

## Cihazdaki veriler

Favoriler, yerel rezervasyonlar ve tercihler `precision.renter.v1` anahtarıyla
cihazın uygulama depolamasında tutulur. Web kayıtları tarayıcı ve adrese özeldir;
yeni port/tarayıcı farklı depolama kullanır. Tarayıcı verilerini temizlemek kayıtları
kaldırır. Uygulama depolama hatasında başarı göstermez veya bozuk veriyi sıfırlamaz.

Yazmalar tek uygulama oturumunda sıralanır; aynı araç/tarih çakışması ve tekrar
istekleri kontrol edilir. Çok cihazlı canlı envanter kilidi veya tedarikçi rezervasyonu
iddia edilmez. Gerçek ticari veriler için bu cihaz tercih deposu kullanılmamalıdır.

Araç/donanım/fiyat/alış noktaları örnek koleksiyondur. Görseller temsili ve
etiketlidir. Kaydedilen plan gerçek tedarikçiye iletilmez; ödeme, kimlik doğrulama,
araç tahsisi veya teslim onayı yapılmaz. Kart/kimlik/GPS toplanmaz.

## Paket ve eski çalışma alanı

Görseller ve Roboto yazı tipleri uygulama paketindedir. Web dağıtımını dış kaynak
bağımlılığı olmadan üretmek için `flutter build web --release --no-web-resources-cdn`
kullanın. İlk statik dosya yüklemesinden sonra ürün akışları bağlantısız çalışır;
web için soğuk çevrimdışı sayfa yenileme/PWA kurulumu iddia edilmez.

Önceki SQLite dosyaları ve operatör anahtarı korunmuştur. İsteğe bağlı eski API
çalışma alanı `lib/main_api.dart`, tarihsel simülasyon `lib/main_demo.dart` girişindedir.
Normal `lib/main.dart` bu ekranlara veya sunucu koduna bağımlı değildir.

## Kontroller

```sh
flutter analyze
flutter test
flutter build web --release --no-web-resources-cdn
python3 tools/check_serverless_browser.py
python3 tools/quality_gate.py
flutter build macos --release
```

Tarayıcı kontrolü ayrı geçici profille çalışır; API ve dış ağ isteklerini engeller.
Favori → rezervasyon → yenileme → tema → çevrimdışı iptal → yenileme akışını doğrular.
`PRECISION_CHROME` ile Chromium yolu belirtilebilir. Kendi geçici statik dosya
sunucusunu başlatıp kapatır; kullanıcı verilerine veya SQLite'a dokunmaz.

Gereksinim durumu: [requirements-status](docs/product/requirements-status.md).
Değişen dosyalar ve kanıtlar: [TASK-014](docs/verification/TASK-014.md).
Roboto lisansı assets/fonts/Roboto_LICENSE.txt içinde; önceki görsel istemleri
[collection-assets](docs/design/collection-assets.md) dosyasında kayıtlıdır.
