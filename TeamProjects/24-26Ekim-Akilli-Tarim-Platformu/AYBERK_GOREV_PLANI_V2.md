# 🌾🐄 AKILLI TARIM VE HAYVANCILIK PLATFORMU
## 👑 AYBERK GÖREV PLANI | Ürün Sahibi + Ortak Altyapı + Pazar Yeri + Entegrasyon

> **Grup:** Ayberk + Emirhan  
> **Platform:** Flutter (Mobil)  
> **Proje Türü:** Gerçekten geliştirilebilir, demo yapılabilir, ileride canlıya çıkarılabilir MVP  
> **Genel Vizyon:** Tarım, hayvancılık, ticaret ve saha yönetimini; **fantastik atmosfer**, **gerçekçi kullanım**, **yüksek kullanıcı deneyimi** ve **modern mobil tasarım** ile birleştiren özgün bir uygulama.

---

# ✨ 1. PROJENİN YENİ TASARIM VİZYONU

Bu uygulama sıradan bir CRUD okul projesi gibi görünmeyecek. Hedefimiz:

- **gerçekten çalışan**, 
- **sunumda etkileyici duran**,
- **geliştirilmeye açık**,
- **kullanıcı dostu**,
- **özgün görsel kimliğe sahip**
- ve gerektiğinde ileride **canlıya taşınabilecek** bir temel kurmak.

## 🎨 Görsel Kimlik ve Atmosfer

Uygulama; **tarım, çiftlik, hayvancılık, ticaret ve üretim** dünyasını, hafif **fantastik / masalsı ama yetişkin ve premium** bir tasarım diliyle birleştirecek.

### Hedef his:
- bereket
- güven
- doğallık
- üretim
- emek
- ticaret
- teknoloji destekli kırsal yönetim
- hafif fantastik dünya hissi

### Uygulama şu hissi vermeli:
> “Sanki modern bir çiftlik imparatorluğu yönetim sistemi kullanıyorum; hem toprağın doğallığı var, hem de sofistike bir dijital panel hissi.”

## 🖼️ Arayüz Estetik İlkeleri

- Ekranlarda **arka plan görselleri / illüstratif paneller / dekoratif tarımsal dokular** kullanılabilir.
- Ancak içerik okunabilirliğini bozmamalı.
- Kartlar, butonlar, chip’ler ve bölümler **alan alan ayrılmış**, ferah ve net olmalı.
- Yazılar **arka planda kaybolmamalı**.
- Kontrast düşük renkler kullanılmamalı.
- Ekran çok süslü ama kullanılamaz hale gelmemeli.
- Tasarım **şov için değil, kaliteli kullanım için süslü** olmalı.

## 🎨 Renk Yönü

Ana temada tarım ve hayvancılığı çağrıştıran ama klasik koyu-çamur yeşiliyle boğmayan zengin tonlar kullanılmalı.

### Önerilen ana palet
- **Toprak Kahvesi:** `#6B4F3A`
- **Derin Yaprak Yeşili:** `#2F5D50`
- **Zeytin / Tarla Yeşili:** `#6C7A3B`
- **Altın Hasat:** `#C89B3C`
- **Krem / Açık Buğday:** `#F4EBD0`
- **Süt Beyazı / Açık Panel:** `#FFFDF8`
- **Kömür Metin Rengi:** `#23201B`
- **Uyarı / Vurgu Turuncusu:** `#D97A2B`

### Kullanım ilkesi
- Açık zemin üzerinde koyu yazı tercih edilecek.
- CTA butonları için yeşil / altın / turuncu vurgu kullanılabilir.
- Fazla gri ve cansız tonlara boğulmayacak.
- Pastel, soluk, silik bir görünüm istenmiyor.
- Canlı ama gözü yormayan, premium bir görünüm hedeflenecek.

## 🔠 Tipografi ve Görünürlük

- Başlıklar belirgin, güçlü ve temiz olmalı.
- Gövde yazıları her ekranda rahat okunmalı.
- Açık zemin + koyu yazı veya koyu panel + açık yazı kontrastı korunmalı.
- Buton metinleri asla zemine karışmamalı.
- Form alanları belirgin kenarlık / dolgu ile ayırt edilmeli.

---

# 🧭 2. SENİN ANA ROLÜN

Sen bu projenin:
- **ortak teknik temeli kuran**,
- **uygulama mimarisini ayarlayan**,
- **tasarım sistemini başlatan**,
- **pazar yeri modülünü geliştiren**,
- **teklif/talep sistemini yazan**,
- **profil ve rol mantığını kuran**,
- ve en sonunda **Emirhan’ın modüllerini entegre eden kişi**sin.

