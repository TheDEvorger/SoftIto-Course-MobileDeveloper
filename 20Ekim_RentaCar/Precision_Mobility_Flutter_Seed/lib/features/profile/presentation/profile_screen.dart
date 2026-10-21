import 'package:flutter/material.dart';
import '../../../shared/widgets/section_heading.dart';

/// "Hesabım" profili ve ayarlar ekranı.
/// Tema modu seçimi (Sistem, Açık, Koyu) ve kimlik/gizlilik bilgilendirmelerini içerir.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.themeMode, required this.onThemeChanged});

  /// Seçili tema modu
  final ThemeMode themeMode;

  /// Tema modu değiştiğinde çağrılan geri çağırma
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24), children: [
      const SectionHeading(title: 'Hesabım',
        subtitle: 'Tema, doğrulama ve kişisel ayarlar'),
      const SizedBox(height: 20),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Görünüm', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('Sistem')),
              ButtonSegment(value: ThemeMode.light, label: Text('Açık')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Koyu')),
            ],
            selected: {themeMode},
            onSelectionChanged: (value) => onThemeChanged(value.first)),
        ]))),
      const SizedBox(height: 12),
      const Card(child: ListTile(leading: Icon(Icons.verified_user_outlined),
        title: Text('Kimlik doğrulama'),
        subtitle: Text('Henüz gerçek belge toplanmıyor'))),
      const Card(child: ListTile(leading: Icon(Icons.lock_outline),
        title: Text('Gizlilik'),
        subtitle: Text('Veriler ve izinler için tasarım aşaması'))),
    ]);
}
