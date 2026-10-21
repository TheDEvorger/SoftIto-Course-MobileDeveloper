# TASK-002 | Tasarım sistemi, illüstrasyon ve responsive bileşen

**Durum:** TAMAMLANDI (Tasarım sistemi bileşenleri: GardenPrimaryButton, GoldenActionButton, BotanicalIconButton, NatureSegmentedControl, GardenCard, ForestHeroCard, GoldenAchievementCard, WaterInfoCard, BotanicalSectionHeader, LeafProgressBar, OrganicProgressRing, SubjectProgressBadge, GardenExamScoreField, NatureSearchField, NatureFilterChip geliştirildi; 10 WebP sahne metadata API'ye bağlandı; 6 ana ekran yenilendi; 15/15 test geçti; web release derlendi)

## Önkoşul

`AGENTS.md`, `docs/agent/task_board.md`, `docs/design/visual_identity.md` okunmalı. Önceki uygun görevler tamamlanmış olmalı.

## Yapılacaklar

Renk tokenlarını kullan; onaylı UI yönündeki canlı anime-esintili bahçeyi ekranlarda Flutter bileşenlerine dönüştür. 10 WebP sahne manifestini asset API üzerinden erişilebilir yap. Alt nav/rail, banner, kart, düğme, boş/hata durumları, açık/koyu ve text-scale.

## Kabul kriterleri

En az Ana, Konular, Denemeler, Analiz, Profil, Odak ekranı uyumlu; 360px ve geniş ekran çalışıyor. Görseller hafif ve çevrimdışı. Kritik metin illüstrasyonla karışmıyor. Pastel tekdüze dashboard değil.

## Zorunlu kontrol ve kayıt

- `dart format lib test` (araç varsa)
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- UI görevi ise eldeki cihaz/simülatörde görünümü doğrula; mevcut değilse rapora yaz.
- Gerçek sonuç, komut ve değişen dosyaları `docs/project/progress.md` içine yaz.
- Sağlandıysa task board'da bu görevi `[x]` yap ve sonraki açık göreve otomatik ilerle.
- Başarısızsa tamamlandı deme; blokajı kaydet.
