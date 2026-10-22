# TASK-009 | Günlük plan ve soru hedefi

**Durum:** TAMAMLANDI

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/product/product_spec.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Günlük görev oluşturma, konuyla ilişki kurma, miktar hedefi, tamamla/geri al, tarih seçme ve ana sayfa özeti.

## Kabul kriterleri

Görev ekleme/değiştirme/silme/tamamlama gerçekten çalışıyor; yüzde hesap doğru ve kalıcı.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
