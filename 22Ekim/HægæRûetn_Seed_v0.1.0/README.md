# ⚔️ HægæRûetn

**Ałek’ryŧhæ Corporation gururla sunar.**

> "Kral öldü! Yaşasın yeni kral!" — *Tahtına kurulmadan önce bugünkü vazifelerini bitir, majesteleri.*

HægæRûetn, hayata geçirilen küçük alışkanlıkları fantastik bir dünyada ilerlemeye bağlayan Flutter uygulamasıdır. **6 çağ × 4 rütbe = 24 seviye**, **24 özel rozet**, günlük alışkanlıklar, kendi belirlediğin ahitler, yerel rehber prototipi ve krallık kronikleri içerir.

## Başlamak (macOS / Linux)

1. Flutter SDK kurulu ve `flutter doctor` çalışıyor olmalı.
2. ZIP'i açıp **bu klasörün kökünde** terminal aç.
3. `bash scripts/bootstrap.sh` çalıştır. Betik standart platform klasörlerini Flutter SDK ile üretir, bağımlılıkları yükler, format/analiz/test kontrollerini çalıştırır.
4. `flutter run -d chrome` veya `flutter run -d macos` komutunu kullan.

Windows PowerShell: `./scripts/bootstrap.ps1` ve ardından `flutter run -d windows`.

Elle kurulum:

```bash
flutter create --project-name haegaruuetn --platforms=android,ios,web,windows,macos,linux .
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome
```

**Neden `flutter create` gerekiyor?** Bu tohum projede üretici tarafından yönetilen Android, iOS, macOS, Windows, Linux ve Web platform kabukları henüz yok. İlgili Flutter sürümüyle doğru dosyaları oluşturması için Flutter CLI'ya bırakıldı. Mevcut `lib/` kodunu koru; `flutter create` sırasında `--overwrite` kullanma.

## Hazır olanlar

- 5 sekmeli gerçek Flutter navigasyonu: Vazifeler, Ahitler, Meydan, Rehber, Kronik.
- Alışkanlık ekle/düzenle/arşivle, günlük tamamla ve geri al, zorluk ve XP.
- Birden fazla alışkanlık için 3/7/14/30 **uyumlu gün** gerektiren ahitler, tek seferlik ödül.
- XP, hızlı düşebilen itibar, kazanılmış XP'yi koruyan geçici rütbe düşüşü.
- Planlı istirahat günü; o güne itibar cezası uygulanmaması.
- 6 aydınlık çağ paleti, 24 rütbe, 24 rozet tanımı. Bazı ileri rozetlerin koşulları sonraki aşamaya aittir.
- Flutter CustomPainter ile orijinal, kodla çizilmiş kale/manzara sahnesi.
- Arayüzde kutlama overlay'i; yeni rütbe veya rozet anında gösterim.
- İlk açılışta üç adet düzenlenebilir, tamamlanmamış **örnek alışkanlık**.
- `shared_preferences` ile cihazda yerel veri saklama.
- Yerel kural tabanlı demo rehber ve kurgusal meydan önizlemesi; **gerçek LLM veya toplulukmuş gibi sunulmaz**.

## Henüz bağlı olmayanlar

- Gerçek çok kullanıcıyla topluluk, doğrulanmış destek/erdem, moderasyon.
- İnternet üzerinden gerçek AI sohbeti ve API anahtarı/gizli bilgi yönetimi.
- İşletim sistemi planlı push bildirimleri, dinamik canlı arka planlar, ses, Rive/Lottie.
- Bulut yedekleme, kullanıcı girişi, çoklu cihaz senkronizasyonu, i18n.
- 24 rozetin tamamını otomatik açabilen ileri analitik görevler.

> **Dürüst kapsam:** Bu v0.1.0 ilk oynanabilir Flutter kaynağıdır. Bu hazırlama ortamında Flutter SDK bulunmadığından gerçek `flutter analyze`, `flutter test` veya cihaz derlemesi yapılmadı. Kurulum betiği bunları kullanıcı cihazında çalıştırır. Sonuçlar doğrulanmadan PASS raporlanmamalıdır.

## Veri ve gizlilik

Cihazdaki alışkanlıklar ve ahitler `shared_preferences` ile saklanır. Prototipte hiçbir sunucuya gönderim yoktur. `shared_preferences` yüksek hassasiyetli kayıtlar, şifre, access token veya ödeme verileri için uygun bir güvenli kasa değildir. Üretim aşamasında sürümlü yerel veri tabanı, veri dışa aktarma ve güvenli senkronizasyon eklenecek.

## Dosya haritası

```text
lib/
  main.dart
  app/hager_app.dart
  core/
    data/local_realm_store.dart
    models/{habit,pact,era,badge_definition}.dart
    services/{badge_engine,progression_engine,guide_service}.dart
    state/realm_controller.dart
    widgets/{realm_card,original_kingdom_art}.dart
  features/
    shell/realm_shell.dart
    habits/{habits_screen,habit_editor_sheet}.dart
    pacts/pacts_screen.dart
    plaza/plaza_screen.dart
    guide/guide_screen.dart
    chronicle/chronicle_screen.dart
AGENTS.md
README.md
docs/agent/first-prompt.md
docs/design/art-direction.md
docs/lore/world-and-vocabulary.md
docs/roadmap/tasks.md
archive/original_brief/23_aliskanlik_takibi.md
```

Kök proje ismi, Unicode dosya adı ve kullanım markası **HægæRûetn** olarak korunur. Dart `package` kimliği platform uyumu için ASCII `haegaruuetn` olarak yazılır. İsim ve 24'lü yapı üzerinde kullanıcı kararı olmadan değişiklik yapma.