Kısacası sen:
> **ürün sahibi + entegratör + ortak altyapı geliştiricisi** rolündesin.

---

# 🏗️ 3. ORTAK MİMARİ VE REPOSITORY SAHİPLİĞİ

## Repository mantığı
Tek bir Flutter mobil uygulaması geliştirilecek.

### Git akışı
- Ana dal: `main`
- Senin temel/özellik dalların:
  - `feature/foundation`
  - `feature/marketplace-offers`
  - gerekiyorsa `feature/design-system`
- Emirhan’ın dalı:
  - `feature/farm-services`

## Dosya sahipliği

| Alan | Sahip | Açıklama |
|---|---|---|
| `lib/app/**` | **Ayberk** | Uygulama kabuğu, router, tema, rol yönetimi |
| `lib/core/models/**` | **Ayberk** | Ortak modeller |
| `lib/core/storage/**` | **Ayberk** | Hive ve seed yapısı |
| `lib/core/theme/**` veya `lib/app/app_theme.dart` | **Ayberk** | Tasarım sistemi, renkler, tema, bileşen stili |
| `lib/features/marketplace/**` | **Ayberk** | Pazar yeri |
| `lib/features/offers/**` | **Ayberk** | Talep / teklif sistemi |
| `lib/features/profile/**` | **Ayberk** | Profil + Üretici/Tüketici modu |
| `lib/features/farm_management/**` | **Emirhan** | Hayvan + sera yönetimi |
| `lib/features/services/**` | **Emirhan** | Hizmet rehberi |
| `assets/mock_farms.json` | **Ayberk** | Nihai seed dosyası |
| `pubspec.yaml` | **Ayberk** | Paket ve asset yönetimi |

> **Kural:** Ortak dosyaların son sözü sende. Emirhan ihtiyaçlarını sana iletir, sen ortak yapıya eklersin.

---

# 🪵 4. KURMAN GEREKEN TEMEL TEKNİK ALTYAPI

## Temel teknoloji
- Flutter
- Hive
- hive_flutter
- image_picker
- path_provider
- url_launcher

İstersen ayrıca şu yardımcı paketler düşünülebilir:
- `intl` → tarih/sayı formatlama
- `uuid` → id üretimi
- `google_fonts` → tipografi (zorunlu değil)

## Klasör yapısı

```text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── app_router.dart
│   ├── app_theme.dart
│   └── role_controller.dart
├── core/
│   ├── models/
│   │   ├── product.dart
│   │   ├── offer.dart
│   │   ├── animal.dart
│   │   ├── greenhouse.dart
│   │   ├── service_provider.dart
│   │   └── user_role.dart
│   ├── storage/
│   │   ├── hive_service.dart
│   │   └── seed_loader.dart
│   └── widgets/
├── features/
│   ├── marketplace/
│   ├── offers/
│   ├── profile/
│   ├── farm_management/
│   └── services/
assets/
├── mock_farms.json
└── images/
```

## Zorunlu ilk temel işlerin
- [ ] Flutter proje iskeletini kur.
- [ ] Tema sistemini kur.
- [ ] Ortak modelleri yaz.
- [ ] Hive kutularını aç.
- [ ] Seed yükleyiciyi yaz.
- [ ] Alt navigasyon veya ana menü yapısını belirle.
- [ ] Placeholder ekranlarla iskeleti ayağa kaldır.
- [ ] Emirhan’ın public ekranları için rotaları hazırla.

---

# 📦 5. ORTAK VERİ SÖZLEŞMESİ

Aşağıdaki model alanları sabit kalmalı.

## Product
- `id`
- `sellerId`
- `title`
- `category`
- `quantity`
- `unit`
- `unitPrice`
- `city`
- `district`
- `imagePath`
- `sellerPhone`
- `description`
- `createdAt`

## Offer
- `id`
- `productId`
- `buyerName`
- `buyerPhone`
- `requestedQuantity`
- `note`
- `status`
- `createdAt`

## Animal
- `id`
- `earTag`
- `species`
- `lastVaccinationDate`
- `pregnancyStatus`

## Greenhouse
- `id`
- `name`
- `temperatureC`
- `humidityPercent`
- `updatedAt`

## ServiceProvider
- `id`
- `name`
- `type`
- `city`
- `district`
- `phone`
- `description`

## UserRole
- `producer`
- `consumer`

## JSON kökü
```json
{
  "products": [],
  "offers": [],
  "animals": [],
  "greenhouses": [],
  "serviceProviders": []
}
```

