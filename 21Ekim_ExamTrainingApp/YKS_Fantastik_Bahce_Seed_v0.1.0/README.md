# Fantastik Bahçe | YKS Çalışma Asistanı 🌱

> **Giriş:** “Sen filizlen, biz toprağı besleriz.”  
> **İsteğe bağlı, mizahi çıkış:** “Sen filizlen, hayat gübreyi zaten eksik etmiyor.”

Bu depo, **Flutter ile geliştirilmiş, offline-first YKS çalışma ve deneme takip uygulamasıdır**. Anime esintili fantastik botanik görsel kimliği, 10 özgün illüstrasyon manzarası, MEB müfredatı, Pomodoro odak sayacı, interaktif konu ilişkileri haritası, deneme analizi ve puan simülatörü ile eksiksiz olarak hayata geçirilmiştir.

---

## 🌿 Öne Çıkan Özellikler

1. **Ana Bahçe (Geri Sayım & Canlı Durum):**
   - Resmî sınav tarihi bazlı gün/saat/dakika geri sayımı.
   - Günlük soru tamamlama çemberi ve çalışma özeti.
   - "Sen filizlen, biz toprağı besleriz." mottosu.

2. **TYT / AYT Konu Takip & MEB Müfredatı:**
   - 2026 MEB Talim Terbiye müfredatına tam uyumlu ders ve konu listesi.
   - Türkçe, Matematik, Fizik, Kimya, Biyoloji, Tarih, Coğrafya, Felsefe, Din Kültürü, Edebiyat vb.
   - Konu bazında soru sayısı kaydı, bitirme durumu, arama ve filtreleme.

3. **İnteraktif Konu Ağacı & Aralıklı Tekrar (Spaced Repetition):**
   - CustomPainter cubic Bezier eğrileriyle çizilen pedagojik önkoşul zincirleri (Örn: Fonksiyonlar → Polinomlar → Türev → İntegral).
   - Pan/zoom destekli botanik ağ haritası ve ekran okuyucular için "📋 Erişilebilir Liste Modu".
   - 7+ gündür çalışılmayan konular için tazeleyici tekrar bildirimleri.

4. **Deneme Sınavı Yönetimi & Gerçek Net Grafikleri:**
   - ÖSYM standardında net hesabı: `Net = Doğru - (Yanlış / 4)`.
   - SQLite kalıcı saklama, tarih sıralı trend grafiği (`GardenLineChart`).
   - İnteraktif tooltip, ders bazlı döküm, min/maks/ortalama istatistikleri.

5. **Puan Simülatörü & OBP Hesaplama:**
   - ÖSYM kurallarına göre TYT %40 + AYT %60 katkılı yerleştirme puanı simülasyonu.
   - SAY, EA, SÖZ puan türleri, diploma notu (50-100) ve normal (0.12) / kırık OBP (0.06) desteği.
   - Yerel denemelerden tek dokunuşla net aktarımı ("Denemelerimden Yükle ⚡").
   - Şeffaf ve yasal sınırlılık beyanı (`WaterInfoCard`).

6. **Pomodoro & Odak Bahçesi:**
   - 25/5/15 dk ve esnek süre seçenekleri (15/25/45/60 dk).
   - `WidgetsBindingObserver` ile arka plan ve ekran kilitlenmelerinde wall-clock zaman doğruluğu.
   - Tamamlanan odak seanslarının yerel SQLite kaydı ve geçmiş analizi.

7. **Günlük Plan & Soru Hedefleri:**
   - Takvim tabanlı görev ekleme, soru hedefi belirleme ve tek tıkla tamamlama.
   - Ana sayfayla çift yönlü entegrasyon.

8. **Profil, Veri Koruma ve Doğa Temaları:**
   - Açık Doğa Bahçesi ve Gece Bahçesi (Dark Mode) dinamik tema desteği (`AppThemeController`).
   - İki aşamalı onaylı açık veri sıfırlama ve tek tıkla kayıpsız JSON yedek dışa aktarma.
   - %100 yerel veri gizliliği: Bulut yok, telemetri yok, üçüncü taraf izleyici yok, gizli ücret yok.

---

## 🎨 Görsel Sanat ve Tasarım Kimliği

- **10 Özgün Manzara:** `assets/illustrations/scenes/` içinde optimize WebP formatında; ana kaynaklar `design/source_art/*.png` olarak korunmaktadır.
- **Tasarım Sistemi:** `GardenColors`, `GardenTypography`, `GardenElevation` ile uyumlu renk paleti ve yüksek kontrast standartları.
- **Erişilebilirlik & Responsive:** Dar ekranlar (360px) için taşmasız düzenler, tabletler (>=760px) için `AdaptiveNavigationShell` (NavigationRail), %200 metin büyütme (`TextScaler.linear(2.0)`) ve Semantics desteği.

---

## 🧪 Test ve Kalite Güvencesi

Tüm özellikler TDD ve katı kalite kapıları (`docs/qa/quality_gates.md`) altında geliştirilmiştir:

```bash
# Bağımlılıkları yükle
flutter pub get

# Statik kod analizi (0 sorun)
flutter analyze

# Kod formatlama kontrolü
dart format --output=none --set-exit-if-changed lib test

# Tüm birim, widget ve entegrasyon testlerini çalıştır (68/68 PASS)
flutter test
```

---

## 🚀 Çalıştırma

```bash
# Windows Masaüstü
flutter run -d windows

# Web (Chrome)
flutter run -d chrome
```

---

## 🔒 Gizlilik Taahhüdü

Kullanıcının sınav performansı, çalışma hedefleri ve kişisel notları **yalnızca cihazın kendi yerel SQLite veritabanında** saklanır. İnternet bağlantısı gerektirmez, offline-first mimariye sahiptir.

