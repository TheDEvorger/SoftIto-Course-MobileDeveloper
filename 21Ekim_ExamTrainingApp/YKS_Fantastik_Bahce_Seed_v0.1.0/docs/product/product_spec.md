# Ürün Şartnamesi | v0.1.0

## Kaynak ve niyet

**Kullanıcının birincil talimatı**: `../../20_yks_calisma_uygulamasi.md`. Dosya ham haliyle korunur. Kaynaktaki temel amaç: üniversite adaylarının TYT-AYT netlerini, konu eksiklerini, soru hedeflerini ve YKS geri sayımını yönetmek. Hedef: disiplin, net trendleri, eksik konulara yönelme. 4-6 ana ekran önerilmiş.

Kullanıcıyla yapılan arayüz görüşmelerinden gelen **ek kararlar**, kaynak MD'ye sonradan eklenmiş gibi gösterilmemelidir; ayrı gereksinim olarak aşağıda tutulur.

## MVP ürün akışları

1. İlk açılış: veri mahremiyetine saygılı yerel profil; TYT/AYT tercihi ve isteğe bağlı hedef; sınav tarihi kullanıcı ayarı veya doğrulanmış kaynakla yönetilsin.
2. Ana sayfa: kişisel karşılama + gerçek geri sayım (tarih varsa), günlük görevler, hedef ilerlemesi, son deneme varsa net bilgisi, Odak başlatma.
3. Konular: TYT/AYT, ders → konu alt sayfası, tamamlandı / üzerinde çalışıyor / eksik durumları, isteğe bağlı soru sayısı ve tekrar kaydı, aranabilir/filtrelenebilir.
4. Denemeler: tarih, tür, kapsam ve ders başına doğru/yanlış/boş; net otomatik hesap, doğrulama, düzenle-sil, tarihsel kayıt. Net matematiği domain testli.
5. Analiz: TYT/AYT ayrı; zaman bazlı net artışı/azalışı, ders serileri, boş veri ve az veri durumları. Gelişmiş istatistik sonraki aşama.
6. Odak / Pomodoro: ayarlanabilir oturum/mola, başlat-duraklat-sıfırla; biten oturumu yerel tarihe kaydet. Arka planda doğru zaman davranışı test edilsin.
7. Profil: alan, hedef, tema, yerel veri dışa aktarma / silme seçenekleri zamanla eklensin.
8. Günlük Plan: ana sayfadan erişilen görev alt sayfası; tamamla, geri al, günlük soru hedefi.

## Bilgi mimarisi

**Alt gezinme (telefon):** Ana Sayfa, Konular, Denemeler, Analiz, Profil (5 sekme). **Odak** altıncı işlevsel ekran olup ana sayfa aksiyonundan veya plan içinden açılır. **Geniş ekranda** NavigationRail. Günlük Plan, ana sayfanın alt sayfasıdır. Alt sekme sayısını artırma.

## MVP sonrası, zorunlu değil

- Konular arası bağlantıları gösteren doğrulanmış önkoşul/konu haritası.
- Gelişmiş tekrar önerileri, kapsamlı özel istatistikler.
- Puan simülatörü: orijinal MD'de gereklilik. **Güvenilir ve yıl uyumlu ÖSYM yöntem/katsayıları teyit edilmeden resmî veya kesin puan gösterilmez**. İlk aşamada açıkça 'tahmin, resmî sonuç değil' yaklaşımı veya sadece net odaklı geliştirme.
- Bulut eşitleme, maskot gelişimi, animasyonlar yalnızca onaylı genişlemeler olarak.

## Ürün tonu

- Giriş: “Sen filizlen, biz toprağı besleriz.”
- İsteğe bağlı mizahi veda: “Sen filizlen, hayat gübreyi zaten eksik etmiyor.”
- Destekleyici; düşük netlerde utandırıcı ifadeler veya suçlayıcı mesajlar yok.

## Veri ve erişilebilirlik

- Local-first; uygulama internetsiz temel işlev görmeli.
- Türkçe varsayılan ve Türkçe karakterler düzgün.
- Mümkünse 360px ve üstü telefon genişliği, tablet genişliği, text scaling, yüksek kontrast ve screen-reader semantics.
- Başarılı/başarısız/boş durum yalnızca renkle anlatılmaz.
