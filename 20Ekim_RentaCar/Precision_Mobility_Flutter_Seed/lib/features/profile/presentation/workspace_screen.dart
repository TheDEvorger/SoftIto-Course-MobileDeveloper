import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../../discovery/application/catalog_controller.dart';
import '../../bookings/application/reservation_controller.dart';
import 'workspace_access_panel.dart';
import 'workspace_overview.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen(
      {super.key,
      required this.api,
      required this.onExamples,
      required this.inventory,
      required this.reservations,
      required this.onSessionChanged,
      required this.themeMode,
      required this.onThemeChanged});
  final ApiClient api;
  final VoidCallback onExamples;
  final CatalogController inventory;
  final ReservationController reservations;
  final VoidCallback onSessionChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  @override
  Widget build(BuildContext context) => StudioPage(width: 1180, children: [
        const PageHeading(
            eyebrow: 'Kişisel alan / Ayarlar',
            title: 'Sizin alanınız. Sizin tercihleriniz.',
            description:
                'Çalışma alanınızı açın ve Precision deneyimini kendinize göre düzenleyin.'),
        const SizedBox(height: 32),
        if (widget.api.authenticated) ...[
          WorkspaceOverview(
              inventory: widget.inventory, reservations: widget.reservations),
          const SizedBox(height: 24),
        ],
        LayoutBuilder(builder: (context, constraints) {
          final connection = WorkspaceAccessPanel(
              api: widget.api,
              onChanged: widget.onSessionChanged,
              onExamples: widget.onExamples);
          final preferences =
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _appearance(context),
            const SizedBox(height: 20),
            _help(context),
          ]);
          if (constraints.maxWidth < 850 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.3) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  connection,
                  const SizedBox(height: 20),
                  preferences
                ]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: connection),
            const SizedBox(width: 24),
            Expanded(child: preferences)
          ]);
        }),
      ]);

  Widget _appearance(BuildContext context) => StudioPanel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Görünüm', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('Gününüzün ritmine uyan bir arayüz.'),
        const SizedBox(height: 20),
        Wrap(spacing: 10, runSpacing: 10, children: [
          for (final mode in [
            (ThemeMode.system, Icons.brightness_auto_outlined, 'Sistem'),
            (ThemeMode.light, Icons.light_mode_outlined, 'Açık'),
            (ThemeMode.dark, Icons.dark_mode_outlined, 'Koyu')
          ])
            ChoiceChip(
                label: Text(mode.$3),
                avatar: Icon(mode.$2, size: 18),
                selected: widget.themeMode == mode.$1,
                onSelected: (_) => widget.onThemeChanged(mode.$1)),
        ]),
      ]));

  Widget _help(BuildContext context) => StudioPanel(
      padding: 12,
      child: Column(children: [
        const ExpansionTile(
            leading: Icon(Icons.route_outlined),
            title: Text('İlk yolculuğunuzu planlayın'),
            children: [
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      'Araçlar → Araç ekle ile envanteri oluşturun. Keşfet '
                      'üzerinden araç ve tarih seçerek rezervasyon kaydı oluşturun. Sürüşlerim üzerinden kayıtları '
                      'görüntüleyebilir veya iptal edebilirsiniz. Araç düzenleme ekranından yayın durumunu ve kapalı tarihleri yönetebilirsiniz.')),
            ]),
        const ExpansionTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Veriler ve hizmetler'),
            children: [
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      'Örnek ve özel çalışma alanları ayrı SQLite dosyalarında '
                      'kalıcı olarak saklanır. Örnek araç adları, fiyatlar ve rezervasyonlar kurgusaldır. İptal edilen kayıtlar geçmişte tutulur. Müşteri kimliği, kart bilgisi '
                      've GPS verisi toplanmaz. Kimlik doğrulama, ödeme ve teslim hizmetleri henüz bağlı değildir.')),
            ]),
        Padding(
            padding: const EdgeInsets.all(16),
            child: Text('PRECISION / MOBILITY, REFINED.',
                style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.6,
                    color: Theme.of(context).colorScheme.onSurfaceVariant))),
      ]));
}
