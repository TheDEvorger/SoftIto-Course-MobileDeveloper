import 'package:flutter/material.dart';
import 'app/precision_app.dart';

/// Uygulamanın ana başlangıç noktası (Entrypoint).
void main() {
  // Flutter widget bağlayıcılarının başlatıldığından emin olunur.
  WidgetsFlutterBinding.ensureInitialized();
  // Kök uygulama bileşeni ayağa kaldırılır.
  runApp(const PrecisionApp());
}
