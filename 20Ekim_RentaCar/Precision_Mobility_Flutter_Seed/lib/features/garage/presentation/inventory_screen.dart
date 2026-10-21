import 'package:flutter/material.dart';
import '../../../core/theme/studio_colors.dart';
import '../../../shared/design/action_state.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../../discovery/application/catalog_controller.dart';
import '../../discovery/domain/vehicle.dart';
import '../../discovery/presentation/catalog_vehicle_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen(
      {super.key,
      required this.controller,
      required this.connected,
      required this.onConnect,
      required this.onManage,
      required this.onEdit});
  final CatalogController controller;
  final bool connected;
  final VoidCallback onConnect;
  final ValueChanged<Vehicle?> onEdit;
  final ValueChanged<Vehicle> onManage;
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _filter = 'all';
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller;
        final vehicles = state.vehicles
            .where((v) =>
                _filter == 'all' ||
                (_filter == 'published'
                    ? v.published && !v.inMaintenance
                    : _filter == 'unpublished'
                        ? !v.published
                        : v.inMaintenance))
            .toList();
        return StudioPage(children: [
          PageHeading(
              eyebrow: 'Çalışma alanı / Araçlar',
              title: 'Her araç, kontrolünüzde.',
              description:
                  'Koleksiyonunuzu düzenleyin. Fiyatları ve bakım durumlarını tek yerden yönetin.',
              action: FilledButton.icon(
                  onPressed: widget.connected
                      ? () => widget.onEdit(null)
                      : widget.onConnect,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Araç ekle'))),
          const SizedBox(height: 32),
          if (!widget.connected)
            ActionState(
                title: 'Koleksiyonunuza bir kapı açın.',
                message:
                    'Kayıtlı araçları yönetmek için Hesabım bölümünden çalışma alanınıza bağlanın.',
                icon: Icons.garage_outlined,
                action: widget.onConnect,
                label: 'Çalışma alanına bağlan')
          else ...[
            _summary(context, state.vehicles),
            const SizedBox(height: 30),
            Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 20,
                runSpacing: 12,
                children: [
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    for (final f in const [
                      ('all', 'Tüm araçlar'),
                      ('published', 'Yayında'),
                      ('unpublished', 'Yayında değil'),
                      ('maintenance', 'Bakımda')
                    ])
                      ChoiceChip(
                          label: Text(f.$2),
                          selected: _filter == f.$1,
                          onSelected: (_) => setState(() => _filter = f.$1)),
                  ]),
                  OutlinedButton.icon(
                      onPressed: () => state.load(workspace: true),
                      icon: const Icon(Icons.refresh, size: 17),
                      label: const Text('Envanteri yenile')),
                ]),
            const SizedBox(height: 24),
            if (state.loading)
              const LinearProgressIndicator()
            else if (state.error != null)
              ActionState(
                  title: 'Envanter yüklenemedi.',
                  message: state.error!,
                  icon: Icons.wifi_off_outlined,
                  action: () => state.load(workspace: true),
                  label: 'Yeniden dene')
            else if (vehicles.isEmpty)
              ActionState(
                  title: 'Koleksiyonunuzu oluşturun.',
                  message:
                      'Araç ekle ile araç bilgilerini ve günlük ücreti kaydedin.',
                  icon: Icons.add_road_outlined,
                  action: () => widget.onEdit(null),
                  label: 'Yeni araç ekle')
            else
              LayoutBuilder(
                  builder: (context, constraints) =>
                      constraints.maxWidth >= 900 &&
                              MediaQuery.textScalerOf(context).scale(1) < 1.4
                          ? _table(context, vehicles)
                          : CatalogGrid(
                              vehicles: vehicles,
                              onOpen: widget.onEdit,
                              onManage: widget.onManage,
                              manage: true)),
          ],
        ]);
      });

  Widget _summary(BuildContext context, List<Vehicle> vehicles) =>
      LayoutBuilder(
          builder: (context, constraints) =>
              Wrap(spacing: 16, runSpacing: 16, children: [
                for (final stat in [
                  (
                    vehicles.length,
                    'Koleksiyondaki araç',
                    StudioColors.lilac,
                    StudioColors.violet,
                    Icons.garage_outlined
                  ),
                  (
                    vehicles
                        .where((v) => v.published && !v.inMaintenance)
                        .length,
                    'Yayında',
                    StudioColors.mint,
                    StudioColors.forest,
                    Icons.check_circle_outline
                  ),
                  (
                    vehicles.where((v) => v.inMaintenance).length,
                    'Bakımda',
                    StudioColors.peach,
                    StudioColors.coral,
                    Icons.build_outlined
                  ),
                ])
                  SizedBox(
                      width: constraints.maxWidth < 600
                          ? constraints.maxWidth
                          : (constraints.maxWidth - 32) / 3,
                      child: StudioPanel(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? null
                              : stat.$3,
                          child: Row(children: [
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text('${stat.$1}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall),
                                  const SizedBox(height: 5),
                                  Text(stat.$2),
                                ])),
                            Icon(stat.$5,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? null
                                    : stat.$4,
                                size: 28)
                          ]))),
              ]));

  Widget _table(BuildContext context, List<Vehicle> vehicles) => StudioPanel(
      padding: 8,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              horizontalMargin: 20,
              columnSpacing: 24,
              dataRowMinHeight: 72,
              dataRowMaxHeight: 80,
              columns: const [
                DataColumn(label: Text('Araç')),
                DataColumn(label: Text('Kaynak')),
                DataColumn(label: Text('Günlük ücret')),
                DataColumn(label: Text('Durum')),
                DataColumn(label: Text('İşlem'))
              ],
              rows: [
                for (final v in vehicles)
                  DataRow(cells: [
                    DataCell(SizedBox(
                        width: 220,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Text(v.category,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11))
                            ]))),
                    DataCell(Text(v.isFleet ? 'Filo' : 'Bireysel')),
                    DataCell(Text(v.rateLabel)),
                    DataCell(Text(v.statusLabel)),
                    DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          tooltip: 'Aracı düzenle',
                          onPressed: () => widget.onEdit(v),
                          icon: const Icon(Icons.edit_outlined, size: 20)),
                      IconButton(
                          tooltip: 'Takvim ve yayın',
                          onPressed: () => widget.onManage(v),
                          icon: const Icon(Icons.calendar_month_outlined,
                              size: 20))
                    ])),
                  ])
              ])));
}
