# TASK-005 | TYT/AYT konu takip ve ders filtresi

**Durum:** TAMAMLANDI

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/design/screen_blueprints.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Ders/konu veri kümesi, ilgili yıl ve kaynak metadata; TYT/AYT ayrımı, arama, durum filtreleri, ilerleme ve tekrar. Kullanıcıdan gelen çizimlerin gezinme fikrini koru.

## Kabul kriterleri

Konu durumları kalıcı, oran doğru, arama/filtre çalışıyor. Eksik/kısmi veri durumları güvenli, yıl/kaynak belirtilmiş.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
