# generate_feature — Feature İskeleti Üretici Script

Bu script, `SKILL.md` (flutter-feature-scaffold) içindeki **Adım 1 → Adım 5** akışını otomatik uygular
ve `project.md` kurallarına uygun bir feature modülü + test iskeleti üretir.

---

## 1. Ne Üretir?

`./tool/generate_feature.sh water_tracker` çalıştırıldığında:

```text
lib/features/water_tracker/
  controllers/
    water_tracker_controller.dart   # ValueNotifier<WaterTrackerModel>
  models/
    water_tracker_model.dart        # immutable, copyWith / fromJson / toJson / == / hashCode
  view/
    water_tracker_view.dart         # lifecycle-only StatefulWidget + ValueListenableBuilder
  widgets/
    water_tracker_card.dart         # const StatelessWidget, renkler temadan
test/features/water_tracker/
  water_tracker_test.dart           # controller + model birim testleri, kart widget testi
```

Ardından otomatik olarak `dart format`, `flutter analyze` ve `flutter test` çalıştırır (`project.md` §4).

---

## 2. Kurallar ile Eşleşme

| Kural | Kaynak | Script'te nasıl sağlanıyor |
|---|---|---|
| Asla tek dosyada toplama | SKILL.md Temel Kurallar 1 | 4 ayrı katman dosyası + ayrı test dosyası |
| ValueNotifier state | SKILL.md Temel Kurallar 2, project.md §3.1 | Controller `ValueNotifier<Model>` kullanır, `setState` yok |
| const zorunluluğu | SKILL.md Temel Kurallar 3, project.md §3.2 | Tüm constructor ve statik widgetlar `const` |
| Build < 40 satır | project.md §3.2 | Şablonlardaki her build metodu kısa tutuldu |
| Renkler temadan | project.md §3.2 ve §3.4 | Sadece `Theme.of(context)` kullanılır, sabit renk yok |
| Karanlık / aydınlık mod | project.md §6 | View AppBar'ına `ThemeToggleButton` eklenir |
| Yasaklı paketler | project.md §3.3 | Sadece `flutter` ve `flutter_test` import edilir |
| Analiz ve test | project.md §4 | Script sonunda otomatik çalışır |
| Bellek sızıntısı yok | references/state_flow.md §3 | Controller `State.dispose` içinde dispose edilir |

---

## 3. Ön Koşullar

