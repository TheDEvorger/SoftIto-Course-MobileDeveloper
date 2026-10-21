# TASK-001 | Flutter platformları, derlenebilir başlangıç ve araç zinciri

**Durum:** TAMAMLANDI (Flutter 3.47.6, Dart 3.13.5, tüm platformlar oluşturuldu, analyze 0 issue, 7 test geçti, web release derlendi)

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/architecture/technical_plan.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Flutter/Dart sürümünü kaydet; eksik Android/Web/Windows platformlarını kullanıcı kodunu koruyarak `flutter create` ile oluştur. `flutter pub get`, `flutter analyze`, `flutter test` çalıştır. İlk mobil ekranı render edip widget ağacında resim yüklenmesini doğrula.

## Kabul kriterleri

Kullanıcıya ait `lib`, `test`, `pubspec`, kaynak MD ve PNG değiştirilmedi. Platformlar oluştu. Format, analyze, test gerçek çıktısıyla raporlandı. Chrome veya mevcut cihazda açılabiliyor.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
