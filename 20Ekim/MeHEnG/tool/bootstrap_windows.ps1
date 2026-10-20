$ErrorActionPreference = 'Stop'
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw 'Flutter bulunamadi. Once Flutter SDK kur, flutter doctor -v calistir.'
}
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
  throw 'Python 3 bulunamadi. python --version ile kontrol et.'
}
Write-Host 'MeHEnG: generating Android and Windows platform scaffold...'
flutter create --project-name meheng --org com.meheng --platforms=windows,android .
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if (-not (Select-String -Path lib/main.dart -Pattern 'MehengApp' -Quiet)) {
  throw 'Seed main.dart beklenen icerik degil! Degisiklikleri inceleyin.'
}
flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
dart format lib test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
python tool/verify_seed.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host 'Bootstrap checks passed. Start with flutter run -d windows'
