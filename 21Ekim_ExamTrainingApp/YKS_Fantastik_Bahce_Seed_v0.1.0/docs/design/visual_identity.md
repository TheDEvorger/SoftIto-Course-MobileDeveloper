# GÖRSEL KİMLİK | Fantastik Bahçe Akademisi

## Mutabık kalınmış yaratıcı yön

Canlı, özgün, hafif anime-esintili fantastik doğa illüstrasyonları. Ayrıntılı orman, su, bahçe, ışık, taş, toprak ve altın fenerler. **Soluk, pudramsı pastel ekranlar istenmiyor.** Renkli sahneler; ancak görev giriş alanları ve metin yüzeyleri temiz, kontrastlı ve okunaklı kalmalı. Etkileşim alanlarında bol boşluk. Kullanıcı onaylı görünüm: `../../design/references/approved_ui_direction.png`. Çizimlerdeki görselleri birebir raster buton olarak kullanma; Flutter widget ile inşa et.

## Renk tokenları: marka paleti (hex)

| Token | HEX | Kullanım |
| --- | --- | --- |
| `inkPlum` | `#33263F` | Başlık, koyu tema yüzeyi, güçlü metin |
| `mossEmerald` | `#4F8A5B` | İlerleme, seçili hedef, doğa kimliği |
| `streamTurquoise` | `#5FA8A0` | Su / bilgi, ikincil seri |
| `peachCoral` | `#E88363` | Başla, Kaydet, ana eylem |
| `lavenderGlow` | `#B39DDB` | Analiz, fantastik ayrıntılar |
| `harvestGold` | `#C89B3C` | Başarı/özel durum, hedef parıltısı |
| `sproutMist` | `#F2F8E8` | Açık temanın genel zemini |
| `gardenPaper` | `#E9F2D8` | Açık kart ve küçük yüzeyler |
| `sandyPorcelain` | `#F6F1E8` | Yumuşak kontrast için sıcak yüzey |
| `lilyWater` | `#E7F4F2` | Su/odak alanları, ferah zemin |
| `lightSage` | `#DCEACC` | Seçili alan / filtre |
| `honeyLight` | `#F3E7BE` | Altın destek yüzeyi |

Not: Yeşillerin ve su tonlarının **canlı fotoğraf-olmayan anime manzara** görünümü assetlerde güçlü; UI yüzeylerine aynı doygunluğu zorla yayma. Beyaz ve nötr griyi ana sahne atmosferi yapmak yerine az kullan.

## Açık tema

Zemin `sproutMist`, kart `sandyPorcelain` / `gardenPaper`, metin `inkPlum`, aksiyon `peachCoral`, seçili `mossEmerald`, grafik çizgileri `lavenderGlow`, `streamTurquoise`, `peachCoral`, başarı `harvestGold`.

## Koyu tema

Omurga koyu mürdüm `#211928`; yüzey `#31233D`, kart `#3B2C47`, metin `#F8F2E8`, seçili hafif parlak yeşil `#A4D49B`, altın vurgu `#E4BC63`. Gece manzarası `moon_garden` kullanılabilir. Mobil okunaklılığı bozacak aşırı şeffaf veya karmaşık cam efektlerinden kaçın.

## Tipografi ve ikon

Türkçe karakterleri tam destekleyen okunaklı sistem yazı tipi. Ekran başlıkları vurgulu; metin içeriği düz sans. 8pt boşluk ölçeği; 12-20pt köşe yarıçapı; 44-48dp asgari dokunma alanı; 14sp altında kritik bilgi yok. Material/Lucide benzeri tutarlı ikon dili; görsel tasarım kolajından kırpılmış ikon yerine kod tabanlı ikon kullan.

## Görsel ve hareket

- İllüstrasyon ayrıntısı arka planda; üstüne okuyucu metin koyulursa güvenilir overlay veya opak yüzey zorunlu.
- Responsive `BoxFit.cover` + odağın kesilmemesine dikkat; çok küçük ekranda aşırı detaya boğma.
- Akışkan ancak azaltılabilir mikro animasyonlar; erişilebilirlik `disableAnimations`/reduce motion ayarı düşün.
- Maskot zorunlu MVP özelliği değil.
