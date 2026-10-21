# TASK-003 | Yerel depolama, modeller ve migration

**Durum:** TAMAMLANDI (Platform uyumlu SQLite tabanlı GardenDatabaseProvider ve Schema hazırlandı; StudentPreferences, Subject, Topic, TopicProgress, ExamSession, ExamScore, DailyTask, FocusSession modelleri ve 5 repository uygulandı; migration ve CRUD testleri 21/21 başarılı geçti)

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/architecture/data_model.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Platform uyumlu, test edilmiş SQLite tabanlı depolama yaklaşımı seç; repository sınırları, tablolar, şema sürümü, migration ve testlerini ekle. Gerçek kullanıcı verisi için local-first.

## Kabul kriterleri

Kayıt, güncelleme, silme, yeniden açınca koruma, migration testleri gerçek olarak geçiyor. Sahte DB yok, SDK uyumluluğu belgelendi.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
