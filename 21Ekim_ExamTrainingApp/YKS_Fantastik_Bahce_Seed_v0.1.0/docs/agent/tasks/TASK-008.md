# TASK-008 | Pomodoro ve odak geçmişi

**Durum:** TAMAMLANDI

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/design/screen_blueprints.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Ayarlanabilir 25/5 ve uzun mola, pause/resume/reset; gerçek wall-clock ile arka plana gitme davranışı; tamamlanan oturumu yerel kaydet. Orman kulübesi görseli ile odaklı kontrast.

## Kabul kriterleri

Widget+logic testler başarılı; tamamlama/değişen süre doğrulanıyor; kullanıcı istediğinde hareket azaltılıyor.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
