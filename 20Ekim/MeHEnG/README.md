# MeHEnG · Girişimcilik ekosistemi

**MeHEnG** dört bağlantılı alan üzerine kuruludur: Discover, Workspace,
Network, Growth. İlk çalışan dikey kesit: girişim + hipotez + deney + kanıt.

## Başlangıç
1. Windows'ta Flutter'ın kurulu ve PATH'te olduğundan emin olun.
2. ZIP'i açın. Klasörü Google Antigravity ile açın.
3. `START_HERE_TR.md` dosyasını okuyun.
   İsterseniz `tool/bootstrap_windows.ps1` ile tek seferde scaffold + test yapın.
4. Terminalde: `flutter create --project-name meheng --org com.meheng --platforms=windows,android .`
5. Ardından `flutter pub get`, `flutter run -d windows` (veya Android cihaz).
6. Antigravity ajanına `ANTIGRAVITY_PROMPT_TR.md` içeriğini gönderin.

## Şu an çalışan dilim
- Girişim ekleme ve listesi (SQLite, cihazda kalıcı).
- Hipotez, deney, olumlu/olumsuz/nötr kanıt ekleme.
- Seçilen girişimin iç içe doğrulama kayıtlarını inceleme.
- Masaüstü/mobil navigasyon; diğer modüllerin yol haritası.

## Sınırlar
- Flutter SDK bu ZIP'te yoktur. Platform iskeleti `flutter create` ile üretilir.
- Henüz bulut, mesajlaşma, gerçek hesap, AI, finans veya otomatik yayın yok.
- Web hedeflenmiyor; yerel sqlite3 Windows/Android için yapılandırıldı.
- Başlangıçta SQL senkron erişir; büyüyen veri için isolate/async geçişi gerekir.
- Flutter bu üretim ortamında bulunmadığı için build/test **çalıştırılamadı**.
- Özel veriler cihazda şifresiz SQLite'ta bulunur. Hassas üretim verisi eklemeyin.

## Belgeler
- `docs/INDEX.md`: ihtiyaca göre okunacak tekil tasarım kararları.
- `tasks/INDEX.md`: bağımlılık ve yürütme sırası.
- `.agents/skills/meheng-grow/SKILL.md`: adım adım büyütme protokolü.
- `tool/check_limits.py`: kullanıcı-yazımı tüm dosyalarda 250 satır sınırı.
