# Teknik mimari | Flutter / Offline-first

## Temel

Flutter, Dart null safety; Android + Web + Windows ilk hedef, ileride macOS/iOS test koşuluyla. Gerçek bir cihazda demo. Hafif tohum kodu üretim altyapısı değildir; görevler bunu sağlamlaştıracak.

## Önerilen yapı

```text
lib/
  main.dart
  app.dart
  core/theme/, core/content/, core/navigation/, core/errors/
  features/home/{domain,data,presentation}/
  features/topics/{domain,data,presentation}/
  features/exams/{domain,data,presentation}/
  features/analytics/{domain,data,presentation}/
  features/focus/{domain,data,presentation}/
  features/profile/{domain,data,presentation}/
  features/planning/{domain,data,presentation}/
  shared/widgets/, shared/utils/
assets/illustrations/scenes/
test/
```

Mimariyi sırf şema için onlarca boş dosyaya bölme. Kalıcı veri eklendiğinde platform uyumlu test edilmiş SQLite tercih edilir; drift / sqflite / ffi seçimi hedef platformlara göre gerekçelendirilip kurulmalı. Repositories ile yerel depolama arayüzü ayrılmalı. UI, data erişimi ve net matematiği ayrışmalı.

## Temel varlıklar

- `ExamSession(id,date,kind,subjectGroups,scope)`, `ExamResult(sessionId,subjectId,correct,wrong,blank,net)`
- `Subject`, `Topic`, `TopicProgress(topicId,status,questionCount,lastStudiedAt)`
- `DailyTask`, `DailyGoal`, `FocusSession`, `StudentPreferences`, `ExamCalendarEntry`
- Zaman türlerinde yerel tarih / zaman dilimi kararları net dokümante edilecek.
- Çekirdek hesap fonksiyonları UI'den bağımsız ve birim testli olmalı.

## Bağımlılık / güvenlik

- Minimum paket, `flutter pub get` uyumluluk kontrolü, bakımı devam eden kaynakları seç.
- Auth / Analytics / uzaktan servis varsayılan olarak ekleme.
- Yerel veriler için gizlilik, export/delete, kayıpsız migration ve restore testleri.
- İlave bulut bağlantısı açık opt-in olmadan yok.
- Kullanıcı verisi ve uygulama kaynaklarını ayır, varlık klasörünü runtime'da değiştirme.

## Performans

- Manzara resimleri WebP ve gerektiği kadar çözünürlükte decode; scrolling listelerde bitmap tekrar render'ından kaçın.
- Grafikler binlerce nokta ile çalışırken downsampling düşün; değişen tema/dil ile tutarlılık.
- İşlevsel teste ek golden/widget ve erişilebilirlik denetimi.
