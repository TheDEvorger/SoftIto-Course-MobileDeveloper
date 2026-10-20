enum BookingState { quoted, confirmed, cancelled, expired }

class DemoBooking {
  const DemoBooking(
      {required this.id,
      required this.vehicleId,
      required this.vehicleName,
      required this.start,
      required this.end,
      required this.expiresAt,
      required this.total,
      this.state = BookingState.quoted});
  final String id;
  final String vehicleId;
  final String vehicleName;
  final DateTime start;
  final DateTime end;
  final DateTime expiresAt;
  final int total;
  final BookingState state;
  String get policyVersion => 'demo-v1';

  DemoBooking withState(BookingState value) => DemoBooking(
      id: id,
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      start: start,
      end: end,
      expiresAt: expiresAt,
      total: total,
      state: value);
}

/// In-memory fixture ledger. Production pricing/locking belongs on a server.
class BookingLedger {
  final Map<String, DemoBooking> _records = {};
  int _sequence = 0;
  List<DemoBooking> get records => List.unmodifiable(_records.values);

  DemoBooking quote(
      {required String vehicleId,
      required String vehicleName,
      required int dailyRate,
      required DateTime start,
      required DateTime end,
      required DateTime now}) {
    if (vehicleId.isEmpty ||
        vehicleName.isEmpty ||
        dailyRate <= 0 ||
        !start.isAfter(now) ||
        !end.isAfter(start)) {
      throw ArgumentError('Geçersiz örnek araç, tarih veya fiyat.');
    }
    final days = (end.difference(start).inMilliseconds /
            const Duration(days: 1).inMilliseconds)
        .ceil();
    final record = DemoBooking(
        id: 'demo-${++_sequence}',
        vehicleId: vehicleId,
        vehicleName: vehicleName,
        start: start,
        end: end,
        expiresAt: now.add(const Duration(minutes: 5)),
        total: days * dailyRate);
    _records[record.id] = record;
    return record;
  }

  DemoBooking get(String id, DateTime now) {
    var record = _records[id];
    if (record == null) throw StateError('Örnek rezervasyon bulunamadı.');
    if (record.state == BookingState.quoted &&
        (!now.isBefore(record.expiresAt) || !now.isBefore(record.start))) {
      record = record.withState(BookingState.expired);
      _records[id] = record;
    }
    return record;
  }

  DemoBooking confirm(String id, DateTime now) {
    final record = get(id, now);
    if (record.state != BookingState.quoted) {
      throw StateError('Yalnızca geçerli bir teklif onaylanabilir.');
    }
    final conflict = _records.values.any((other) =>
        other.id != id &&
        other.vehicleId == record.vehicleId &&
        other.state == BookingState.confirmed &&
        record.start.isBefore(other.end) &&
        record.end.isAfter(other.start));
    if (conflict) throw StateError('Bu örnek araç için tarih çakışması var.');
    return _records[id] = record.withState(BookingState.confirmed);
  }

  DemoBooking cancel(String id, DateTime now) {
    final record = get(id, now);
    if (record.state != BookingState.quoted &&
        record.state != BookingState.confirmed) {
      throw StateError('Bu durumdan iptal yapılamaz.');
    }
    return _records[id] = record.withState(BookingState.cancelled);
  }
}
