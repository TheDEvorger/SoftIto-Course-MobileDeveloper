# TASK-012 | Puan simülatörü kaynak doğrulama ve güvenli uygulama

**Durum:** BEKLIYOR (ajan gerçek sonuçtan sonra günceller)

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/product/content_and_exam_rules.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Orijinal görev puan simülatörü istiyor. Güncel ÖSYM puan/standartlaştırma/OBP kurallarının güvenilir kaynaklarını doğrula. Kesin puan hesaplanamıyorsa yüzdelik veya net temelli planlama göster ve açık kısıtı belirt; asla resmî puan diye uydurma.

## Kabul kriterleri

Hesap varsayımları ve yıl belirtilmiş, testli; resmî puan gibi yanıltmıyor, doğrulanmamış katsayı hardcode değil.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
