# TASK-014: Sunucusuz araç kiralama uygulaması

Kullanıcı, bağlantı hatası ve boş operatör ekranlarının ardından uygulamanın
sunucusuz çalışmasını açıkça istedi. Normal giriş bu talebe göre değiştirildi.

## Neden bozuluyordu?
Önceki ana uygulama localhost:8765 API oturumu bekliyordu. API kapalıysa bütün
özel ekranlar bağlantıya takılıyordu. Ayrıca eski API tarayıcı kaynağını varsayılan
localhost:8080 ile sınırlıyordu; kullanıcının ekranındaki farklı Flutter portu
bu bağımlılıkla uyumsuzdu. Müşteri akışına operatör anahtarı taşınmıştı.

## Teslim edilen
- main.dart → RentalApp. Normal veri katmanında HTTP/API bağımlılığı yok.
- Keşfet: dokuz hazır araç, arama, şehir/kategori/tarih filtresi ve fiyat sıralaması.
- Favoriler: cihazda saklanan seçimler; ilk kullanımda çalışan araç önerileri.
- Araç detayı: temsili görsel, özellikler, alış noktası, tarih ve tam sayı fiyat özeti.
- Rezervasyon: onay, yerel kayıt, referans, detay/kopyalama ve iptal/geçmiş.
- Profil: gerçek yerel plan/favori sayıları, kalıcı şehir/tema, yardım ve lisanslar.
- Depolama yazılmadan başarı gösterilmez. Bozuk kayıtlar sıfırlanmaz. Aynı oturumda
  yazmalar sıralanır, çakışmalar reddedilir, tekrar istekler tek kayıt üretir.
- Görseller, Roboto ve web renderer kaynakları pakette. Kompakt araç görseli araç
  sınıfına uygun hale getirildi; her görsel temsilî olarak işaretli.
- Web/macOS simgeleri düzenlenebilir SVG markasından üretildi.

Yeni kullanıcı için uydurma rezervasyon/favori yazılmadı. Boş kişisel listeler
araç önerileriyle doldurulur; envantere veya planlamaya erişimi engellemez.
Önceki API uygulaması main_api.dart, tarihsel simülasyon main_demo.dart altında
korundu. SQLite kayıtları ve operatör anahtarı parmak izi karşılaştırmasında aynı.

## Doğrulama
| Kontrol | Kanıt |
| --- | --- |
| flutter analyze | Hata/uyarı yok |
| flutter test --reporter expanded | 85 test geçti; 18 yeni yerel veri/arayüz testi dahil |
| Son görsel sonrası serverless_rental_app_test | 10 arayüz testi geçti |
| flutter build web --release --no-web-resources-cdn | Başarılı; renderer/font/görseller yerel |
| flutter build macos --release | Başarılı; bağımsız .app üretildi |
| macOS başlatma | API kapalıyken başlatıldı, Metal/Impeller çalıştı; süreç normal çıktı |
| check_serverless_browser.py | API/dış kaynaklar engelli gerçek Chrome akışı geçti |
| quality_gate.py / git diff --check | Geçti; yazılmış metin dosyaları en fazla 300 satır |

18 yeni test; boş başlangıçta veri uydurulmaması, tam sayı para, süre/çakışma,
eşzamanlı istek, tekrar anahtarı, iptal/geçmiş, depolama yazma/okuma hatası,
bozuk veriyi koruma, yeniden oluşturulan uygulamada kalıcılık ve tema kontrolünü
kapsar. Dar/geniş ekran: 320/1440, iki tema, yüzde 100/180 yazı.

Gerçek Chrome ayrı geçici profilde ve derlenmiş statik paketle çalıştı. API portu
8765 kapalıydı; tüm /api/ yolları ve dış HTTPS kaynakları ayrıca engellendi.
Favori → detay → onay → rezervasyon → sayfa yenileme → kayıt/tema geri yükleme →
bağlantısız iptal → yenileme zinciri geçti. Ağ kaydında sıfır API/dış kaynak isteği
var. 390/1440 genişliklerde iki temanın dört menüsü yakalandı ve seçilmiş
görüntüler incelendi: /tmp/precision-populated-serverless-*.png.

Tarayıcı sürücüsü Flutter erişilebilirlik düğmelerini etkinleştirir. İlk sürücü
denemelerinde metin alanı etiketi/grup kutusu ve arka plan sekmesi zamanlaması
yanlış seçiliyordu; denetim gerçek etkileşim rollerine ve etkin sekmeye düzeltildi.
Hiçbir işlev/kayıt doğrulama iddiası veya test assertion'ı devre dışı bırakılmadı.
Web derlemesinde önceki zararsız CupertinoIcons uyarısı, Xcode'da script-phase
uyarısı kaldı; iki derleme de başarılıdır.

## Çıktılar
- build/macos/Build/Products/Release/precision_mobility.app
- build/releases/Precision-Mobility-macOS.zip
- build/web (statik web paketi)
- Görsel, istem ve font kaynakları: docs/design/serverless-assets.md.

## Değişen dosyalar
- lib/main.dart, lib/main_api.dart, lib/app/rental_{app,shell}.dart.
- lib/features/rental/domain/{rental_vehicle,local_reservation}.dart.
- lib/features/rental/data/{rental_catalog,rental_snapshot,rental_storage,device_rental_repository}.dart.
- lib/features/rental/application/rental_controller.dart.
- lib/features/rental/presentation/{rental_catalog_screen,rental_car_card,rental_hero,rental_actions,
  local_booking_panel,rental_detail_screen,rental_plan_card,rental_plans_screen,rental_profile_screen}.dart.
- lib/core/theme/studio_theme.dart; pubspec.yaml/lock; generated plugin registration metadata.
- test/{device_rental_repository,serverless_rental_app}_test.dart;
  test/support/memory_rental_storage.dart.
- tools/{browser_driver,check_serverless_browser}.py; .github/workflows/quality.yml.
- assets/fonts/Roboto-{Regular,Medium,Bold}.ttf, Roboto_LICENSE.txt;
  assets/images/sample-compact.png; web/{index.html,manifest.json,favicon.svg,favicon.png},
  web/icons/*.png; macos/Runner/Assets.xcassets/AppIcon.appiconset/*.png.
- README.md; docs/architecture/boundaries.md; docs/product/{vision,business-rules,requirements-status}.md;
  docs/design/{palette,screen-map,serverless-assets}.md; docs/security/auth-and-data-boundaries.md;
  docs/verification/{FINAL,TASK-014}.md; tasks/INDEX.md ve TASK-014 görev dosyası.

## Sınırlar ve sonraki kabul
Bu, sunucusuz müşteri planlama uygulamasıdır. Koleksiyon temsili; gerçek tedarikçi
rezervasyonu, çok cihazlı canlı müsaitlik, ticari sözleşme, ödeme, sürücü doğrulama
ve teslim/açma entegrasyonu yoktur. Bu başarılar arayüzde taklit edilmez.
SharedPreferencesAsync kritik ticari kayıtlar için seçilmedi; yalnızca cihazdaki
yerel plan/tercihler içindir. [Paketin depolama sınırları](https://pub.dev/packages/shared_preferences).
Web için soğuk çevrimdışı yenileme/PWA kurulumu doğrulanmadı; ilk statik yükleme
sonrasındaki akışlar bağlantısız çalışır. Gerçek telefon, imza/mağaza yayını ve
ekran okuyucu sertifikasyonu yapılmadı. Sonraki kabul hedef telefonda kullanım
kontrolüdür; canlı kiralama entegrasyonları sağlayıcı seçimini bekler.
