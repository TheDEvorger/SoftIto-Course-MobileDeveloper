---
name: flutter-feature-scaffold
description: VenaFlow Flutter demosu için feature-first ekran, model, controller, widget ve test iskeleti üretme yönergesi.
---

# Flutter Feature Scaffold | VenaFlow

## Ne zaman kullanılır?
Yeni Flutter özelliği/ekranı açarken: `dashboard`, `patient_intake`, `queue_management`, `sample_tracking`, `settings`.

## Bağlayıcı kaynak
Her zaman önce proje kökündeki `Project.md` dosyasını oku. Bu SKILL, oradaki kapsamı **genişletmez veya değiştirmez**. Eski `water_tracker`, `workout`, `calorie_tracker` vb. modülleri kullanma.

## 1. Klasör organizasyonu

```text
lib/features/<feature_name>/
  controllers/
    <feature_name>_controller.dart
  models/
    <feature_name>_model.dart   # gerçekten özelliğe özgü veri varsa
  views/
    <feature_name>_view.dart
  widgets/
    <feature_name>_card.dart
```

Paylaşılan `Patient`, `CollectionVisit`, `DemoSpecimen` gibi modelleri iki yerde kopyalama. Ortak veri `data/demo/` veya ilgili tek yetkili modülde tanımlanmalı. Her modülde boş dosya üretme zorunluluğu yok.

## 2. State ve yaşam döngüsü

- Ekran state'inde `ValueNotifier<T>` + `ValueListenableBuilder<T>` kullan.
- Modül verisi `DemoClinicStore` üzerinden paylaşılır; bir ekranda yapılan işlem diğerinde görülür.
- `Widget.build()` içinde state controller'ı oluşturma. Controller'ı gerektiğinde `initState`'te oluşturup `dispose` et veya üst kapsamdan constructor ile al.
- Tekrarlanan büyük `setState`, global mutable listeler, veri modelinin view içine gömülmesi yasak.
- Durum değişimini merkezi iş mantığı doğrulasın; view doğrudan örnek listenin içini değiştirmesin.

**Örnek controller:**

```dart
import 'package:flutter/foundation.dart';

class SearchControllerDemo {
  final ValueNotifier<String> query = ValueNotifier<String>('');

  void search(String text) => query.value = text.trim();

  void dispose() => query.dispose();
}
```

**Örnek view (kısa, derlenebilir iskelet):**

```dart
import 'package:flutter/material.dart';

class PlaceholderQueueView extends StatelessWidget {
  const PlaceholderQueueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kan Alma Sırası')),
      body: const Center(child: Text('Sıra listesi hazırlanıyor')),
    );
  }
}
```

Bu iskeleti final ekran olarak bırakma; `Project.md` kabul kriterlerindeki çalışan akışı uygula.

## 3. Model ve test yaklaşımı

- `final` alanlar, `const` constructor; immutable model yaklaşımı.
- `copyWith`, gerçekten güncelleme yapılan modellere eklenir.
- JSON serileştirme zorunlu değil: ilk sürümde kalıcı depolama bulunmuyor.
- `test/` altında en az durum geçişleri, sıra numarası benzersizliği ve widget navigasyon senaryoları.
- Widget metinleri ve durum etiketleri Türkçe, alan adları Dart stilinde İngilizce olabilir.

## 4. UI kontrol listesi

- [ ] Material 3 ve tema tokenları kullanıldı.
- [ ] Işık / karanlık / sistem modu çalışıyor.
- [ ] `const` fırsatları uygulandı.
- [ ] Dar ekran overflow yok; geniş ekran uyarlanıyor.
- [ ] Etkileşimli öğeler işlevsel, göstemelik düğme yok.
- [ ] Form doğrulama ve empty state var.
- [ ] Sadece kurgusal demo verileri ve klinik olmayan açıklama var.

## 5. Her özellik bitince

1. Dokunulan dosyaları kısa listele.
2. `flutter analyze` ve `flutter test` çalıştırabiliyorsan gerçek sonucunu ver.
3. Çalıştıramıyorsan nedenini açıkça söyle; başarılı olduğunu iddia etme.
4. Tek sonraki küçük adımı öner; açıklamayı Türkçe yap.
