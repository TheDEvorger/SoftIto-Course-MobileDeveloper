#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter komutu bulunamadi. Once Flutter SDK kur ve flutter doctor calistir." >&2
  exit 1
fi
flutter create --project-name haegaruuetn --platforms=android,ios,web,windows,macos,linux .
flutter pub get
dart format lib test
flutter analyze
flutter test
printf '\nHazir! Cihaz listesi: flutter devices\nBaslat: flutter run -d chrome\n'
