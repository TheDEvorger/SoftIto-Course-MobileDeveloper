import 'package:flutter/material.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../shared/widgets/precision_search_field.dart';
import '../../../shared/widgets/precision_empty_state.dart';
import '../domain/demo_vehicle.dart';
import 'vehicle_card.dart';
import 'discovery_map.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});
  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String _query = '';
  bool _fleetOnly = false;
  bool _showMap = false;
  DemoVehicle? _selected;

  @override
  Widget build(BuildContext context) {
    final filtered = demoVehicles
        .where((vehicle) =>
            vehicle.name.toLowerCase().contains(_query.trim().toLowerCase()) &&
            (!_fleetOnly || vehicle.isFleet))
        .toList();
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 900;
      final map = DiscoveryMap(
        vehicles: filtered,
        selected: _selected,
        onSelected: (vehicle) => setState(() => _selected = vehicle),
      );
      final results = CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          sliver: SliverToBoxAdapter(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                title: 'Sürüşünüzü keşfedin',
                subtitle:
                    'Örnek araçlar • Gerçek konum veya fiyat kullanılmıyor',
              ),
              const SizedBox(height: 20),
              PrecisionSearchField(
                  label: 'Araç adı ara',
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                      _selected = null;
                    });
                  }),
              const SizedBox(height: 8),
              FilterChip(
                label: const Text('Yalnızca filo araçları'),
                selected: _fleetOnly,
                onSelected: (value) => setState(() {
                  _fleetOnly = value;
                  _selected = null;
                }),
              ),
              if (!wide) ...[
                const SizedBox(height: 12),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                        value: false,
                        label: Text('Liste'),
                        icon: Icon(Icons.view_list_outlined)),
                    ButtonSegment(
                        value: true,
                        label: Text('Harita'),
                        icon: Icon(Icons.map_outlined)),
                  ],
                  selected: {_showMap},
                  onSelectionChanged: (value) =>
                      setState(() => _showMap = value.single),
                ),
              ],
              const SizedBox(height: 16),
              Semantics(
                  liveRegion: true,
                  child: Text(
                    'Koleksiyon • ${filtered.length} örnek araç',
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
            ],
          )),
        ),
        if (!wide && _showMap)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverToBoxAdapter(child: map),
          ),
        if (filtered.isEmpty)
          const SliverToBoxAdapter(
              child: PrecisionEmptyState(
            title: 'Araç bulunamadı',
            message: 'Arama metnini veya filo filtresini değiştirin.',
          )),
        if (wide || !_showMap)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverLayoutBuilder(builder: (context, constraints) {
              final columns = constraints.crossAxisExtent >= 600 ? 2 : 1;
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var column = 0; column < columns; column++) ...[
                          if (column > 0) const SizedBox(width: 12),
                          Expanded(
                              child: row * columns + column < filtered.length
                                  ? VehicleCard(
                                      vehicle: filtered[row * columns + column])
                                  : const SizedBox.shrink()),
                        ],
                      ],
                    ),
                  );
                }, childCount: (filtered.length / columns).ceil()),
              );
            }),
          ),
      ]);
      if (!wide) return results;
      return Row(key: const ValueKey('discovery-split'), children: [
        Expanded(flex: 3, child: results),
        Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 24, 20, 24),
              child: map,
            )),
      ]);
    });
  }
}
