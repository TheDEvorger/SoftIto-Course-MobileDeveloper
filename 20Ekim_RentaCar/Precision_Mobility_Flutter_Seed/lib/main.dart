import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'app/rental_app.dart';

/// Uygulamanın ana başlangıç noktası (Entrypoint).
void main() {
  // Flutter widget bağlayıcılarının başlatıldığından emin olunur.
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['Roboto'],
        await rootBundle.loadString('assets/fonts/Roboto_LICENSE.txt'));
  });
  // Kök uygulama bileşeni ayağa kaldırılır.
  runApp(const RentalApp());
}
