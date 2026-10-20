# MeHEnG · Tohumu Çalıştır (Windows / Antigravity)

## 1. Flutter'ı doğrula
PowerShell'de `flutter doctor -v` çalıştır.
Windows için Visual Studio Desktop development with C++ bileşenleri gerekir.
Android için Android SDK/emülatör gereklidir.

## 2. Platform dosyalarını üret
ZIP içindeki `MeHEnG` klasörüne girip sırayla:

```powershell
flutter create --project-name meheng --org com.meheng --platforms=windows,android .
flutter pub get
dart format lib test
python tool/check_limits.py
flutter analyze
flutter test
flutter run -d windows
```

`flutter create` mevcut dosyayı değiştirmeye çalışırsa farkları denetle;
`--overwrite` kullanma. Platform dizinleri bu ZIP'e konulmadı.

## 3. Antigravity ile büyüt
1. Proje kök klasörünü Antigravity'de aç.
2. `ANTIGRAVITY_PROMPT_TR.md` metnini ilk Agent sohbetine yapıştır.
3. Varsa `/meheng-grow` Skill'ini çağır.
4. Agent tek görev seçsin, uygulasın, test etsin, raporlasın.
5. Uygun gördüğün sonraki görev için devam etmesini iste.

## Önemli
- Agent kendiliğinden sınırsız veya arka planda çalışmaya devam etmez.
- Oturum, araç izinleri, token bütçesi ve onaylar sınır koyar.
- Paket otomatik ajans tetikleyicisi değil, tekrarlanabilir gelişim planıdır.
- Görev bittiğinde `tasks/active` -> `tasks/done` taşı, INDEX'i güncelle.
- Güvenlik için ağ hesabı/dağıtım/yayın/ücretli API işlemleri açık onaya tabi.

## Kolaylaştırılmış PowerShell
İstersen proje kökünde `powershell -ExecutionPolicy Bypass -File tool/bootstrap_windows.ps1`
çalıştır. Bu dosya platform iskeleti + kalite kontrollerini sırayla yürütür.
Yürütmeden önce içeriğini incele; mevcut dosyalarla çatışmada dur ve denetle.