## Yerel saklama kuralları
- Hive kutuları:
  - `products`
  - `offers`
  - `animals`
  - `greenhouses`
  - `serviceProviders`
  - `settings`
- `Box<String>` + `jsonEncode` / `jsonDecode` yaklaşımı kullanılacak.
- Kayıt anahtarı modelin `id` alanı olacak.
- Seed verileri yalnızca eksikse yüklenecek; kullanıcı verisi ezilmeyecek.

---

# 🛍️ 6. SENİN ANA MODÜLÜN: PAZAR YERİ

## Amaç
Üreticiler ürün ilanı açabilsin, alıcılar listeleyebilsin, detay görebilsin ve satıcıyla iletişime geçebilsin.

## Yapılacaklar

### A. Ana Sayfa / Vitrin
- [ ] Öne çıkan ürünler alanı
- [ ] Kategori kartları
- [ ] Son ilanlar alanı
- [ ] Üst bölümde etkileyici ama performanslı bir hero alanı
- [ ] Hafif dekoratif arka plan / tarım illüstrasyonu / hasat atmosferi

### B. Ürün Listeleme
- [ ] Ürün kartında görsel, başlık, miktar, birim fiyat, il/ilçe olsun.
- [ ] Kategoriye göre filtreleme.
- [ ] Şehre göre filtreleme.
- [ ] Sonuç yoksa güzel boş durum ekranı.

### C. Ürün Detay
- [ ] Büyük görsel
- [ ] açıklama
- [ ] miktar / birim
- [ ] fiyat
- [ ] şehir / ilçe
- [ ] satıcı telefonu
- [ ] iletişim / arama butonu

### D. İlan Ekleme
- [ ] Sadece üretici modunda erişilsin.
- [ ] Alanlar:
  - kategori
  - başlık
  - miktar
  - birim
  - birim fiyat
  - il
  - ilçe
  - açıklama
  - telefon
  - görsel
- [ ] `image_picker` ile görsel seç.
- [ ] Görseli uygulama dizinine kopyala.
- [ ] Doğrulama yap:
  - boş alan olmasın
  - miktar > 0
  - fiyat > 0
  - telefon formatı makul olsun

### E. Tasarım Notları
- Ürün kartları “pazar tezgâhı” hissi verebilir.
- Görseller yuvarlatılmış, premium kartlar içinde sunulmalı.
- Kategori seçimleri chip veya kart şeklinde olabilir.
- Ticaret + üretim + doğa atmosferi güçlü hissedilmeli.

---

# 📬 7. SENİN MODÜLÜN: TALEP / TEKLİF SİSTEMİ

## Amaç
Alıcı, “Bu üründen şu kadar almak istiyorum” teklifi gönderebilsin.

## Yapılacaklar
- [ ] İlan detayından **Teklif Gönder** akışı
- [ ] Form alanları:
  - alıcı adı
  - telefon
  - talep edilen miktar
  - not
- [ ] `requestedQuantity > 0`
- [ ] `requestedQuantity`, mevcut ürün miktarını aşmamalı
- [ ] Hive `offers` kutusuna kaydet
- [ ] Varsayılan durum `pending`
- [ ] Üretici modunda “Gelen Talepler” ekranı
- [ ] İsteğe bağlı `accepted` / `rejected` durumu

## Tasarım Notu
Bu ekran sade form olmamalı; küçük ikonlar, bilgi kartları, ürün özeti ve teklif kutusu ile iyi yapılandırılmış görünmeli.

---

# 👤 8. SENİN MODÜLÜN: PROFİL + ROL MANTIĞI

## Amaç
Aynı cihazda hem üretici hem tüketici gibi test edebilmek.

## Yapılacaklar
- [ ] Profil ekranı oluştur.
- [ ] `Üretici / Tüketici Modu` anahtarı ekle.
- [ ] Seçili rolü `settings` içinde sakla.
- [ ] Üretici için gösterilecek alanlar:
  - ilan ekleme
  - gelen talepler
  - çiftlik paneli
- [ ] Tüketici için gösterilecek alanlar:
  - pazar keşfi
  - teklif gönderme
  - hizmet rehberi

## Tasarım Notu
Profil ekranında köylü / üretici / ticaret ekosistemi hissi olabilir; ama karikatür değil, premium olmalı.

---

# 🧩 9. EMİRHAN İLE ENTEGRASYON GÖREVİN

Emirhan şu iki public widget’ı teslim edecek:

```dart
const FarmDashboardScreen();
const ServiceProvidersScreen();
```

