# 🌿🐑 AKILLI TARIM VE HAYVANCILIK PLATFORMU
## 🛠️ EMİRHAN GÖREV PLANI | Çiftlik Yönetimi + Hizmet Rehberi Modülleri

> **Grup:** Ayberk + Emirhan  
> **Platform:** Flutter (Mobil)  
> **Proje Türü:** Çalışan MVP, sunuma uygun, geliştirilebilir ve ileride canlıya uygun temelli uygulama  
> **Genel Vizyon:** Tarım, hayvancılık ve saha operasyonlarını; **fantastik dokunuşlu**, **kullanıcı dostu**, **görsel olarak güçlü** ama aynı zamanda **gerçekçi ve işlevsel** bir mobil deneyime dönüştürmek.

---

# ✨ 1. PROJENİN TASARIM RUHU

Bu uygulama sadece “form koy, liste göster” mantığında olmayacak. Görsel olarak etkileyici ama gerçekten kullanılabilir olacak.

## Hedef his
- bereket
- kırsal zekâ
- doğa ile teknoloji birlikteliği
- sürü ve üretim yönetimi
- saha desteği
- güvenilir operasyon
- hafif fantastik atmosfer

## Uygulamanın duygusu
> “Sanki modern, akıllı, büyülü dokunuşlara sahip bir çiftlik yönetim paneli kullanıyorum.”

## Tasarım yaklaşımı
- Arka planlar tarım / doğa / sera / ahır / pazar atmosferi çağrıştırabilir.
- Kartlar zengin ve premium görünmeli.
- Ama bilgi her zaman net olmalı.
- Yazılar kaybolmamalı.
- Süslü görünüm, kullanılabilirliğin önüne geçmemeli.

---

# 🎨 2. TASARIM VE TEMA KURALLARI

Ayberk ortak temayı kuracak. Sen de kendi ekranlarını o temaya uyumlu geliştireceksin.

## Uygulama tasarım dili
- hafif fantastik
- modern mobil
- kullanıcı dostu
- net bilgi mimarisi
- tarım + hayvancılık + hizmet atmosferi
- görsel açıdan özgün

## Renk hissi
Muhtemel ana renk yönleri:
- yaprak yeşili
- zeytin tonları
- toprak kahvesi
- altın hasat tonları
- açık krem paneller
- okunabilir koyu metinler

## Zorunlu tasarım kuralları
- Metinler arka planda kaybolmayacak.
- Kartlar içerikten ayrışacak.
- Butonlar görünür ve anlaşılır olacak.
- Form alanları seçilebilir ve net olacak.
- Aşırı karanlık veya aşırı soluk tasarım yapılmayacak.
- Arka plan görseli kullanılsa bile üstüne uygun overlay veya panel yerleştirilecek.

---

# 🤝 3. SENİN ROLÜN

Sen ayrı bir uygulama yazmıyorsun. **Ayberk ile aynı Flutter projesi içinde iki ana modülü geliştiriyorsun.**

Senin sorumlulukların:
1. **Çiftlik / Üretim Yönetim Paneli**
2. **Hizmet / Destek Rehberi**

Ayberk’in sorumlulukları:
- ortak altyapı
- tema
- router
- modellerin ana sahipliği
- pazar yeri
- talep / teklif sistemi
- profil ve rol akışı
- entegrasyon

## Senin branch’in
- `feature/farm-services`

## Çalışma kuralı
- Kendi modül alanlarında çalış.
- Ortak modellerin alan adını değiştirme.
- `pubspec.yaml`, `assets/mock_farms.json`, `app_router.dart` gibi ortak alanlarda ihtiyaç varsa Ayberk’e bildir.
- Son entegrasyonu Ayberk yapacak.

---

# 🗂️ 4. DOSYA SAHİPLİĞİ

| Alan | Sahip | Senin yapacağın |
|---|---|---|
| `lib/features/farm_management/**` | **Emirhan** | Hayvan ve sera paneli |
| `lib/features/services/**` | **Emirhan** | Hizmet rehberi |
| `lib/app/**` | **Ayberk** | Değiştirmeme kuralı |
| `lib/core/models/**` | **Ayberk** | Var olan modelleri kullan |
| `lib/core/storage/**` | **Ayberk** | Hive/seed altyapısını kullan |
| `assets/mock_farms.json` | **Ayberk** | İçerik öner, son sürümü Ayberk ekler |
| `pubspec.yaml` | **Ayberk** | Paket ihtiyacını önceden bildir |

---

# 🐄 5. MODÜL 1 — ÇİFTLİK / ÜRETİM YÖNETİM PANELİ

