# MeHEnG · Değişmez mühendislik kuralları

MeHEnG Flutter uygulamasıdır. Ana alanlar Discover, Workspace,
Network, Growth; hepsi Venture kimliği üzerinden bağlanır.

## Çalışma protokolü
1. Yalnızca görevle ilgili belge ve dosyaları oku; `docs/INDEX.md` yol gösterir.
2. Her tur 1 küçük Task; keşif -> plan -> uygulama -> test -> kısa rapor.
3. **Bizim yazdığımız her dosya en fazla 250 satır. Hedef 80–200.**
4. `python tool/check_limits.py` denetimini her değişiklikte çalıştır.
5. Dart `flutter analyze`, `flutter test` ve gerekiyorsa manuel akış doğrulaması.
6. Test geçmeden görev tamamlandı deneme. Başarısızlığı dürüstçe kaydet.
7. SRP, SOLID, Clean Code, DRY, KISS, YAGNI, ISP, DIP, composition first.
8. UI -> view model/provider -> domain sözleşmesi -> repository -> data.
9. Feature iç detaylarına feature dışından import yapma.
10. Küresel core yalnızca gerçekten çapraz kesen yetenekleri içerir.
11. Yeni bağımlılık veya soyutlama için ADR gerekçesi yaz.
12. Özel girişim verileri default private. Açık paylaşım izni olmadan dışa gönderme.
13. Secrets, API keys, müşteri verileri, ödeme veya dağıtım için açık onay al.
14. Komutlarda zararlı wildcard silme, force push ve kontrolsüz migrasyon yapma.
15. Geriye dönük şema değişikliğinde migration + backup stratejisi gerekir.

## Agent disiplini
- Task ID'si/acceptance criteria olmadan geniş refactor yapma.
- Her seferinde `tasks/INDEX.md` ve ilgili task dosyasını oku.
- Skill kullanımı ihtiyaca özel; hepsini tek seferde context'e yükleme.
- Oturum bitince devam için kısa devretme notu `tasks/HANDOFF.md`ye yaz.
- Otomatik üretilen platform ve lock dosyalarını elle bölme/değiştirme;
  bu dosyalar için ayrı envanter raporla; yazdığımız dosyalar için istisna yok.
- Belirsiz iş kurallarını tahminle kalıcılaştırma, küçük ADR yaz veya sor.

Kaynak: `docs/architecture/overview.md`, `docs/design/tokens.md`.
