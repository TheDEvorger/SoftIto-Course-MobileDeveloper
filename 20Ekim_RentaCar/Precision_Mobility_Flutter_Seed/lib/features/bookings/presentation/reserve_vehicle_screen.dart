import 'package:flutter/material.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../../discovery/domain/vehicle.dart';
import '../../discovery/presentation/catalog_vehicle_card.dart';
import '../application/reservation_controller.dart';
import 'booking_panel.dart';

class ReserveVehicleScreen extends StatelessWidget {
  const ReserveVehicleScreen(
      {super.key,
      required this.vehicle,
      required this.controller,
      required this.connected,
      required this.onConnect,
      required this.onReservations,
      this.initialDates});
  final Vehicle vehicle;
  final ReservationController controller;
  final bool connected;
  final VoidCallback onConnect, onReservations;
  final DateTimeRange? initialDates;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Araç ve yolculuk')),
      body: StudioPage(children: [
        PageHeading(
            eyebrow: 'Koleksiyon / ${vehicle.category}',
            title: vehicle.name,
            description:
                '${vehicle.isFleet ? 'Filo' : 'Bireysel'} · ${vehicle.energy} · ${vehicle.seats} koltuk'),
        const SizedBox(height: 30),
        LayoutBuilder(builder: (context, constraints) {
          final details =
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            VehiclePhoto(vehicle: vehicle),
            const SizedBox(height: 24),
            StudioPanel(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Aracı yakından tanıyın.',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text(vehicle.description),
                  const SizedBox(height: 24),
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    Chip(
                        avatar: const Icon(Icons.bolt_outlined, size: 17),
                        label: Text(vehicle.energy)),
                    Chip(
                        avatar: const Icon(
                            Icons.airline_seat_recline_normal_outlined,
                            size: 17),
                        label: Text('${vehicle.seats} koltuk')),
                    Chip(label: Text(vehicle.category)),
                  ]),
                ])),
          ]);
          final booking = BookingPanel(
              vehicle: vehicle,
              controller: controller,
              connected: connected,
              initialDates: initialDates,
              onConnect: () {
                Navigator.of(context).pop();
                onConnect();
              },
              onReservations: () {
                Navigator.of(context).pop();
                onReservations();
              });
          if (constraints.maxWidth < 900 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.3) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [details, const SizedBox(height: 24), booking]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 3, child: details),
            const SizedBox(width: 28),
            Expanded(flex: 2, child: booking)
          ]);
        }),
      ]));
}
