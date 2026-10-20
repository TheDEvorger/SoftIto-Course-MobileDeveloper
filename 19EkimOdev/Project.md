# VenaFlow | Kan Alma ve Numune Takip Uygulaması

> **Antigravity için bağlayıcı proje rehberi.** Bu belge, eski “Susadım” fitness/su takip konusunun yerini **tamamen** alır. Eski konuya ait ekran, model, etiket, veri ve tasarım korunmayacaktır.
>
> **Önemli:** Bu paket çalışan Flutter kaynak kodu değildir; Antigravity'nin proje oluştururken izleyeceği teknik ve ürün taslağıdır.

## 1. Amaç ve sınırlar

**Uygulama adı (çalışma adı):** VenaFlow  
**Alt başlık:** Kan Alma & Numune Takibi  
**Kullanıcı:** Poliklinik / kan alma birimi personeli (eğitim amaçlı demo)  
**MVP:** Hasta kabulü, günlük sıra listesi, hasta çağırma, kan alma işlem durumu, numune takibi, özet paneli.

Uygulama *tıbbi karar desteği* sağlamaz. Kan alma tekniği, hasta uygunluk değerlendirmesi, test sonuçlarının yorumlanması veya tedavi tavsiyesi vermez. **Gerçek klinikte kullanım için tasarlanmamıştır.** Bütün kişi, randevu ve numune kayıtları *kurgusal demo verisi* olacaktır.

## 2. Hocanın kullandığı teknoloji ve öğrenme sınırı

- **Flutter + Dart** ile tek proje, Android/iOS öncelikli; mümkün olduğunda Chrome/web ve masaüstünde responsive görüntü.
- **Material 3** ve Flutter yerleşik widget'ları.
- **State:** `ValueNotifier`, `ValueListenableBuilder`, `ChangeNotifier` yalnızca gerektiğinde. Ekran genelinde ağır `setState` yok.
- **Navigation:** önce `Navigator` / `MaterialPageRoute`; ek paket yok.
- **Mimari:** feature-first modüler yapı; `model`, `controller`, `view`, `widgets` ayrımı.
- **Veri kaynağı:** ilk sürümde yalnızca *bellekte tutulan sahte veriler*; backend, gerçek hasta verisi, bulut, giriş sistemi, veritabanı ve paket kurulumu yok.
- **Harici paketler:** kullanıcının açık onayı olmadan yükleme. UI'da dış ağdan resim/icon indirme; `Icons` ve yerel Flutter özelliklerini tercih et.
- **Sürüm uyumu:** Kaynak taslakta `Flutter 3.15.1` ve `Dart 3.6.0` birlikte yazılıdır. Bunlar eşleşen bir Flutter/Dart sürüm çifti değildir. Başlangıçta `flutter --version`, `dart --version` ve `flutter doctor` kontrol edilerek mevcut *uyumlu* kurulum kullanılmalı; otomatik major yükseltme yapılmamalı. Kullanılan sürüm README'de kaydedilmeli.

## 3. Tasarım ilkesi: modern sağlık operasyon paneli

Hedef his: **sakin, net, profesyonel, güven veren ve premium**. Ne klişe kırmızı hastane tasarımı ne de aşırı neon oyun arayüzü. Kartlar dengeli, hiyerarşi güçlü, metinler okunaklı, boşluklar bilinçli olmalı.

### Renk tokenları

| Rol | Açık tema | Koyu tema | Kullanım |
|---|---|---|---|
| Brand primary | `#087F8C` | `#5DD3D5` | Ana aksiyon, aktif sekme, grafik |
| Primary dark | `#143348` | `#DDEDF0` | Başlık, öne çıkan metin |
| Background | `#F5F8FA` | `#0E1921` | Sayfa zemini |
| Surface | `#FFFFFF` | `#172833` | Kartlar, dialoglar |
| Secondary text | `#627584` | `#ACBFCA` | Açıklamalar |
| Accent amber | `#E7A84B` | `#F1BC6F` | Bekleyen işlem, dikkat |
| Accent coral | `#D96572` | `#FF8996` | İptal / kritik uyarı |
| Success | `#27836A` | `#64D6AC` | Tamamlanan akış |

> **Renk tek başına durum belirtmez:** ikon ve okunabilir durum etiketi zorunludur. Renkler yalnızca `ColorScheme`/tema tokenlarından kullanılmalı. `ThemeMode.system`, `.light`, `.dark` seçimi uygulanmalı.

