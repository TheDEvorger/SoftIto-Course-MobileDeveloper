# Antigravity'ye ilk mesaj: VenaFlow

Bu klasördeki `Project.md` ve `.agents/skills/SKILL.md` dosyalarını **önce eksiksiz incele**; ikisini proje standartları olarak uygula.

**Ödev konusu değişti.** Artık fitness/su takip uygulaması yapmıyoruz. Yeni ürünümüz, çalışan bir demo olması hedeflenen **VenaFlow: Kan Alma Sıra ve Numune Takip Uygulaması**. Kullanıcı kitlesi kan alma birimi personeli; gerçek sağlık verisi kullanmıyoruz. Eski fitness modüllerini yeni projeye taşıma.

**Teknoloji sınırı:** Hocamızın yaklaşımına sadık kal: Flutter, Dart, Material 3, `ValueNotifier`/`ValueListenableBuilder`, feature-first klasörleme. Dışarıdan paket, Firebase, backend, API, veritabanı veya karmaşık state kütüphanesi ekleme. Taslakta Flutter 3.15.1 ve Dart 3.6.0 sürümleri bir arada yazılmış; bunun uyumsuzluğunu düzeltmek için gerçek kurulu SDK çiftini kontrol et. Sürümü otomatik değiştirme.

**Görsel hedef:** Kurumsal sağlık paneli kalitesinde, ferah, sofistike, özgün arayüz. Açık zeminde teal (`#087F8C`), lacivert (`#143348`), sakin açık yüzeyler, amber ve mercan vurgular. Aydınlık/karanlık/sistem temaları. Mobil odaklı, tablette/webde responsive. Arayüz tamamen Türkçe olsun.

**İşlev hedefi:** Demo hasta kaydı oluşturma, otomatik sıra numarası, sıra listesi, hasta çağırma, işlem durumu geçişleri, kurgusal numune takibi, dashboard özetinin otomatik güncellenmesi, arama/filtreleme, tema değiştirme ve demo verisini sıfırlama. Göstermelik buton veya sabit sayaç istemiyorum.

**İş akışın:**
1. Çalışma klasörünü/Flutter kurulumunu kontrol et ve kaynak durumunu açıkla.
2. 5-7 maddelik gerçekçi mimari ve ekran planı ile başlayıp ardından uygulamayı geliştir.
3. Önce tema/navigasyon, sonra merkezi mock store, ardından her çalışan özelliği ekle.
4. Unit/widget testlerini yaz; `flutter analyze` ve `flutter test` sonuçlarını gerçek biçimde bildir.
5. Teknik kararları ve yapılan değişiklikleri Türkçe, kısa ve anlaşılır anlat.

Ürün bir **eğitim demosudur**, gerçek klinikte kullanılacak tıbbi yazılım gibi tanıtma.
