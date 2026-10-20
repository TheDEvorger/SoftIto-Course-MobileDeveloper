import 'package:flutter/material.dart';
import '../../../shared/widgets/precision_empty_state.dart';
import '../domain/demo_vehicle.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key, required this.vehicleId});
  final String vehicleId;

  @override
  Widget build(BuildContext context) {
    final vehicle = findDemoVehicle(vehicleId);
    return Scaffold(
      appBar: AppBar(title: const Text('Araç detayları • DEMO')),
      body: vehicle == null
          ? const PrecisionEmptyState(
              title: 'Araç bulunamadı',
              message: 'Bu örnek araç mevcut değil. Listeye geri dönün.')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                  child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AspectRatio(
                        aspectRatio: 2.5,
                        child: Card(
                            child: Center(
                                child: Icon(Icons.directions_car_outlined,
                                    size: 80)))),
                    const SizedBox(height: 24),
                    Text(vehicle.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(vehicle.providerLabel),
                    const SizedBox(height: 16),
                    Text(vehicle.description),
                    const SizedBox(height: 16),
                    Wrap(spacing: 12, runSpacing: 8, children: [
                      Chip(label: Text(vehicle.category)),
                      Chip(label: Text('${vehicle.seats} koltuk')),
                      Chip(label: Text(vehicle.energy)),
                    ]),
                    const SizedBox(height: 16),
                    Text('Örnek günlük fiyat: ₺${vehicle.pricePerDay}'),
                    Text('Temsili uzaklık: ${vehicle.distanceKm} km'),
                    const SizedBox(height: 16),
                    FilledButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed('/booking', arguments: vehicle.id),
                        child: const Text('Rezervasyon demosunu aç')),
                    const SizedBox(height: 16),
                    const Text('Yalnızca demo envanter. Araç, fiyat, mesafe ve '
                        'sağlayıcı bilgileri temsilidir. Gerçek kiralama yapılamaz.'),
                  ],
                ),
              ))),
    );
  }
}