- Komut **Flutter proje kökünde** (`pubspec.yaml`'ın bulunduğu dizin) çalıştırılmalıdır.
- `lib/core/theme/theme_toggle_button.dart` mevcut olmalıdır (içerik: `project.md` §6).
- Feature adı **snake_case** olmalıdır: `water_tracker`, `workout`, `calorie_log`.

---

## 4. Kurulum

Aşağıdaki içeriği `tool/generate_feature.sh` olarak kaydedin ve çalıştırılabilir yapın:

```bash
chmod +x tool/generate_feature.sh
```

---

## 5. Script (`tool/generate_feature.sh`)

```bash
#!/usr/bin/env bash
# Kullanım: ./tool/generate_feature.sh <feature_name>
# Örnek  : ./tool/generate_feature.sh water_tracker
set -euo pipefail

# ---------------------------------------------------------------------------
# 0) Girdi ve ortam doğrulama
# ---------------------------------------------------------------------------
NAME="${1:-}"

if [[ ! "$NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "Hata: feature adı snake_case olmalı (örn: water_tracker)." >&2
  exit 1
fi

if [[ ! -f pubspec.yaml ]]; then
  echo "Hata: pubspec.yaml bulunamadı. Script'i proje kökünde çalıştırın." >&2
  exit 1
fi

if [[ ! -f lib/core/theme/theme_toggle_button.dart ]]; then
  echo "Hata: lib/core/theme/theme_toggle_button.dart yok. project.md §6'yı uygulayın." >&2
  exit 1
fi

PACKAGE="$(grep -m1 '^name:' pubspec.yaml | awk '{print $2}')"
PASCAL="$(echo "$NAME" | awk -F_ '{for (i = 1; i <= NF; i++) printf "%s%s", toupper(substr($i, 1, 1)), substr($i, 2)}')"
BASE="lib/features/$NAME"
TEST_DIR="test/features/$NAME"

if [[ -d "$BASE" ]]; then
  echo "Hata: $BASE zaten mevcut. Var olan feature'ın üzerine yazılmaz." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# 1) Klasör yapısı (SKILL.md Adım 1)
# ---------------------------------------------------------------------------
mkdir -p "$BASE"/{controllers,models,view,widgets} "$TEST_DIR"

# ---------------------------------------------------------------------------
# 2) Model (SKILL.md Adım 3) — immutable + copyWith/fromJson/toJson
# ---------------------------------------------------------------------------
cat > "$BASE/models/${NAME}_model.dart" <<EOF
import 'package:flutter/foundation.dart';

@immutable
class ${PASCAL}Model {
  const ${PASCAL}Model({this.id = '', this.value = 0});

  factory ${PASCAL}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL}Model(
      id: json['id'] as String? ?? '',
      value: json['value'] as int? ?? 0,
    );
  }

  final String id;
  final int value;

  ${PASCAL}Model copyWith({String? id, int? value}) {
    return ${PASCAL}Model(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'value': value,
      };

  @override
  bool operator ==(Object other) =>
      other is ${PASCAL}Model && other.id == id && other.value == value;

  @override
  int get hashCode => Object.hash(id, value);
}
EOF

# ---------------------------------------------------------------------------
# 3) Controller (SKILL.md Adım 2) — ValueNotifier, BuildContext yok
# ---------------------------------------------------------------------------
cat > "$BASE/controllers/${NAME}_controller.dart" <<EOF
import 'package:flutter/foundation.dart';

import '../models/${NAME}_model.dart';

class ${PASCAL}Controller {
  final ValueNotifier<${PASCAL}Model> state =
      ValueNotifier<${PASCAL}Model>(const ${PASCAL}Model());

  void increment([int step = 1]) {
    state.value = state.value.copyWith(value: state.value.value + step);
  }

  void reset() {
    state.value = const ${PASCAL}Model();
  }

  void dispose() {
    state.dispose();
  }
}
EOF

# ---------------------------------------------------------------------------
# 4) Widget (SKILL.md Adım 5) — const, renkler/yazılar temadan
# ---------------------------------------------------------------------------
cat > "$BASE/widgets/${NAME}_card.dart" <<EOF
import 'package:flutter/material.dart';

import '../models/${NAME}_model.dart';

class ${PASCAL}Card extends StatelessWidget {
  const ${PASCAL}Card({super.key, required this.model});

  final ${PASCAL}Model model;

  @override
  Widget build(BuildContext context) {
    final TextTheme texts = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text('\${model.value}', style: texts.headlineMedium),
        ),
      ),
    );
  }
}
EOF

# ---------------------------------------------------------------------------
# 5) View (SKILL.md Adım 4) — lifecycle-only StatefulWidget, setState YOK
# ---------------------------------------------------------------------------
cat > "$BASE/view/${NAME}_view.dart" <<EOF
import 'package:flutter/material.dart';

import '../../../core/theme/theme_toggle_button.dart';
import '../controllers/${NAME}_controller.dart';
import '../models/${NAME}_model.dart';
import '../widgets/${NAME}_card.dart';

class ${PASCAL}View extends StatefulWidget {
  const ${PASCAL}View({super.key});

  @override
  State<${PASCAL}View> createState() => _${PASCAL}ViewState();
}

/// setState ÇAĞRILMAZ. Bu State yalnızca controller ömrünü yönetir.
class _${PASCAL}ViewState extends State<${PASCAL}View> {
  final ${PASCAL}Controller _controller = ${PASCAL}Controller();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${PASCAL}'),
        actions: const [ThemeToggleButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ValueListenableBuilder<${PASCAL}Model>(
          valueListenable: _controller.state,
          builder: (context, model, _) => ${PASCAL}Card(model: model),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Artır',
        onPressed: _controller.increment,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
EOF

# ---------------------------------------------------------------------------
# 6) Test iskeleti (SKILL.md Adım 6 — Testability)
# ---------------------------------------------------------------------------
cat > "$TEST_DIR/${NAME}_test.dart" <<EOF
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:${PACKAGE}/features/${NAME}/controllers/${NAME}_controller.dart';
import 'package:${PACKAGE}/features/${NAME}/models/${NAME}_model.dart';
import 'package:${PACKAGE}/features/${NAME}/widgets/${NAME}_card.dart';

void main() {
  group('${PASCAL}Controller', () {
    late ${PASCAL}Controller controller;

    setUp(() => controller = ${PASCAL}Controller());
    tearDown(() => controller.dispose());

    test('başlangıç durumu varsayılan modeldir', () {
      expect(controller.state.value, const ${PASCAL}Model());
    });

    test('increment değeri artırır', () {
      controller.increment(5);
      expect(controller.state.value.value, 5);
    });

    test('reset durumu sıfırlar', () {
      controller
        ..increment()
        ..reset();
      expect(controller.state.value, const ${PASCAL}Model());
    });
  });

  group('${PASCAL}Model', () {
    test('JSON dönüşümü kayıpsızdır', () {
      const ${PASCAL}Model model = ${PASCAL}Model(id: 'a1', value: 3);
      expect(${PASCAL}Model.fromJson(model.toJson()), model);
    });

    test('copyWith sadece verilen alanı değiştirir', () {
      const ${PASCAL}Model model = ${PASCAL}Model(id: 'a1', value: 3);
      expect(model.copyWith(value: 9), const ${PASCAL}Model(id: 'a1', value: 9));
    });
  });

  testWidgets('${PASCAL}Card değeri hem aydınlık hem karanlık temada gösterir',
      (tester) async {
    for (final Brightness brightness in Brightness.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness, useMaterial3: true),
          home: const Scaffold(
            body: ${PASCAL}Card(model: ${PASCAL}Model(value: 7)),
          ),
        ),
      );
      expect(find.text('7'), findsOneWidget);
    }
  });
}
EOF

# ---------------------------------------------------------------------------
# 7) Format + doğrulama (project.md §4)
# ---------------------------------------------------------------------------
dart format "$BASE" "$TEST_DIR"
flutter analyze
flutter test "$TEST_DIR"

echo ""
echo "✅ '$NAME' feature'ı oluşturuldu: $BASE"
echo "   Şimdi flutter analyze ile kontrol edebilirsin."
```

---

## 6. Script Sonrası Manuel Adımlar

1. Model alanlarını (`id`, `value`) feature'ın gerçek verisine göre düzenle; `copyWith`, `fromJson`, `toJson`, `==`, `hashCode`'u birlikte güncelle.
2. Controller metotlarını (`increment`, `reset`) iş mantığına göre yeniden adlandır (örn. `addWater`, `resetWater`).
3. Kart widget'ının `build` metodu 40 satırı geçerse yeni widget'lara böl (`project.md` §3.2).
4. Ekranı **hem aydınlık hem karanlık** modda çalıştırıp kontrol et (`project.md` §3.4).
5. Son doğrulama:

```bash
flutter analyze
flutter test
```

---

## 7. Hata Mesajları

| Mesaj | Sebep | Çözüm |
|---|---|---|
| `feature adı snake_case olmalı` | Büyük harf, tire veya boşluk var | `WaterTracker` → `water_tracker` |
| `pubspec.yaml bulunamadı` | Yanlış dizin | Proje köküne geç |
| `theme_toggle_button.dart yok` | Tema altyapısı kurulmamış | `project.md` §6'daki dosyaları oluştur |
| `zaten mevcut` | Feature daha önce üretilmiş | Farklı ad seç veya mevcut feature'ı elle güncelle |
