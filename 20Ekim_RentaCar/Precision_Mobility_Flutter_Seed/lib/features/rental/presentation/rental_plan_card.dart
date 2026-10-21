import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/design/studio_page.dart';
import '../domain/local_reservation.dart';
import '../domain/rental_vehicle.dart';
import 'rental_car_card.dart';

class RentalPlanCard extends StatelessWidget {
  const RentalPlanCard(
      {super.key,
      required this.record,
      required this.vehicle,
      required this.onCancel,
      this.details = false});
  final LocalReservation record;
  final RentalVehicle vehicle;
  final VoidCallback? onCancel;
  final bool details;
  @override
  Widget build(BuildContext context) {
    final dates = MaterialLocalizations.of(context);
    final information =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(
          spacing: 7,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
                record.cancelled
                    ? Icons.cancel_outlined
                    : Icons.event_available_outlined,
                size: 17),
            Text(record.cancelled ? 'İptal edildi' : 'Cihazda kayıtlı',
                style: const TextStyle(fontSize: 12)),
          ]),
      const SizedBox(height: 12),
      Text(vehicle.name, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Text('${vehicle.city} · ${vehicle.pickup}'),
      const SizedBox(height: 8),
      Text(
          '${dates.formatShortDate(record.start)} — ${dates.formatShortDate(record.end)}'),
      const SizedBox(height: 8),
      Text(
          '${calendarDays(record.start, record.end)} gün · ${record.totalLabel}',
          style: const TextStyle(fontWeight: FontWeight.w600)),
      if (details) ...[
        const Divider(height: 30),
        SelectableText('Referans: ${record.id}'),
        const SizedBox(height: 12),
        const Text(
            'Bu cihazdaki plan kaydıdır. Gerçek araç tahsisi, tedarikçi onayı ve ödeme işlemi yapılmadı.'),
      ],
      const SizedBox(height: 18),
      Wrap(spacing: 10, runSpacing: 10, children: [
        if (!details)
          OutlinedButton(
              onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: RentalPlanCard(
                          record: record,
                          vehicle: vehicle,
                          onCancel: null,
                          details: true))),
              child: const Text('Rezervasyon detayı')),
        if (details)
          OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(
                    text: '${record.id} · ${vehicle.name} · '
                        '${rentalDateKey(record.start)} / ${rentalDateKey(record.end)} · ${record.totalLabel} · '
                        '${record.cancelled ? 'İptal edildi' : 'Yerel plan'}'));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Rezervasyon özeti kopyalandı.')));
                }
              },
              icon: const Icon(Icons.copy_outlined, size: 16),
              label: const Text('Özeti kopyala')),
        if (!record.cancelled && !details)
          TextButton(
              onPressed: onCancel, child: const Text('Rezervasyonu iptal et')),
      ]),
    ]);
    return StudioPanel(
        padding: 18,
        child: LayoutBuilder(builder: (context, c) {
          if (c.maxWidth < 700 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.3) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RentalCarPhoto(vehicle: vehicle),
                  const SizedBox(height: 20),
                  information
                ]);
          }
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 250, child: RentalCarPhoto(vehicle: vehicle)),
            const SizedBox(width: 24),
            Expanded(child: information)
          ]);
        }));
  }
}
