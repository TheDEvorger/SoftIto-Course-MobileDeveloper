# Gereksinim ve teslim durumu

Kaynaklar: vision.md, business-rules.md, personas.md, handover.md, screen-map.md.
İnceleme: 2026-10-21. TASK-014 normal uygulamayı kullanıcının açık isteğiyle
sunucusuz hale getirdi. Keşfet/Favoriler/Planlarım/Profil, yerel fiyat ve kalıcı
cihaz kayıtları normal akıştır. Aşağıdaki TASK-013 sunucu işlevleri main_api.dart
ile isteğe bağlı korunur; normal uygulama için sunucu/anahtar gerekmez.

Tarihsel karşılaştırma: Tarihsel prototip görevlerinin bitmesi, ürünün tamamının
üretime hazır olduğu anlamına gelmez. TASK-013 aşağıdaki yerel akışları tamamlar.

| Gereksinim | Durum | Teslim edilen / kalan sınır |
| --- | --- | --- |
| Bireysel + filo keşfi | Tamamlandı, yerel | Ayrı ve etiketli örnek koleksiyon; özel envanter korunur |
| Arama, tarihler, detay | Tamamlandı, yerel | API kayıtları, filtreleme, sıralama ve müsaitlik |
| Araç / yayın ayrımı (BR-003) | Tamamlandı, yerel | Ayrı yayın kaydı; yayından kaldırma geçmişi silmez |
| Müsaitlik (BR-004) | Tamamlandı, yerel | Operatör tarih kapatma/açma; atomik çakışma denetimi |
| Sunucu fiyatı (BR-005) | Tamamlandı, yerel | İmzalı 5 dakikalık teklif; değişen fiyat yeniden onaylanır |
| Rezervasyon (BR-007) | Tamamlandı, yerel | Kalıcı oluşturma/iptal, yinelenen istek koruması, geçmiş |
| Araç yönetimi | Tamamlandı, yerel | Ekle/düzenle, fiyat/bakım, yayın, takvim ve kayıt sayıları |
| Dolu menüler ve tasarım | Tamamlandı, web | Gerçek API üzerinde örnek araçlar/planlar; uyarlanabilir ekranlar |
| Kimlik / sürücü uygunluğu | Ertelendi, kullanıcı kararı | Sağlayıcı yok; yerel anahtar müşteri doğrulaması değildir |
| Ödeme / hakediş (BR-006/011) | Ertelendi, kullanıcı kararı | Sağlayıcı yok; tahsilat, iade veya gelir doğrulaması yapılmaz |
| Fiziksel teslim / sürüş (BR-008) | Eksik | Doğrulanmış taraflar, teslim penceresi/politikası ve gerçek kanıt gerekir |
| Dijital teslim (BR-013) | Eksik | OEM/donanım, yetki, imzalı komut ve olumlu durum bildirimi gerekir |
| İnceleme / yapay zekâ (BR-009/010) | Eksik | Eski 20 açılı simülasyon var; onaylı kanıt saklama, gerçek yükleme ve insan incelemesi gerekir |
| Organizasyon/şube (BR-012) | Eksik | Eski rol simülasyonu var; gerçek kimlik, sunucu üyelikleri ve RBAC gerekir |
| Ticari iptal/uzatma (BR-014) | Eksik | Yerel iptal var; ticari politika, ceza/iade ve uzatma kuralları seçilmedi |
| Yorumlar, bildirim, destek/admin | Eksik | Aktör yetkileri, moderasyon, hizmet sözleşmeleri ve gerçek olaylar gerekir |
| Platformlar | Kısmi | Web doğrulandı; Flutter mobil/masaüstü kaynakları var, fiziksel cihaz kabulü gerekli |

## Veri anlamı
Örnek içerik, ayrı SQLite dosyasında kalıcı kayıtlarla aynı API ve iş kurallarını
kullanır. Sahte canlı sağlayıcı, gerçek müşteri, doğrulanmış kiralama ilanı veya
ödeme değildir. Özel API başarısız olduğunda örnek kayıtlara sessiz geçiş yapılmaz.
Örnek alanın anahtarı özel verilere erişemez. Örnekler ilk kurulumda bir kez eklenir;
yeniden başlatma sonradan yapılan değişiklikleri sıfırlamaz.

## Sıra ve kabul
1. Gereksinim karşılaştırması bu tabloda tamamlandı.
2. TASK-013 yerel yayın/takvim/teklif akışlarını ve dolu çalışma alanını tamamlar.
3. Aynı akışlar dar/geniş ekran, temalar, büyük yazı ve gerçek HTTP ile doğrulanır.

Eksik entegrasyonlar tamamlanmış sayılmaz. Kullanıcının daha sonra seçilecek dediği
kimlik/ödeme sağlayıcıları, üretim veri saklama politikası ve araç açma yetkileri
bu istekten çıkarımla seçilmedi. Sıradaki kabul fiziksel hedef cihazdaki kontroldür;
üretim yayını mevcut güvenlik ve entegrasyon kapılarından ayrıca geçmelidir.
