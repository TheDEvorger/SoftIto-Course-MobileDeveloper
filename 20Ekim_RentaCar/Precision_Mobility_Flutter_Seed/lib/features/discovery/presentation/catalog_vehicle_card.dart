import 'package:flutter/material.dart';
import '../../../shared/design/studio_page.dart';
import '../domain/vehicle.dart';
import 'collection_artwork.dart';

class VehiclePhoto extends StatelessWidget {
  const VehiclePhoto({super.key, required this.vehicle});
  final Vehicle vehicle;
  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
          aspectRatio: 1.75,
          child: vehicle.example && vehicle.artwork.isNotEmpty
              ? CollectionArtwork(tone: vehicle.artwork, name: vehicle.name)
              : vehicle.photoUrl.isEmpty
                  ? _missing(context, false)
                  : Image.network(vehicle.photoUrl,
                      fit: BoxFit.cover,
                      semanticLabel: '${vehicle.name} fotoğrafı',
                      errorBuilder: (_, __, ___) => _missing(context, true))));

  Widget _missing(BuildContext context, bool failed) => Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest),
      child: LayoutBuilder(
          builder: (context, constraints) =>
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.directions_car_outlined,
                    size: constraints.maxHeight < 160 ? 30 : 56,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 10),
                Text(failed ? 'Fotoğraf yüklenemedi' : 'Fotoğraf eklenmedi',
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ])));
}

class CatalogVehicleCard extends StatelessWidget {
  const CatalogVehicleCard(
      {super.key,
      required this.vehicle,
      required this.onOpen,
      this.onManage,
      this.manage = false});
  final Vehicle vehicle;
  final VoidCallback onOpen;
  final VoidCallback? onManage;
  final bool manage;
  @override
  Widget build(BuildContext context) => StudioPanel(
      padding: 16,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        VehiclePhoto(vehicle: vehicle),
        const SizedBox(height: 20),
        Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 14,
            runSpacing: 8,
            children: [
              Text(vehicle.category.toUpperCase(),
                  style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Text(
                  manage
                      ? vehicle.statusLabel
                      : vehicle.isFleet
                          ? 'Filo'
                          : 'Bireysel',
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.primary))
            ]),
        const SizedBox(height: 8),
        Text(vehicle.name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        Wrap(spacing: 16, runSpacing: 8, children: [
          _spec(context, Icons.bolt_outlined, vehicle.energy),
          _spec(context, Icons.airline_seat_recline_normal_outlined,
              '${vehicle.seats} koltuk'),
        ]),
        const Divider(height: 32),
        Text(vehicle.rateLabel, style: Theme.of(context).textTheme.titleLarge),
        Text('günlük kiralama',
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 18),
        SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
                onPressed: onOpen,
                icon: Icon(manage ? Icons.edit_outlined : Icons.north_east,
                    size: 17),
                label: Text(manage ? 'Aracı düzenle' : 'Detayları gör'))),
        if (onManage != null)
          SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                  onPressed: onManage,
                  icon: const Icon(Icons.calendar_month_outlined, size: 17),
                  label: const Text('Takvim ve yayın'))),
      ]));

  Widget _spec(BuildContext context, IconData icon, String value) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon,
            size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 5),
        Flexible(child: Text(value, style: const TextStyle(fontSize: 12)))
      ]);
}

class CatalogGrid extends StatelessWidget {
  const CatalogGrid(
      {super.key,
      required this.vehicles,
      required this.onOpen,
      this.onManage,
      this.manage = false});
  final List<Vehicle> vehicles;
  final ValueChanged<Vehicle> onOpen;
  final ValueChanged<Vehicle>? onManage;
  final bool manage;
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1000
            ? 3
            : constraints.maxWidth >= 640
                ? 2
                : 1;
        return Column(children: [
          for (var row = 0; row < (vehicles.length / columns).ceil(); row++)
            Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var col = 0; col < columns; col++) ...[
                        if (col > 0) const SizedBox(width: 18),
                        Expanded(
                            child: row * columns + col >= vehicles.length
                                ? const SizedBox.shrink()
                                : CatalogVehicleCard(
                                    vehicle: vehicles[row * columns + col],
                                    manage: manage,
                                    onManage: onManage == null
                                        ? null
                                        : () => onManage!(
                                            vehicles[row * columns + col]),
                                    onOpen: () =>
                                        onOpen(vehicles[row * columns + col]))),
                      ]
                    ]))
        ]);
      });
}