- Türkçe UI, tutarlı kısa başlıklar, hafif yuvarlatılmış (12-20 px) kartlar, 8 px spacing sistemi.
- Vurgu tasarımı: üst panelde zarif gradient/renk bloğu, görsel ikonlar, doğru yerde micro-interaction; aşırı gölgeler ve karmaşa yasak.
- Mobil: alt navigation; geniş ekranda navigation rail veya uygun responsive düzen.
- Büyük dokunma hedefleri (~48 px), desteklenen sistem metin ölçekleri, kontrast, klavye ve ekran okuyucu etiketleri.
- Boş durum, yüklenme/senkron durumu **(gerçek ağ yoksa sahte yükleniyor animasyonu gösterme)**, hata ve form doğrulama durumları tasarlanmalı.

## 4. Ekranlar (MVP)

### A. Gösterge Paneli / Dashboard
- Günlük özet: **Sırada bekleyen**, **İşlemde**, **Numunesi alınan**, **Teslim edilen** sayıları; sayılar aynı veriden hesaplanmalı.
- “Sıradaki hastayı çağır” hızlı aksiyonu.
- Günlük iş akışı ve son hareketler, gerçek çalışan mock state'inden türemeli.

### B. Hasta Kabul / Yeni Kayıt
- Kurgusal hasta adı, demo hasta kodu, hizmet/birim bilgisi, randevu zamanı (opsiyonel), not (opsiyonel).
- Boş alan doğrulaması, tekrarsız işlem/sıra numarası üretimi, başarılı kayıttan listeye dönüş.
- **TC kimlik no, adres, gerçek telefon, tahlil sonucu veya hassas sağlık bilgisi isteme.**

### C. Kan Alma Sırası
- Aranabilir, filtrelenebilir günlük hasta listesi. Hasta adı, kodu, sıra numarası ve işlem durumu.
- Filtre: Tümü / Bekliyor / Çağrıldı / İşlemde / Numune Alındı / Tamamlandı.
- Her satırda doğru ve görünür birincil aksiyon; yanlış tıklamalarda undo/geri alma veya onay kullan.

### D. İşlem Detayı / Durum Akışı
- Adım akışı: `bekliyor -> cagrildi -> islemde -> numune_alindi -> teslim_edildi`.
- İptal ayrı terminal durum; kurallara aykırı atlamaları engelle. Klinik doğrulama/kimlik tespiti **uygulama dışındaki gerçek prosedürdür**; demo, bu güvenlik işlemlerini yapılmış sayamaz.
- Durum değişince tüm ekranlar ve özetler aynı anda güncellenmeli.

### E. Numune Takibi
- Kurgusal numune kodu, ilişkili işlem kodu, oluşturulma tarihi/saati, durum etiketi.
- Numune kodunu kopyala, detay aç, duruma göre filtrele.
- **Gerçek barkod/QR tarama, LIS/HIS bağlantısı veya etiket basımı bu sürümde yok.** Geleceğe dönük eklenti noktası olabilir ama çalışan özellikmiş gibi gösterme.

### F. Ayarlar
- Sistem / Aydınlık / Karanlık tema seçimi.
- “Demoyu sıfırla” işlemi ve onay diyaloğu.
- Demo veri ve klinik kullanım dışı açıklaması.

## 5. Basit veri modeli ve durum yönetimi

- `DemoPatient { id, displayName, department }`
- `CollectionVisit { id, patientId, queueNumber, createdAt, status, note? }`
- `DemoSpecimen { id, visitId, createdAt, status }`
- `CollectionStatus` enum, görünür TR etiketleri ayrı extension/helper.
- Modeller `@immutable` / `final` alanlar, `copyWith` örüntüsü; ihtiyaç yoksa `fromJson/toJson` zorunlu değil, kalıcılık geldiğinde ekle.
- Tek bir `DemoClinicStore` uygulama kapsamındaki kurgusal veriyi yönetir; `ValueNotifier` değişimleri atomik ve tutarlı olmalı. Her view içinde ayrı seed liste yaratılmamalı.
- Sorumluluk ayrımı: View sadece UI, Controller kullanıcı niyetini işler, Store/model veri bütünlüğünü korur.
- Controller/notifier yaşam döngüsünde `dispose()` doğru yerde çağrılır; `build` içinde controller yaratılmaz.

### Dizin şeması

