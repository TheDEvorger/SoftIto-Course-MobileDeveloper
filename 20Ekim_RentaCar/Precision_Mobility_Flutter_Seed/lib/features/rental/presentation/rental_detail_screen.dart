import 'package:flutter/material.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../application/rental_controller.dart';
import '../domain/rental_vehicle.dart';
import 'local_booking_panel.dart';
import 'rental_actions.dart';
import 'rental_car_card.dart';

class RentalDetailScreen extends StatelessWidget {
  const RentalDetailScreen(
      {super.key,
      required this.controller,
      required this.vehicle,
      required this.onReservations,
      this.initialDates});
  final RentalController controller;
  final RentalVehicle vehicle;
  final VoidCallback onReservations;
  final DateTimeRange? initialDates;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Araç detayı'), actions: [
            IconButton(
                tooltip:
                    controller.repository.data.favorites.contains(vehicle.id)
                        ? 'Favorilerden çıkar'
                        : 'Favorilere ekle',
                onPressed: !controller.ready || controller.busy
                    ? null
                    : () => rentalAction(
                        context, () => controller.favorite(vehicle.id)),
                icon: Icon(
                    controller.repository.data.favorites.contains(vehicle.id)
                        ? Icons.favorite
                        : Icons.favorite_border)),
            const SizedBox(width: 12),
          ]),
          body: StudioPage(width: 1160, children: [
            PageHeading(
                eyebrow: '${vehicle.category} / ${vehicle.city}',
                title: vehicle.name,
                description:
                    '${vehicle.gearbox} · ${vehicle.energy} · ${vehicle.seats} kişilik'),
            const SizedBox(height: 24),
            LayoutBuilder(builder: (context, c) {
              final details = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RentalCarPhoto(vehicle: vehicle),
                    const SizedBox(height: 22),
                    StudioPanel(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('Yolculuğunuza eşlik etsin.',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          Text(vehicle.description),
                          const Divider(height: 32),
                          Wrap(spacing: 24, runSpacing: 20, children: [
                            _spec(Icons.settings_outlined, 'Vites',
                                vehicle.gearbox),
                            _spec(
                                Icons.bolt_outlined, 'Enerji', vehicle.energy),
                            _spec(Icons.person_outline, 'Kapasite',
                                '${vehicle.seats} kişi'),
                            _spec(Icons.luggage_outlined, 'Bagaj',
                                '${vehicle.bags} valiz'),
                          ]),
                          const Divider(height: 32),
                          Text('Alış noktası',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('${vehicle.city} · ${vehicle.pickup}'),
                          const SizedBox(height: 8),
                          Text(vehicle.fleet
                              ? 'Filo koleksiyonu'
                              : 'Bireysel koleksiyon'),
                          const SizedBox(height: 16),
                          const Text(
                              'Araç, donanım, fiyat ve alış noktası bilgileri hazır örnek koleksiyona aittir. '
                              'Görsel yapay zekâ ile üretilmiştir; bu modelin gerçek ilan fotoğrafı değildir.',
                              style: TextStyle(fontSize: 11)),
                        ])),
                  ]);
              final booking = LocalBookingPanel(
                  controller: controller,
                  vehicle: vehicle,
                  initialDates: initialDates,
                  onReservations: onReservations);
              if (c.maxWidth < 850 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.3) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [details, const SizedBox(height: 24), booking]);
              }
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: details),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: booking)
                  ]);
            }),
          ])));
  Widget _spec(IconData icon, String label, String value) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 22),
        const SizedBox(height: 7),
        Text(label, style: const TextStyle(fontSize: 11)),
        Text(value)
      ]);
}
