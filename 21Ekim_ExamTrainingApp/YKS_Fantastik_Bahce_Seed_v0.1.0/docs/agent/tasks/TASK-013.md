# TASK-013 | Uçtan uca kalite, performans, görsel QA

**Durum:** TAMAMLANDI (Gerçek testler ve analizler 0 hata ile doğrulandı)

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/qa/quality_gates.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Tam test matrisi, küçük ekran, büyük yazı, tablette rail, light/dark, image cache, kontrast, offline ve kullanıcı veri güvenliği. Açık hata listesi ve düzeltme.

## Kabul kriterleri

flutter analyze temiz, tüm testler gerçek PASS, hedef cihazlarda açılış kanıtı/raporu ve kalan bilinen sınırlamalar var.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