```text
lib/
  main.dart
  app.dart
  core/
    theme/
      app_colors.dart
      app_theme.dart
      theme_controller.dart
    widgets/
      app_shell.dart
      status_chip.dart
      empty_state.dart
    utils/
      formatters.dart
  data/
    demo/
      demo_seed.dart
      demo_clinic_store.dart
  features/
    dashboard/{controllers,models,views,widgets}/
    patient_intake/{controllers,models,views,widgets}/
    queue_management/{controllers,models,views,widgets}/
    sample_tracking/{controllers,models,views,widgets}/
    settings/{controllers,models,views,widgets}/
test/
  core/
  features/
```

`{controllers,models,views,widgets}` bir gösterimdir; gerçek dizinlerde ayrı ayrı klasör olarak aç. Kullanılmayan boş sınıflar ve anlamsız soyutlamalar üretme.

## 6. UX kabul kriterleri (göstermelik uygulama olmasın)

1. Yeni kurgusal hasta kaydı → benzersiz sıraya eklenir.
2. Hasta çağır → ilgili kaydın durumu değişir ve dashboard otomatik yenilenir.
3. Sıradan `işlemde` → `numune_alindi` → `teslim_edildi` akışı çalışır; geçersiz durum geçişi reddedilir.
4. Numune ekranı ilgili işlemi/numuneyi tutarlı gösterir.
5. Arama/filtreler gerçekten çalışır; boş liste durumunda uygun bilgi verir.
6. Tema değiştirilince tüm ekranlar güncellenir; sistem modu desteklenir.
7. Mobil dar ekranlarda overflow yok; tablet/web geniş ekranda düzgün yerleşim.
8. Testler: durum geçişleri, yeni kayıt ve benzersiz numara, filtre, tema/dash özet en azından temel widget/unit testleri.
9. Demo sıfırlanınca ilk kurgusal durum geri gelir.
10. Uygulamada klinik kullanıma hazırmış gibi ibare ya da sahte güvenlik iddiası yok.

## 7. Kod kalite ve çalışma kuralları

- Clean Code, SOLID, DRY, gerekmedikçe aşırı soyutlama YOK.
- Widget `build` fonksiyonunu okunur/küçük tut; karmaşık bölümleri alt widgetlara ayır.
- `const` mümkün olan her yerde; `StatelessWidget` öncelikli.
- Sabit inline renk/metin stilleri yerine tema. `AppColors` yalnızca token tanımlar; widgetlar `Theme.of(context)` kullanır.
- Her işlev için anlamlı isim, okunur Dart biçimi ve `flutter_lints`.
- Asla gerçek hasta verisi kullanma veya ağ istekleri başlatma. Demo uygulama kapatıldığında bellek verisinin sıfırlanabileceğini kullanıcıya açıkça belirt.
- Gereksiz internet izinleri, analytics, crash tracking, reklam, gizli servis ve hassas log yok.
- Kullandığın SDK'yı kontrol et; sürüm uyumsuzluğu varsa önce açıkla, sessizce yükseltme/geri alma yapma.

## 8. Antigravity için teslim sırası

1. Repo durumunu ve `flutter --version` çıktısını incele; **önce kısa uygulama planını** ve ekran haritasını yaz.
2. İskelet + tema + navigasyon + responsive shell.
3. Modeller + demo store + durum geçişleri.
4. Dashboard + sıra + kayıt + numune + ayarlar ekranları ve çalışan aksiyonlar.
5. Birim/widget testleri, analizi ve kullanıcıya demo turu.
6. Her iterasyonda değişen dosyaları kısa özetle; uzun dosyaları terminale tümüyle dökme.

Çalıştırılabilecek komutlar:

```bash
flutter --version
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run -d chrome  # ancak Chrome cihazı listeleniyorsa
```

Komut çalıştırılamıyorsa **çalıştırılmış gibi raporlama**. Hata çıktısı ve net neden ver; gerekirse hangi kurulum adımının eksik olduğunu belirt.

## 9. Bu sürüme dahil edilmeyecekler

Gerçek hasta kimlik doğrulaması; hastane bilgi sistemine bağlantı; gerçek tahlil sonucu; laboratuvar cihaz kontrolü; kan alma tekniği önerisi; teşhis/tedavi; internet tabanlı senkronizasyon; rollere dayalı gerçek yetkilendirme; production-grade veri güvenliği iddiası.

Bu özellikler için ayrıca klinik ve güvenlik gereksinimleri, hukuki değerlendirme ve backend mimarisi gerekir. **Bu ödev yalnızca eğitim/demonstrasyon amaçlıdır.**
