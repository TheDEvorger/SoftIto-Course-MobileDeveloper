$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) { throw 'Flutter SDK bulunamadi.' }
flutter create --project-name haegaruuetn --platforms=android,ios,web,windows,macos,linux .
if ($LASTEXITCODE -ne 0) { throw 'flutter create hata verdi.' }
flutter pub get
if ($LASTEXITCODE -ne 0) { throw 'flutter pub get hata verdi.' }
dart format lib test
flutter analyze
if ($LASTEXITCODE -ne 0) { throw 'flutter analyze hata verdi.' }
flutter test
if ($LASTEXITCODE -ne 0) { throw 'flutter test hata verdi.' }
Write-Host 'Hazir! flutter run -d chrome veya flutter run -d windows'
