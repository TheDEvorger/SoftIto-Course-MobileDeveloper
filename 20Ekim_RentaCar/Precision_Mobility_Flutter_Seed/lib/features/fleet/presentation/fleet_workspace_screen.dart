import 'package:flutter/material.dart';
import '../../../shared/widgets/section_heading.dart';
import '../domain/demo_fleet_workspace.dart';

String fleetStatusLabel(FleetVehicleStatus status) =>
    status == FleetVehicleStatus.available ? 'Örnek uygun' : 'Örnek bakımda';
String fleetRoleLabel(FleetDemoRole role) => switch (role) {
      FleetDemoRole.viewer => 'Demo görüntüleyici',
      FleetDemoRole.operator => 'Demo operatör',
      FleetDemoRole.manager => 'Demo yönetici',
    };

class FleetWorkspaceScreen extends StatefulWidget {
  const FleetWorkspaceScreen({super.key, this.workspace});
  final DemoFleetWorkspace? workspace;
  @override
  State<FleetWorkspaceScreen> createState() => _FleetWorkspaceScreenState();
}

class _FleetWorkspaceScreenState extends State<FleetWorkspaceScreen> {
  late final _workspace = widget.workspace ?? DemoFleetWorkspace();
  String _message = 'Demo görüntüleyici: yalnızca okuma.';

  void _change(VoidCallback action, String message) => setState(() {
        action();
        _message = message;
      });

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final vehicles = _workspace.visibleVehicles;
        final maintenance = vehicles
            .where((v) => v.status == FleetVehicleStatus.maintenance)
            .length;
        return ListView(padding: const EdgeInsets.all(20), children: [
          const SectionHeading(
              title: 'Filo çalışma alanı',
              subtitle:
                  'DEMO • Gerçek kuruluş, çalışan veya araç yönetimi yok.'),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            isExpanded: true,
            key: const ValueKey('fleet-organization'),
            initialValue: _workspace.organizationId,
            decoration: const InputDecoration(labelText: 'Örnek kuruluş'),
            items: demoOrganizations.entries
                .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                .toList(),
            onChanged: (id) => _change(() => _workspace.selectOrganization(id!),
                'Kuruluş değişti; rol görüntüleyiciye ve şube tümüne sıfırlandı.'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            isExpanded: true,
            key: ValueKey('fleet-branch-${_workspace.organizationId}'),
            initialValue: _workspace.branchId ?? 'all',
            decoration: const InputDecoration(labelText: 'Örnek şube'),
            items: [
              const DropdownMenuItem(
                  value: 'all', child: Text('Tüm örnek şubeler')),
              for (final branch in demoBranches.entries)
                if (branch.value.$1 == _workspace.organizationId)
                  DropdownMenuItem(
                      value: branch.key, child: Text(branch.value.$2)),
            ],
            onChanged: (id) => _change(
                () => _workspace.selectBranch(id == 'all' ? null : id),
                'Örnek şube görünümü güncellendi.'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<FleetDemoRole>(
            isExpanded: true,
            key: ValueKey('fleet-role-${_workspace.organizationId}'),
            initialValue: _workspace.role,
            decoration: const InputDecoration(labelText: 'Rol simülasyonu'),
            items: FleetDemoRole.values
                .map((role) => DropdownMenuItem(
                    value: role, child: Text(fleetRoleLabel(role))))
                .toList(),
            onChanged: (role) => _change(() => _workspace.selectDemoRole(role!),
                'Rol simülasyonu değişti; gerçek yetki verilmez.'),
          ),
          const SizedBox(height: 16),
          Text('${vehicles.length} örnek araç • $maintenance örnek bakımda'),
          Semantics(liveRegion: true, child: Text(_message)),
          const SizedBox(height: 12),
          if (constraints.maxWidth >= 700)
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Örnek araç')),
                    DataColumn(label: Text('Şube')),
                    DataColumn(label: Text('Durum')),
                    DataColumn(label: Text('Demo işlem'))
                  ],
                  rows: [
                    for (final vehicle in vehicles)
                      DataRow(cells: [
                        DataCell(Text(vehicle.name)),
                        DataCell(Text(demoBranches[vehicle.branchId]!.$2)),
                        DataCell(Text(fleetStatusLabel(vehicle.status))),
                        DataCell(_action(vehicle)),
                      ])
                  ],
                ))
          else
            for (final vehicle in vehicles)
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.name),
                      Text(demoBranches[vehicle.branchId]!.$2),
                      Text(fleetStatusLabel(vehicle.status)),
                      _action(vehicle),
                    ]),
              )),
          const SizedBox(height: 16),
          const Text(
              'Veriler oturum belleğindedir. Kuruluş/rol seçimleri yalnızca '
              'arayüz demosudur; sunucu yetkilendirmesi yerine geçmez.'),
        ]);
      });

  Widget _action(FleetVehicle vehicle) => OutlinedButton(
        key: ValueKey('fleet-action-${vehicle.id}'),
        onPressed: !_workspace.canEdit
            ? null
            : () => _change(() => _workspace.toggleMaintenance(vehicle.id),
                '${vehicle.name} için örnek bakım durumu değiştirildi.'),
        child: const Text('Örnek bakım durumunu değiştir'),
      );
}
