# TASK-007 | Gerçek net gelişim grafikleri ve analiz

**Durum:** TAMAMLANDI

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/qa/test_matrix.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Kayıtlı denemelerden tarih tabanlı çizgi grafikler, TYT/AYT ve ders filtreleri, tarih/seri tooltip, en az iki veri olmadan gerçek trend uydurma.

## Kabul kriterleri

Veri ekle/sil grafik güncellenir; sıralama doğru. Ekran okuyucu için alternatif metin/özet var; örnek rakam canlı veri gibi görünmez.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
