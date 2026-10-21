# Ajan çalışma prosedürü

1. Kanonik dosyaları oku; referans UI ve 10 manzarayı görsel olarak değerlendir.
2. `task_board.md` ilk açık TASK'ı seç, ilgili TASK dosyasında kabul kriterlerini doğrula.
3. Önce küçük plan yaz. Sadece ilgili ve bağımlı dosyaları düzenle, orijinal kullanıcı belgeleri ve PNG'leri değiştirme.
4. `dart format lib test` (varsa), `flutter pub get`, `flutter analyze`, `flutter test` çalıştır. Başarısızsa düzelt. UI görevi ise cihaz/simülatör önizlemesini mümkünse yakala ve referansla karşılaştır.
5. TASK kabul kriterlerini fiilen karşıladıysan görev kutusunu `[x]` yap. Değilse `[ ]` bırak ve sebebi raporla.
6. `docs/project/progress.md` içine zaman, komut, gerçek sonuç, değişen dosyalar, riskler, sonraki iş yaz.
7. Sıradaki göreve otomatik geç; kritik belirsizlik varsa `questions.md` içine kaydet, mümkün olan diğer bağımsız işe geç.
8. Güvenlik ihlali, destructive operasyon, ücretli üçüncü taraf servis, imzalama anahtarları / hesap erişimleri için açık kullanıcı onayı bekle.

**Örnek ilerleme satırı:** `TASK-003 | PASS | flutter analyze 0 issues; flutter test 24/24 | files: ... | next TASK-004`.

Böyle bir gerçek sonuç olmadan PASS yazma. Antigravity kendi ortamının yeteneklerini doğru raporlamalı.
