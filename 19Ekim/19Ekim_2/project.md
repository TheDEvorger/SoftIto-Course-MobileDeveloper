#Fitness su takip uygulaması
Bu doküman flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılım geliştiriciler için  bağlayıcı bir kılavuzdur. Projede üretilen bir kod satırı burdaki kurallara UYMAK ZORUNDADIR.


# Fitness Su takip Uygulaması

## 1.Proje Özeti ve Teknolojiler
- **Uygulama adı:** Susadım (akıllı su egzersiz ve kalori takibi uygulaması)

- **Hedef Platformlar:** İos ve android öncelikli ardından web ve masaüstü platformları.
- **Flutter SDK:** 3.29.0

- **Dart SDK:** 3.0.0
- **Tasarım dili:** Material 3, Çift Tema Desteği (Koyu Tema: gece spor salonu paleti, dark obsidian & neon teal; Aydınlık Tema: dinamik gün ışığı paleti, soft athletic cyan & fresh slate);
- **Tema Yönetimi:** Flutter yerel `ThemeMode` ve reaktif `ValueNotifier<ThemeMode>` (harici ağır paket kullanılmadan).

---

## 2. Mimari Yapı : Özellik bazlı
Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır. Çekirdek tema ve renk sistemleri `core/` altında konumlandırılır.

```text
lib/
core/
   constants/
      app_colors.dart         # Koyu ve Aydınlık renk paletleri & AppThemeColors uzantısı
   extensions/
      theme_extensions.dart   # BuildContext üzerinden context.colors ve tema kısayolları
   theme/
      app_theme.dart          # Material 3 Dark ve Light ThemeData tanımları
      theme_controller.dart   # ValueNotifier<ThemeMode> ile reaktif tema kontrolcüsü
features/
   water_tracker/
      controllers/
         water_tracker_controller.dart
      models/
         water_intake.dart
      view/
         water_tracker_view.dart
      widgets/
         activity_preview_card.dart
         hydration_progress_card.dart
         quick_add_button.dart
         recent_intakes_card.dart
         section_title.dart
   workout/
      controllers/
      models/
      view/
      widgets/
main.dart
```

#### Sadece uygulama başlatma, tema dinleyicisi ve kök widget bölümü

## 3.Kırmızı Çizgiler (Kesinlikle Uyulması Gerekenler)
1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına (`app_theme.dart` / `app_colors.dart`) yazılacaktır.
Arayüz bileşenlerinde sabit koyu/aydınlık renkler varsayılamaz; tema duyarlı `context.colors` veya `Theme.of(context)` kullanılmalıdır.
Büyük build metodları yasaktır; 40 satırı geçen build metotları özel widget'lara bölünecektir.

3 - **Yasaklı Paketler:**
Projeye onay almadan harici ağır paketler EKLENMEMELİDİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.


## 4.Geliştime analiz ve test komutları
Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik kod analizi(0 uyarı ve 0 hata şart):**
```bash
flutter analyze
'''

* ** Birim ve widget testleri:
```bash
flutter test
'''

* **Projeyi çalıştırma:
```bash
flutter run
'''


## 5 Ajanın çıktı ve yanıt verme standartları

**Açıklama:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sonra basma; hedef satırları ve diff yapısını göster.
**Dosya yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
**Doğrulama:** Kod yazdıktan sonra kullanıcıyı "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.
```