## Public ekran adı
Ayberk’e şu widget’ı teslim edeceksin:

```dart
const FarmDashboardScreen();
```

## Genel amaç
Kullanıcı; hayvanlarını ve seralarını tek bir yerden görebilsin, temel kayıt ekleyebilsin ve örnek sensör verilerini izleyebilsin.

## Ekran yapısı
`FarmDashboardScreen` içinde ana bölümler:
- Hayvanlarım
- Seralarım
- özet göstergeler

## A. Üst özet alanı
- [ ] Toplam hayvan sayısı
- [ ] Kayıtlı sera sayısı
- [ ] Son aşı tarihi girilmiş kayıt sayısı veya yaklaşan kayıt özeti
- [ ] Estetik özet kartları

## B. Hayvanlar bölümü
Her kartta:
- [ ] küpe numarası
- [ ] tür
- [ ] son aşı tarihi
- [ ] gebelik durumu

### Ek akışlar
- [ ] Hayvan detay ekranı veya detay bottom sheet
- [ ] `Hayvan Ekle` formu

### Form alanları
- [ ] küpe numarası
- [ ] tür
- [ ] son aşı tarihi
- [ ] gebelik durumu

### Doğrulama
- [ ] boş küpe no kabul edilmesin
- [ ] tarih mantıklı olsun
- [ ] aynı küpe no tekrar eklenmesin
- [ ] gebelik durumu `pregnant`, `not_pregnant`, `unknown` olarak yönetilsin

### Kayıt
- [ ] Hive `animals` kutusuna kaydet
- [ ] Uygulama kapanıp açıldığında veri korunsun

## C. Sera bölümü
Her kartta:
- [ ] sera adı
- [ ] sıcaklık (°C)
- [ ] nem (%)
- [ ] son güncelleme zamanı
- [ ] verinin simüle edildiğini belirten bilgi

### Simülasyon
- [ ] `Timer.periodic` ile yaklaşık 5 saniyede bir küçük değer değişimi
- [ ] sıcaklık yaklaşık ±0.5 °C değişebilir
- [ ] nem yaklaşık ±2 puan değişebilir
- [ ] nem `0–100` aralığında tutulmalı
- [ ] ekran kapandığında timer `dispose()` içinde iptal edilmeli

### Kural
- Gerçek sensör, MQTT, canlı IoT, API zorunlu değil.
- Bu kısım **mock / simülasyon** olacak.

## D. Tasarım notları
- Kartlar sadece kutu gibi görünmesin; bilgi katmanları net olsun.
- Hayvan kartlarında küçük ikonlar / rozetler kullanılabilir.
- Sera kartlarında sıcaklık ve nem için görsel etiketler olabilir.
- Arka plan çok hareketli olmayacak; veri okunabilir kalacak.
- Hafif doğa / sera / ot / toprak hissi olabilir.

---

# 🚜 6. MODÜL 2 — HİZMET / DESTEK REHBERİ

## Public ekran adı
Ayberk’e şu widget’ı teslim edeceksin:

```dart
const ServiceProvidersScreen();
```

## Genel amaç
Kullanıcı bulunduğu bölgedeki destek sağlayıcıları bulabilsin.

## Kategoriler
- Veteriner
- Traktör Kiralama
- Biçerdöver Kiralama
- Lojistik

## Her kartta gösterilecek bilgiler
- [ ] sağlayıcı adı
- [ ] kategori
- [ ] il / ilçe
- [ ] kısa açıklama
- [ ] telefon bilgisi

## Yapılacaklar
- [ ] Listeleme ekranı
- [ ] Arama kutusu
- [ ] Kategori filtresi
- [ ] Şehir filtresi
- [ ] Birden fazla filtre aynı anda çalışsın
- [ ] Kayıt yoksa boş durum göster
- [ ] Filtre temizleme seçeneği sun

## Arama / çağrı akışı
- [ ] `url_launcher` ile `tel:` aksiyonu
- [ ] arama açılamıyorsa uygun hata / bilgi mesajı göster
- [ ] telefon boşsa arama butonunu pasif yap

## Veri kaynağı
- Başlangıç verileri `serviceProviders` listesinden gelecek.
- Ortak seed mantığını tekrar yazma.
- Hive’dan oku, kendi içinde filtrele.

## Tasarım notları
- Hizmet kartları düzenli ve güven veren görünmeli.
- Kategori chip’leri belirgin olmalı.
- Liste sade ama premium görünmeli.
- “Kırsal operasyon rehberi” havası vermeli.

---

# 📘 7. ORTAK VERİ SÖZLEŞMESİNE UYUM

