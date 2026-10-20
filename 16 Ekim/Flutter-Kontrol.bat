@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (echo Flutter bulunamadi & pause & exit /b 1)
call flutter pub get
if errorlevel 1 (pause & exit /b 1)
call flutter analyze
if errorlevel 1 (echo ANALYZE HATALI & pause & exit /b 1)
call flutter test
pause
