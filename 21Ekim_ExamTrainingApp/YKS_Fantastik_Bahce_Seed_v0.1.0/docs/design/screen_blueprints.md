# Sayfa taslakları ve UX kriterleri

## 1. Ana sayfa (bottom tab 1)

Üstte `Merhaba` + kişiselleştirme, hafif doğa illustrasyonu. YKS geri sayımı yalnızca tarih seçildiyse. Günlük görev özeti, net kayıt varsa son net, konu ilerleme özeti, **Odak başlat**. Görsel: `01_garden_sunrise`. İlk açılış boşsa motivasyon sözü ve `İlk hedefini oluştur` eylemi. Sahte net gösterme.

## 2. Konular (tab 2)

Üst başlık, TYT/AYT segment, arama, durum filtreleri, ders listesi ve özet oranlar. Konu sayfasında seçim / konu notu / soru sayısı / tekrar. `04_glasshouse` üst görsel. Kısmi ilerleme yapısı: `eksik`, `çalışılıyor`, `tamamlandı`. Her dersin renk kimliği olabilir, erişilebilir kontrast zorunlu.

## 3. Denemeler (tab 3)

Yeni deneme oluştur, oturum seç, tarih ve tür, branş/kapsam seç, doğru/yanlış/boş alanları, otomatik net ve giriş kontrolü. Deneme listesi ve ayrıntı. `02_river_grove` veya küçük botanik kenar süslemesi, esas giriş temiz zeminde. Kaydet sonrası gerçek veri, silmeden önce onay, düzenlemeye izin.

## 4. Analiz (tab 4)

Boş veri halinde bilgilendirici durum; 2+ uygun ölçüm olunca çizgi grafik; TYT/AYT filtreleri, ders serileri, seçili nokta detayları, ekran okuyucu için tablo metni. Ön koşullu konu haritası MVP sonrası `08_emerald_waterfall` ile ayrı sayfa. Düzenli istatistik kartları; gereksiz büyük illüstrasyon yok.

## 5. Profil (tab 5)

`07_golden_terrace`; öğrencinin adı veya anonim varsayılan, hedef alanı, hedef net, tema, yerel veri denetimi, isteğe bağlı mizahi veda tercihi. Gereksiz hesap oluşturma mecburiyeti yok.

## 6. Odak / Pomodoro (Ana Sayfa CTA)

`09_study_cottage` sahnesi. Büyük 25:00 (varsayılan, ayarlanabilir), erişilebilir Başlat/Duraklat/Sıfırla, kısa/uzun mola, tamamlanan oturumun kaydı. Telefon küçük ekranda arka plan üzerine kontrastlı panel ve okunur buton. Gece varyantı `06_moon_garden`.

## Günlük Plan (ana sayfa alt sayfa)

`02_river_grove`, görev ekle, tamamla/geri al, tarih, soru hedefi, düzenleme; boş durum metni. Her şey ana ekrana sığdırılmaya çalışılmayacak.

## Mobil/tablet davranışı

Telefon: 5 alt sekme; Odak CTA. Geniş ekran: `NavigationRail` + daha geniş içerik, büyük manzarayı card/header içinde kontrollü kullan. SafeArea, klavye, landscape, aşırı text scale test.

## Giriş/çıkış yazısı

- Başlangıç: `Sen filizlen, biz toprağı besleriz.`
- Opsiyonel veda: `Sen filizlen, hayat gübreyi zaten eksik etmiyor.` Kullanıcının istemediği zaman çıkma, sonsuz tekrar yok.
