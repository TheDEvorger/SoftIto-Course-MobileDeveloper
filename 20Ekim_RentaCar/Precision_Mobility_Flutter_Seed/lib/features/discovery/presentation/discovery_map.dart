import 'package:flutter/material.dart';
import '../domain/demo_vehicle.dart';

/// A schematic fixture view; positions are not coordinates or user locations.
class DiscoveryMap extends StatelessWidget {
  const DiscoveryMap(
      {super.key,
      required this.vehicles,
      required this.selected,
      required this.onSelected});
  final List<DemoVehicle> vehicles;
  final DemoVehicle? selected;
  final ValueChanged<DemoVehicle> onSelected;

  static const _positions = [
    Alignment(-0.65, -0.65),
    Alignment(0.55, -0.25),
    Alignment(-0.45, 0.35),
    Alignment(0.65, 0.75),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Şematik demo harita',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text(
            'Canlı harita ve GPS yok. İşaretlerin konumları temsilidir.'),
        const SizedBox(height: 12),
        SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColoredBox(
                  color: colors.surfaceContainerHighest,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ExcludeSemantics(
                          child: CustomPaint(
                        painter: _SchematicRoads(colors.outlineVariant),
                      )),
                      for (final vehicle in vehicles)
                        Align(
                          alignment: _positions[demoVehicles.indexOf(vehicle)],
                          child: Semantics(
                            selected: selected == vehicle,
                            child: IconButton.filledTonal(
                              key: ValueKey('map-${vehicle.name}'),
                              tooltip: '${vehicle.name} • '
                                  '${vehicle.isFleet ? 'Filo' : 'Bireysel'} • Örnek araç',
                              isSelected: selected == vehicle,
                              onPressed: () => onSelected(vehicle),
                              icon: const Icon(Icons.directions_car_outlined),
                              selectedIcon: const Icon(Icons.directions_car),
                            ),
                          ),
                        ),
                    ],
                  )),
            )),
        const SizedBox(height: 12),
        Semantics(
            liveRegion: true,
            child: Text(
              selected == null
                  ? '${vehicles.length} örnek araç • Bir işaret seçin.'
                  : 'Seçilen örnek: ${selected!.name}',
            )),
      ]),
    ));
  }
}

class _SchematicRoads extends CustomPainter {
  const _SchematicRoads(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 12;
    for (final fraction in [0.25, 0.5, 0.75]) {
      canvas.drawLine(Offset(size.width * fraction, 0),
          Offset(size.width * fraction, size.height), paint);
      canvas.drawLine(Offset(0, size.height * fraction),
          Offset(size.width, size.height * fraction), paint);
    }
  }

  @override
  bool shouldRepaint(_SchematicRoads oldDelegate) => color != oldDelegate.color;
}
