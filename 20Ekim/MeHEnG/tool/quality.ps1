$ErrorActionPreference = 'Stop'
python tool/check_limits.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
python tool/verify_seed.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host 'Quality gates passed.'
