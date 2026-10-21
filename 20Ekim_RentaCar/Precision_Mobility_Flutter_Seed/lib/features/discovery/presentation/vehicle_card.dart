import 'package:flutter/material.dart';
import '../../../core/theme/palette.dart';
import 'vehicle_details_screen.dart';
import '../domain/demo_vehicle.dart';
import '../../../shared/widgets/precision_button.dart';

/// Keşif ekranında her bir aracı listeleyen kart bileşeni.
/// Araç görseli temsili ikonu, isim, kategori, mesafe ve fiyat bilgisini gösterir.
class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key, required this.vehicle});

  /// Kartta gösterilecek araç verisi
  final DemoVehicle vehicle;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color:
                            Palette.precisionBlueGrey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.directions_car_filled_outlined,
                        size: 68, color: Palette.precisionBlueGrey)),
                const SizedBox(height: 16),
                Text(vehicle.name,
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                Text(vehicle.category),
                const SizedBox(height: 6),
                Text('${vehicle.distanceKm.toStringAsFixed(1)} km • '
                    '${vehicle.isFleet ? 'Filo' : 'Bireysel'}'),
                const SizedBox(height: 16),
                Text('₺${vehicle.pricePerDay} / gün',
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    child: PrecisionButton(
                        label: 'Aracı incele',
                        style: PrecisionButtonStyle.secondary,
                        onPressed: () => Navigator.of(context).push<void>(
                              MaterialPageRoute(
                                  builder: (_) => VehicleDetailsScreen(
                                      vehicleId: vehicle.id)),
                            ))),
              ],
            )));
  }
}
