# Proje: Akıllı Tarım ve Hayvancılık Platformu
**Grup:** Ayberk, Emirhan  
**Platform:** Flutter (Mobil)

---

### Projenin Özeti
Çiftçiler ve hayvancılıkla uğraşan üreticilerin; hem ürünlerini doğrudan tüketiciye/toptancıya listeleyebilecekleri bir pazar yeri, hem de sürü/ürün bakım takvimini ve sera durumlarını takip edebilecekleri operasyonel bir yönetim paneli.

---

### İlk Aşamada Beklenen Özellikler (MVP)
*Not: Proje kapsamı geniş olduğu için iki ana modülü sadeleştirerek MVP seviyesinde tutun.*

1. **Üretici & Tüketici Pazarı (İlan Modülü):**
   - Üreticinin hasat ettiği ürünü (buğday, süt, elma vb.) miktar, fiyat, konum ve fotoğrafla ilana koyabilmesi.
   - Alıcıların kategoriye ve şehre göre ürünleri listeleyip satıcıyla iletişime geçebilmesi.
2. **Hizmet / Destek Rehberi:**
   - Bölgedeki veteriner, traktör/biçerdöver kiralama ve lojistik sağlayıcıların kartlar halinde listelenmesi ve aranabilmesi.
3. **Üretim / Hayvan Takip Paneli:**
   - Basit sürü veya sera kartları: Hayvan küpe no, son aşı tarihi, gebelik durumu; veya Sera sıcaklığı, nem değeri (mock/örnek veri olarak) gösterimi.
4. **Talep / Sipariş Bildirimi:**
   - Alıcının "Şu üründen 500 kg almak istiyorum" teklifi gönderebilmesi.

---

### Flutter & Teknik İpuçları
- **Sensör / IoT Kısmı:** Fiziksel donanım veya canlı sunucu gerekmez; sera ve sıcaklık verilerini `Timer` ile rastgele dalgalanan örnek değerlerle veya yerel JSON'dan okuyarak simüle edin.
- **Veri Saklama (Backend Yok):** Canlı backend kurulmayacak. İlanlar, veteriner rehberi ve hayvan kayıtları için başlangıç verilerini `assets/mock_farms.json` dosyasından yükleyin; yeni eklenen ilan ve kayıtları **Hive** kutusunda saklayın.
- **Harita / Konum:** Harita zorunlu değil, il/ilçe seçimi açılır kutusu (dropdown) yeterlidir.
- **Rol Testi:** Tek cihazda hem üretici hem alıcı gözüyle test edebilmek için profil sayfasına basit bir "Üretici / Tüketici Modu" geçiş anahtarı ekleyin.

---

### Önerilen Ekran Listesi
- Ana Sayfa (Pazar vitrini, öne çıkan ürünler, son duyurular)
- İlan Detay & Satıcı İletişim Ekranı
- İlan Ekleme Sayfası (Kategori, miktar, birim fiyat, görsel)
- Çiftlik / Üretim Yönetim Paneli (Hayvan aşı takvimi veya sera kartları)
- Hizmet Sağlayıcılar Listesi (Veteriner, lojistik rehberi)
