@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo [HATA] Flutter PATH icinde bulunamadi.
  pause
  exit /b 1
)
call flutter pub get
if errorlevel 1 (pause & exit /b 1)
call flutter run -d chrome
pause