Kendi alternatif modelini yazma. Ayberk’in oluşturduğu modelleri kullan.

## Kullanacağın modeller
- `Animal`
- `Greenhouse`
- `ServiceProvider`

## Alanlar

### Animal
- `id`
- `earTag`
- `species`
- `lastVaccinationDate`
- `pregnancyStatus`

### Greenhouse
- `id`
- `name`
- `temperatureC`
- `humidityPercent`
- `updatedAt`

### ServiceProvider
- `id`
- `name`
- `type`
- `city`
- `district`
- `phone`
- `description`

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

## Hive kutuları
- `animals`
- `greenhouses`
- `serviceProviders`

> Merkezi açılış, kutu açma ve seed mantığı Ayberk’te. Sen var olan yapıyı kullanacaksın.

---

# 🔗 8. ENTEGRASYON SÖZLEŞMESİ

Teslim ettiğinde şu iki ekran dışarıdan import edilip çalıştırılabilir durumda olmalı:

```dart
const FarmDashboardScreen();
const ServiceProvidersScreen();
```

## Kurallar
- Kendi içinde state yönetimini yapabilirsin.
- Ama ikinci bağımsız uygulama mantığı kurma.
- Ayrı tema sistemi yazma.
- `Theme.of(context)` kullan.
- Route yönetimini Ayberk yapacak.

---

# 🧪 9. TEST VE KABUL KRİTERLERİ

## Teknik kabul
- [ ] Hayvan ekleme formu çalışıyor
- [ ] Aynı küpe numarası engelleniyor
- [ ] Hive’dan veri okunuyor
- [ ] Uygulama yeniden açılınca hayvan kaydı korunuyor
- [ ] Sera simülasyonu çalışıyor
- [ ] Ekran kapanınca timer duruyor
- [ ] Hizmet listesi filtrelenebiliyor
- [ ] Arama çalışıyor
- [ ] `flutter analyze` temiz
- [ ] `flutter test` başarılı

## UX kabul
- [ ] Yazılar görünür
- [ ] Kartlar okunaklı
- [ ] Filtreler anlaşılır
- [ ] Boş durum ekranı var
- [ ] Tarım / hayvancılık teması hissediliyor
- [ ] Fantastik dokunuş var ama ekran ciddiyetini koruyor

---

# 🪜 10. SENİN ÖNERİLEN ÇALIŞMA SIRAN

## Faz 1 — Görsel iskelet
- [ ] Ekranların kaba UI yapısını oluştur
- [ ] Kart alanlarını yerleştir
- [ ] Formları oluştur
- [ ] Filtre alanlarını ekle

## Faz 2 — Veri bağlantısı
- [ ] Hayvan repository / erişim mantığı
- [ ] Sera verisi bağlama
- [ ] Hizmet sağlayıcı listesini bağlama
- [ ] Filtreleme ve aramayı bağlama

## Faz 3 — Simülasyon
- [ ] Timer ile sera değerlerini dalgalandır
- [ ] Dispose kontrolünü tamamla

## Faz 4 — UX cilası
- [ ] Boş durumlar
- [ ] Yükleniyor durumları
- [ ] Hata durumları
- [ ] Küçük ikonlar / rozetler / chip’ler

## Faz 5 — Teslim
- [ ] Kod temizliği
- [ ] Testler
- [ ] Ayberk’e entegrasyona hazır public ekranları ver

---

# ⚔️ 11. GİT KURALLARI

```bash
git switch main
git pull origin main
git switch -c feature/farm-services
```

Çalışma sonrası:

```bash
git add .
git commit -m "feat: add farm dashboard and services modules"
git push -u origin feature/farm-services
```

## Kurallar
- Ayberk’in dosyalarını gereksiz yere değiştirme.
- Ortak model alanlarını bozma.
- Aynı işi ikinci kez yazma.
- Ortak dosya ihtiyacını önce haber ver.
- `git push --force` kullanma.

---

# 🏁 12. SENİN TESLİMİNİN ÖZETİ

Senin teslimin sonunda şunlar hazır olmalı:

- `FarmDashboardScreen`
- `ServiceProvidersScreen`
- çalışan hayvan kayıt akışı
- çalışan sera simülasyonu
- çalışan hizmet rehberi
- tema ile uyumlu, süslü ama okunaklı arayüz
- Ayberk’in projeye rahatça entegre edebileceği temiz modüller

> Kısacası senin görevin; uygulamanın “saha yönetimi ve destek operasyonu” tarafını güçlü, estetik ve gerçekçi şekilde hayata geçirmek.
