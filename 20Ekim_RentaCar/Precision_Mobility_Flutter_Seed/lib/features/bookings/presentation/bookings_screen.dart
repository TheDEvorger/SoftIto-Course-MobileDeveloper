import 'package:flutter/material.dart';
import '../../../shared/widgets/section_heading.dart';
import '../application/demo_booking_scope.dart';
import '../domain/booking_ledger.dart';
import 'booking_demo_screen.dart';

/// "Sürüşlerim" sekmesi ekranı.
/// Oturum süresince oluşturulan tüm rezervasyon kayıtlarını listeler;
/// teslim ekranını açma veya rezervasyonu iptal etme aksiyonları sunar.
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // DemoBookingScope üzerinden rezervasyon controller'ı alınır
    final controller = DemoBookingScope.of(context);
    // Kayıtlar listelenirken anlık geçerlilik (expiration) durumları hesaplanır
    final records = controller.ledger.records
        .map((r) => controller.ledger.get(r.id, controller.clock()))
        .toList();
    return ListView(padding: const EdgeInsets.all(24), children: [
      const SectionHeading(
          title: 'Sürüşlerim',
          subtitle: 'DEMO • Gerçek rezervasyon veya ödeme yapılmaz.'),
      const SizedBox(height: 20),
      if (records.isEmpty)
        const Text(
            'Henüz örnek rezervasyon yok. Keşfet → Aracı incele ile başlayın.'),
      for (final record in records)
        Card(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${record.vehicleName} • ${record.id}'),
            Text(bookingStateLabel(record.state)),
            Text('${record.start} → ${record.end}'),
            Text('Örnek toplam ₺${record.total}'),
            if (record.state == BookingState.confirmed)
              OutlinedButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/handover', arguments: record.id),
                  child: const Text('Teslim demosunu aç')),
            if (record.state == BookingState.confirmed)
              OutlinedButton(
                  onPressed: () => controller.cancel(record.id),
                  child: const Text('Demo rezervasyonu iptal et')),
          ]),
        )),
      const Text('Veriler yalnızca bu oturumun belleğinde tutulur.'),
    ]);
  }
}
