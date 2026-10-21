import 'package:flutter/material.dart';
import '../../../shared/design/studio_page.dart';
import '../domain/rental_vehicle.dart';

class RentalCarPhoto extends StatelessWidget {
  const RentalCarPhoto({super.key, required this.vehicle});
  final RentalVehicle vehicle;
  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
          aspectRatio: 1.75,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset('assets/images/sample-${vehicle.image}.png',
                fit: BoxFit.cover,
                semanticLabel:
                    '${vehicle.name}, yapay zekâ ile üretilmiş temsili görsel'),
            Positioned(
                left: 10,
                bottom: 10,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFF17221E),
                        borderRadius: BorderRadius.circular(6)),
                    child: const Text('Temsili görsel',
                        style: TextStyle(color: Colors.white, fontSize: 10)))),
          ])));
}

class RentalCarCard extends StatelessWidget {
  const RentalCarCard(
      {super.key,
      required this.vehicle,
      required this.favorite,
      required this.onOpen,
      required this.onFavorite});
  final RentalVehicle vehicle;
  final bool favorite;
  final VoidCallback onOpen;
  final VoidCallback? onFavorite;
  @override
  Widget build(BuildContext context) => StudioPanel(
      padding: 14,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          RentalCarPhoto(vehicle: vehicle),
          Positioned(
              top: 8,
              right: 8,
              child: IconButton.filledTonal(
                  tooltip: favorite ? 'Favorilerden çıkar' : 'Favorilere ekle',
                  onPressed: onFavorite,
                  isSelected: favorite,
                  style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface),
                  icon: const Icon(Icons.favorite_border),
                  selectedIcon: const Icon(Icons.favorite))),
        ]),
        const SizedBox(height: 18),
        Text(vehicle.category.toUpperCase(),
            style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.4,
                color: Theme.of(context).colorScheme.primary)),
        const SizedBox(height: 6),
        Text(vehicle.name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('${vehicle.city} · ${vehicle.pickup}',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 14),
        Wrap(spacing: 12, runSpacing: 8, children: [
          _spec(Icons.settings_outlined, vehicle.gearbox),
          _spec(Icons.bolt_outlined, vehicle.energy),
          _spec(Icons.person_outline, '${vehicle.seats} kişi'),
        ]),
        const Divider(height: 30),
        Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(vehicle.dailyLabel,
                  style: Theme.of(context).textTheme.titleLarge),
              const Text('/ gün', style: TextStyle(fontSize: 12)),
            ]),
        const SizedBox(height: 16),
        SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.arrow_outward, size: 17),
                label: const Text('Aracı incele'))),
      ]));
  Widget _spec(IconData icon, String text) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 15),
        const SizedBox(width: 4),
        Flexible(child: Text(text, style: const TextStyle(fontSize: 11)))
      ]);
}

class RentalCarGrid extends StatelessWidget {
  const RentalCarGrid(
      {super.key,
      required this.vehicles,
      required this.favorites,
      required this.onOpen,
      required this.onFavorite});
  final List<RentalVehicle> vehicles;
  final Set<String> favorites;
  final ValueChanged<RentalVehicle> onOpen;
  final ValueChanged<RentalVehicle>? onFavorite;
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(1);
        final columns = constraints.maxWidth >= 1050 && scale < 1.5
            ? 3
            : constraints.maxWidth >= 650 && scale < 1.5
                ? 2
                : 1;
        return Column(children: [
          for (var row = 0; row < (vehicles.length / columns).ceil(); row++)
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var col = 0; col < columns; col++) ...[
                        if (col > 0) const SizedBox(width: 20),
                        Expanded(
                            child: row * columns + col >= vehicles.length
                                ? const SizedBox.shrink()
                                : RentalCarCard(
                                    vehicle: vehicles[row * columns + col],
                                    favorite: favorites.contains(
                                        vehicles[row * columns + col].id),
                                    onOpen: () =>
                                        onOpen(vehicles[row * columns + col]),
                                    onFavorite: onFavorite == null
                                        ? null
                                        : () => onFavorite!(
                                            vehicles[row * columns + col]))),
                      ],
                    ])),
        ]);
      });
}
