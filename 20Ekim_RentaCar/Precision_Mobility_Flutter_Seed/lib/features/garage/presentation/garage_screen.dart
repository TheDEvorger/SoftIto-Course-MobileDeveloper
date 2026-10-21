import 'package:flutter/material.dart';

/// Garaj / Filo sekmesi için yer tutucu kabuk ekran.
/// Özellikler arası doğrudan bağımlılık oluşturmamak için dışarıdan enjekte edilen
/// çalışma alanı (workspace) bileşenini görüntüler (Dependency Injection).
class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key, required this.workspace});

  /// Görüntülenecek çalışma alanı widget'ı
  final Widget workspace;

  @override
  Widget build(BuildContext context) => workspace;
}