Senin görevin:
- [ ] Bu ekranları rotalara bağlamak
- [ ] Menüye / tab yapısına eklemek
- [ ] Tema uyumunu sağlamak
- [ ] Veri sözleşmesinin korunmasını sağlamak
- [ ] Çakışmaları çözmek

## Rotalar
```text
/marketplace
/product-detail
/add-product
/offers
/farm
/services
/profile
```

---

# 🎭 10. TASARIM SİSTEMİ GÖREVLERİ

Bu projede çok kritik bir fark oluşturacak alan burasıdır.

## Oluşturman gerekenler
- [ ] Ortak renk sabitleri
- [ ] Light theme
- [ ] Kart stilleri
- [ ] Buton stilleri
- [ ] Input dekorasyonu
- [ ] Chip / badge stilleri
- [ ] Durum etiketleri:
  - bekliyor
  - kabul edildi
  - reddedildi
  - sıcaklık
  - nem
  - veteriner
  - lojistik

## Tasarım kuralları
- Kart zeminleri içerikten ayrışmalı.
- Arka plan resimleri opaklık / overlay ile dengelenmeli.
- Metinler her zaman rahat okunmalı.
- Çok fazla süs ile kullanılabilirlik feda edilmemeli.
- Kullanıcı neyin tıklanabilir olduğunu rahat anlamalı.

---

# 🧪 11. TEST VE KABUL KRİTERLERİ

## Teknik kabul
- [ ] `flutter analyze` temiz
- [ ] `flutter test` başarılı
- [ ] Uygulama çökmeden açılıyor
- [ ] Seed verileri yükleniyor
- [ ] Yeni ürün eklenince anında listede görünüyor
- [ ] Uygulama yeniden açıldığında ürün duruyor
- [ ] Teklif gönderilebiliyor
- [ ] Rol değişimi kaydediliyor
- [ ] Emirhan ekranları entegre edilince rota sistemi sorunsuz çalışıyor

## UX kabul
- [ ] Yazılar görünür
- [ ] Renkler uyumlu
- [ ] Formlar anlaşılır
- [ ] Boş durum ekranları güzel
- [ ] Hata mesajları açıklayıcı
- [ ] Tarım / hayvancılık / ticaret atmosferi hissediliyor
- [ ] Fantastik hava var ama uygulama ciddiyetini kaybetmiyor

---

# 📅 12. SENİN ÖNERİLEN ÇALIŞMA SIRAN

## Faz 1 — Temel
- [ ] Projeyi oluştur
- [ ] Tema sistemi kur
- [ ] Ortak modelleri kur
- [ ] Hive ve seed yapısını kur
- [ ] Placeholder ekranlarla akışı ayağa kaldır

## Faz 2 — Kendi modüllerin
- [ ] Pazar yeri
- [ ] İlan ekleme
- [ ] Teklif sistemi
- [ ] Profil + rol mantığı

## Faz 3 — Tasarım cilası
- [ ] Kart görünümleri
- [ ] ikonografi
- [ ] arka plan görselleri / banner alanları
- [ ] boş durumlar
- [ ] giriş animasyonları (hafif, abartısız)

## Faz 4 — Entegrasyon
- [ ] Emirhan modüllerini al
- [ ] rotalara bağla
- [ ] tema uyumunu tamamla
- [ ] bug fix yap

## Faz 5 — Sunum hazırlığı
- [ ] Demo verilerini düzenle
- [ ] Güzel ekran görüntüleri al
- [ ] Akış sırasını prova et

---

# ⚔️ 13. GİT KURALLARI

```bash
git switch main
git pull origin main
git switch -c feature/marketplace-offers
```

Çalışma sonrası:

```bash
git add .
git commit -m "feat: add marketplace, offers and profile modules"
git push -u origin feature/marketplace-offers
```

## Kurallar
- Başkasının dosyasını gereksiz yere bozma.
- Büyük değişiklikten önce haber ver.
- Ortak modellerde alan adı değiştirme.
- `git push --force` yapma.
- PR açıklamasında ne yaptığını net yaz.

---

# 🏁 14. SENİN TESLİMİNİN ÖZETİ

Senin teslimin sonunda şunlar hazır olmalı:

- çalışan Flutter temel proje
- güçlü ve özgün tema sistemi
- pazar yeri modülü
- ilan ekleme akışı
- teklif/talep modülü
- profil ve rol yönetimi
- Emirhan modüllerinin entegre edilebildiği yapı
- fantastik ama profesyonel bir tarım/hayvancılık ticaret uygulaması hissi

> Kısacası senin görevin sadece kod yazmak değil; projenin omurgasını, tasarım kalitesini ve ürün bütünlüğünü kurmak.
