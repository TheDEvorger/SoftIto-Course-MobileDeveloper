# Fantastik Bahçe | YKS Çalışma Asistanı 🌱

> **Giriş:** “Sen filizlen, biz toprağı besleriz.”  
> **İsteğe bağlı, mizahi çıkış:** “Sen filizlen, hayat gübreyi zaten eksik etmiyor.”

Bu depo, **Flutter ile geliştirilecek YKS çalışma ve deneme takip uygulamasının Antigravity tohumudur**. Tamamlanmış uygulama veya test edilmiş yayıma hazır sürüm değildir. Görsel kimlik, onaylanmış ekran referansı, 10 ayrı illüstrasyon ve iş planı paket içindedir.

## İlk 60 saniye

1. ZIP'i aç, klasörü Antigravity'nin çalışma alanı olarak seç.
2. `AGENTS.md` ve `docs/agent/first-prompt.md` dosyalarını oku.
3. Kök dizindeki `ANTIGRAVITY_ILK_PROMPT.txt` içeriğini Antigravity sohbetine **aynen yapıştır**.
4. Araç, `TASK-001` ile başlayıp `docs/agent/task_board.md` sırasınca görevlere devam edecek.

## Kanonik kaynaklar ve öncelik

1. **İşlevsel başlangıç gereksinimleri**: `20_yks_calisma_uygulamasi.md` (KULLANICININ VERDİĞİ ORİJİNAL; DEĞİŞTİRME).
2. **Kullanıcıyla kararlaştırılan görsel yön**: `design/references/approved_ui_direction.png`, `docs/design/visual_identity.md`, `docs/design/art_direction.md`.
3. **Uygulanabilirlik / kabul kriterleri**: `docs/product/product_spec.md`, `docs/agent/tasks/`, `docs/qa/`.
4. **Asıl illüstrasyonlar**: `design/source_art/*.png`; uygulama optimizasyonu: `assets/illustrations/scenes/*.webp`.

Çelişki bulunursa kaynakları keyfî biçimde değiştirme. Belgele ve `docs/project/questions.md` içine kaydet.

## Mevcut olanlar

- 10 ayrı yüksek kaliteli, 941 × 1672 PNG manzara + uygulama için optimize WebP sürümleri.
- Görsel referans ve 4 el çizimi.
- Başlangıç Flutter kodu: gezinme kabuğu, görsel başlık, gerçek net matematiği, yerel bellekli kısa Pomodoro örneği.
- Gereksinim, tema tokenları, sayfa planı, veri modeli, görev kuyruğu, test/kalite kuralları.

## Henüz yapılmamış olanlar

- Tam Flutter platform dosyaları (`android/`, `web/`, `windows/`; TASK-001'de `flutter create` ile oluşturulacak).
- Kalıcı veritabanı, tam ders müfredatı, deneme kaydı, grafikler, sınav puanı tahmini, uygulama mağazası sürümleri.
- Bu paketi üreten ortamda Flutter/Dart CLI mevcut olmadığından `flutter analyze` ve `flutter test` çalıştırılamadı. Antigravity bunları uygun sistemde çalıştırmalıdır.

## Hızlı komutlar (Flutter kurulu makinede)

```bash
flutter create --platforms=android,web,windows --project-name fantastik_bahce_yks --org com.example .
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

`--org com.example` yalnızca geçici başlangıç kimliğidir, yayımlama öncesi gerçek paket kimliği kararlaştırılmalı. `flutter create` mevcut `lib/` ve `pubspec.yaml` içeriğinin üzerine yazmak isterse önce yedek alıp birleştir, **kullanıcıya özel kodu silme**. iOS hedefi daha sonra macOS + Xcode üzerinde hazırlanabilir.

## Güven ve kapsam

- Önce offline-first ve yerel veri; zorunlu giriş / ücret / API anahtarı yok.
- Gerçek öğrenci verisi yerine açıkça 'örnek' etiketli demo veya boş durum göster.
- YKS sınav tarihi, müfredat ve puan katsayılarını asla uydurma; resmî kaynak teyidi veya öğrenci ayarı gerektir.
- Varsayılan metin dili Türkçedir, altyapı ileride yerelleştirilebilir.
- Resimler web'den alınmadı, bu proje bağlamında üretildi; üçüncü taraf marka/stüdyo tarzını taklit etme.
