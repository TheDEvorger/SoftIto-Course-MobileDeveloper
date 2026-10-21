import 'package:flutter/material.dart';
import '../application/demo_booking_scope.dart';
import '../domain/booking_ledger.dart';

/// Rezervasyon durumunu kullanıcı dostu Türkçe metne dönüştürür.
String bookingStateLabel(BookingState state) => switch (state) {
      BookingState.quoted => 'Teklif hazır',
      BookingState.confirmed => 'Demo rezervasyon onaylandı',
      BookingState.cancelled => 'İptal edildi',
      BookingState.expired => 'Teklif süresi doldu',
    };

/// Rezervasyon oluşturma, teklif alma ve onaylama adımlarını simüle eden ekran.
class BookingDemoScreen extends StatefulWidget {
  const BookingDemoScreen(
      {super.key,
      required this.vehicleId,
      required this.vehicleName,
      required this.dailyRate});

  /// Rezervasyon yapılacak araç kimliği
  final String vehicleId;

  /// Araç model adı
  final String vehicleName;

  /// Günlük kiralama birim fiyatı
  final int dailyRate;

  @override
  State<BookingDemoScreen> createState() => _BookingDemoScreenState();
}

class _BookingDemoScreenState extends State<BookingDemoScreen> {
  // Seçilen kiralama gün sayısı (1, 2, 3, 7)
  int _days = 1;

  // Oluşturulan teklif kimliği
  String? _id;

  // Hata mesajı (varsa)
  String? _error;

  void _run(VoidCallback action) {
    try {
      action();
      setState(() => _error = null);
    } on StateError catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = DemoBookingScope.of(context);
    final record =
        _id == null ? null : controller.ledger.get(_id!, controller.clock());
    return Scaffold(
      appBar: AppBar(title: const Text('Örnek rezervasyon')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Text(widget.vehicleName,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const Text('DEMO • Gerçek rezervasyon veya ödeme yapılmaz. '
            'Başlangıç: yarın 10:00 (cihazın yerel saati). '
            'Teklif 5 dakika geçerli; fiyat yalnızca örnektir.'),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: _days,
          decoration: const InputDecoration(labelText: 'Örnek kiralama süresi'),
          items: [1, 2, 3, 7]
              .map((days) =>
                  DropdownMenuItem(value: days, child: Text('$days gün')))
              .toList(),
          onChanged: (value) => setState(() {
            _days = value!;
            _id = null;
          }),
        ),
        const SizedBox(height: 16),
        FilledButton(
            onPressed: () => setState(() {
                  _id = controller
                      .quote(
                          vehicleId: widget.vehicleId,
                          vehicleName: widget.vehicleName,
                          dailyRate: widget.dailyRate,
                          days: _days)
                      .id;
                  _error = null;
                }),
            child: const Text('Örnek teklif oluştur')),
        if (record != null) ...[
          const SizedBox(height: 16),
          Text('Örnek toplam: ₺${record.total} • ${record.policyVersion}'),
          Text('Başlangıç: ${record.start}'),
          Text('Bitiş: ${record.end}'),
          Text('Teklif sonu: ${record.expiresAt}'),
          Semantics(
              liveRegion: true, child: Text(bookingStateLabel(record.state))),
          const SizedBox(height: 12),
          FilledButton(
              onPressed: record.state == BookingState.quoted
                  ? () => _run(() => controller.confirm(record.id))
                  : null,
              child: const Text('Demo onayı ver')),
          OutlinedButton(
              onPressed: record.state == BookingState.quoted ||
                      record.state == BookingState.confirmed
                  ? () => _run(() => controller.cancel(record.id))
                  : null,
              child: const Text('Örnek rezervasyonu iptal et')),
          TextButton(
              onPressed: () => setState(() {}),
              child: const Text('Teklif durumunu yenile')),
        ],
        if (_error != null)
          Semantics(
              liveRegion: true,
              child: Text(_error!,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error))),
        const Text('Oturum verileri bellektedir; uygulama kapanınca silinir.'),
      ]),
    );
  }
}
