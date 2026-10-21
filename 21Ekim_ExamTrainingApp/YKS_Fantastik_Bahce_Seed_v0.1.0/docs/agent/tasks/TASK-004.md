# TASK-004 | Öğrenci ayarları, YKS tarihi ve geri sayım

**Durum:** TAMAMLANDI (CountdownCalculator domain mantığı, YksCountdownCard canlı sayaç bileşeni, PreferencesDialog ayar ve sınav tarihi modalı eklendi; varsayılan uydurma süre kaldırıldı; HomeScreen ve ProfileScreen'e entegre edildi; 27/27 test geçti; web release derlendi)

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/product/content_and_exam_rules.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Profil ayarlarını kullanıcıya düzenlet. Gerçek YKS tarihini kullanıcı ayarıyla al (resmî doğrulama olmadan varsayılan tarih yok). Tarih/saat/timezone geri sayımını gerçek hesapla; gün/saat/dakika ve boş durum UI.

## Kabul kriterleri

Tarih girilmezse uydurma süre gösterilmiyor. Sayaç yaklaştıkça doğru, geçmiş tarih düzgün; testler var.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
