# ANTIGRAVITY AGENT KURALLARI | Fantastik Bahçe YKS

Bu dosya Antigravity gibi kod ajanları için **bağlayıcı proje yönergesidir**.

## 0. Başlamadan önce MUTLAKA

1. `20_yks_calisma_uygulamasi.md` (kullanıcının orijinal ödevi)
2. `README.md`
3. `docs/agent/first-prompt.md`
4. `docs/agent/task_board.md`
5. `docs/product/product_spec.md`
6. `docs/design/visual_identity.md`, `docs/design/art_direction.md`, `docs/design/screen_blueprints.md`
7. `docs/architecture/technical_plan.md`, `docs/qa/quality_gates.md`
8. `design/references/approved_ui_direction.png` ve en az 3 özgün PNG manzara; asset manifestini incele.

## 1. Ödün verilmeyecek kurallar

- **Flutter (Dart) ana teknoloji**. Native platform yalnızca Flutter'ın gerektirdiği yerde; HTML sayfası / rastgele React uygulamasıyla değiştirme.
- Feature-first modüler, test edilebilir, SOLID/DRY/YAGNI; bileşenleri küçük tut. 300 satır üstüne çıkmaya başlayan dosyaları böl.
- Orijinal `20_yks_calisma_uygulamasi.md` dosyasına ASLA yazma, düzenleme, taşıma, silme.
- 10 sahnenin PNG ustalarını silme, birleştirme, yeniden üretme; WebP kopyalarını kullan, kaynakları koru.
- Sadece pastel / kurumsal mavi-gri dashboard tasarlama. **Canlı, anime esintili fakat özgün fantastik doğa illüstrasyonu + okunaklı arayüz**. Kullanıcı onaylı referansın RUHUNU koru.
- Prototip veri, gerçek ölçüm gibi gösterilmez. Mock veriye 'Örnek' etiketi. Tarih, puan katsayısı, başarı yüzdesi uydurulmaz.
- Net = doğru - yanlış/4 (ilgili uygulama kapsamı), doğru+yanlış+boş sınav sınırı içinde kalmalı.
- Sınav yılı/tarihi için resmî kaynağı teyit et veya kullanıcıdan ayar al; sabit, doğrulanmamış bir yıl kullanma.
- TYT/AYT ayrımını koru. AYT ders/oturumlarını alan seçiminden bağımsız tek sabit tablo olarak kurgulama.
- Kişisel veri yerelde saklanır. Bulut, reklam, takip SDK'sı, bildirim izni ve ücretli API otomatik ekleme.
- Gereksiz paket ekleme; güncel/uyumlu sürümü kontrol et. Secrets ekleme, görselleri ağ üzerinden indirme, remote code execution yapma.
- Her yeni iş özelliğinde erişilebilirlik, yükleme/boş/hata durumları, küçük ekran ve açık/koyu tema düşün.

## 2. Otonom çalışma döngüsü

`docs/agent/task_board.md` içindeki **ilk tamamlanmamış** görevi aç. Önkoşullarını ve kabul kriterlerini oku. Uygula → formatla → `flutter pub get` → `flutter analyze` → `flutter test` → gerekiyorsa `flutter build` → sonuçları `docs/project/progress.md` dosyasına kaydet → görev kutusunu tamamlandı olarak işaretle → sıradaki göreve geç. Kullanıcı açıkça başka şey istemedikçe arada onay isteme.

Bir kalite kapısı başarısızsa gerçek nedeni düzelt. Kesin olmayan iddia veya sahte PASS yazma. Ortam/bloker varsa net olarak bildir ve bir sonraki güvenli bağımsız işe geç; hiçbir zaman başarısız görevi 'tamamlandı' yapma.

## 3. İlk iş özel talimatı

TASK-001: platform klasörleri yoksa `flutter create` ile oluştur. Varsa kontrol et. Var olan `lib/`, `test/`, `pubspec.yaml`, kaynak resimlere zarar verme. Kullanıcı dosyalarını **asla destructive reset** ile yok etme.

## 4. Kapsam / değişiklik onayı

- 4-6 üst düzey ekran gereksinimi: 6 ana bölüm; telefonda 5 alt sekme + Odak'a kısayol. 6 bölümü 8 ayrı sürekli bottom-nav öğesi yapma.
- İçerik menüsünde `Günlük Plan` alt sayfası / Ana sayfa işlevi.
- Yeni uygulama adı, ücretli plan, kullanıcı hesabı, AI koçu, sosyal ağ, üçüncü taraf servisi gibi kapsam artışlarını onaysız zorunlu yapma.
- Giriş sözü: “Sen filizlen, biz toprağı besleriz.”
- Mizahi çıkış sözü: “Sen filizlen, hayat gübreyi zaten eksik etmiyor.” Kullanıcının tercihine bağlı, zorunlu pop-up değil.

## 5. İş günlüğü ve açıklık

Her görev bitiminde: değişen dosyalar, test komutları ve sonuçları, riskler, sonraki TASK ID. Büyük görsel farkları veya tutarsızlıkları `docs/project/decisions.md` içine işle. Güncel görsel ekran görüntüsü üretilebilir ama **asıl kaynak PNG'lerin yerine yazılmaz**.
