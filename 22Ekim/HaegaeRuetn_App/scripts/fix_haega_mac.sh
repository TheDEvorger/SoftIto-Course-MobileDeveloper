#!/usr/bin/env bash
# HægæRûetn: correct the two compile errors in the directory where this script is run.
set -euo pipefail

if [[ ! -f pubspec.yaml || ! -f lib/core/theme/realm_theme.dart || ! -f lib/features/guide/guide_screen.dart ]]; then
  echo "HATA: Uygulama klasöründe değilsin. pubspec.yaml bulunan proje klasörüne cd ile girip yeniden çalıştır." >&2
  exit 1
fi

echo "Proje klasörü: $(pwd)"
python3 - <<'PY'
from pathlib import Path
checks = [
    (Path('lib/core/theme/realm_theme.dart'), 'cardTheme: CardTheme(', 'cardTheme: CardThemeData('),
    (Path('lib/features/guide/guide_screen.dart'), 'ArtAssets.kronik', 'ArtAssets.chronicle'),
]
for p, bad, good in checks:
    source = p.read_text(encoding='utf-8')
    count = source.count(bad)
    if count:
        p.write_text(source.replace(bad, good), encoding='utf-8')
        print(f'DÜZELTİLDİ: {p} ({count} eşleşme)')
    elif good in source:
        print(f'ZATEN DOĞRU: {p}')
    else:
        raise SystemExit(f'Beklenen kod {p} dosyasında bulunamadı; farklı sürüm olabilir. Dosya değiştirilmedi.')
assert 'cardTheme: CardTheme(' not in Path('lib/core/theme/realm_theme.dart').read_text(encoding='utf-8')
assert 'ArtAssets.kronik' not in Path('lib/features/guide/guide_screen.dart').read_text(encoding='utf-8')
print('DOĞRULANDI: İki derleme hatasına neden olan eski ifadeler artık yok.')
PY

echo "\n--- Dosyalardaki yeni satırlar ---"
grep -n 'cardTheme: CardThemeData' lib/core/theme/realm_theme.dart
grep -n 'assetPath: ArtAssets.chronicle' lib/features/guide/guide_screen.dart

echo "\n--- flutter pub get ---"
flutter pub get

echo "\n--- flutter analyze ---"
flutter analyze || true

echo "\nDüzeltme tamamlandı. Uygulamayı başlat: flutter run -d chrome"
