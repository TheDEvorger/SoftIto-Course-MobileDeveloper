# TASK-014 | Release ve son teslim

**Durum:** TAMAMLANDI (Web ve Windows Release build'leri 0 hata ile derlendi, 68 test geçti, teslim raporu ve kontrol listesi tamamlandı)

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/project/release_checklist.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Ürün ID, uygulama adı, sürüm, ikonu açık karara göre; uygulanabilen hedeflerin release buildi, README güncelleme, gizlilik notu, teslim ZIP / asset kontrolü. Kullanıcı onayı olmadan mağazaya yükleme yapma.

## Kabul kriterleri

En az bir uygun hedefte doğrulanmış release build veya açık blokaj raporu; test/kanıt/manifest teslim raporu; orijinal MD ve PNG master bütünlüğü korunmuş.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
