# TASK-011 | Konu ilişkileri haritası ve tekrar

**Durum:** TAMAMLANDI (Gerçek testler ve analizler 0 hata ile doğrulandı)

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/design/screen_blueprints.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Çizimdeki node graph fikrini ayrı alt sayfada uygula; doğrulanmamış önkoşul bağlarını uydurma. Harita/erişilebilir liste modu, tekrar önerisi mekanizmasını sade tut.

## Kabul kriterleri

Düğümler anlamlı konuya gider; alt yazı/listesi var; bağlantılar kaynaklı/veri setli; 360px performans iyi.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
