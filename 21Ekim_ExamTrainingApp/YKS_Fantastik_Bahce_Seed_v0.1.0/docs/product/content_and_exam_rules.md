# İçerik ve YKS kuralları

- İlk kullanıcı MD'sinde YKS geri sayımı, TYT/AYT, ders-konu tamamlama yüzdesi, deneme neti/puan simülatörü, grafik ve Pomodoro var. Orijinal maddelerde literal `\n` kaçış dizisi bulunuyor; dosyayı **değiştirme**, maddeleri bu belgede ayrı işlevler olarak yorumla.
- Net formülü: doğru - yanlış / 4. Toplam soru sınırını aşan giriş reddedilir. Boş = soru sayısı - doğru - yanlış (tam denemede). Kısmi deneme / branş denemesinde oturumun gerçek soru sayısı kullanıcı tarafından tanımlanabilir.
- TYT örnek soru dağılımı 40 Türkçe, 20 Sosyal, 40 Matematik, 20 Fen, ancak gerçek oturum türüne göre içerik ve yıllar doğrulanmalı; örnek veri resmi canlı kaynak diye sunulmamalıdır.
- AYT soru grupları öğrencinin alanına ve ilgili testlere göre değişir. Sayısal/eşit ağırlık/sözel seçenekleri bir başlıkla çözülemez; model test gruplarını ve alanı ayrı tanımlamalıdır.
- Gün/saat geri sayımı öğrenci takvim yılına ve saat dilimine göre doğru hesaplanmalı; `256 gün` gibi mock sabit yazma.
- Çizimlerde veya referans UI görselinde görünen isimler, netler, tarihler, hedefler **temsili tasarım verisidir**; başlangıç kullanıcı verisi değildir.
- Sınav puan türleri ve OBP katsayıları resmî, güncel rehber doğrulanmadan kesin hesaplama gibi yayınlanamaz.
- Tam müfredat/konu listesi farklı yıllar arasında değişebileceği için sürümlenmiş lokal JSON üzerinden sunulmalı, kaynak ve yıl metadata'sı tutulmalıdır.
