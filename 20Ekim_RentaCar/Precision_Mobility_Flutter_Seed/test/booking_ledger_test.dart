import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/features/bookings/domain/booking_ledger.dart';

void main() {
  late BookingLedger ledger;
  final now = DateTime.utc(2030, 1, 1);
  final start = now.add(const Duration(days: 1));
  setUp(() => ledger = BookingLedger());
  DemoBooking quote({String vehicle = 'v1', DateTime? from, DateTime? to}) =>
      ledger.quote(
          vehicleId: vehicle,
          vehicleName: 'Sample',
          dailyRate: 100,
          start: from ?? start,
          end: to ?? start.add(const Duration(days: 1)),
          now: now);

  test('quote amount rounds partial days up, expiry boundary fails closed', () {
    final q = quote(to: start.add(const Duration(hours: 25)));
    expect(q.total, 200);
    expect(q.policyVersion, 'demo-v1');
    expect(() => ledger.confirm(q.id, q.expiresAt), throwsStateError);
    expect(ledger.get(q.id, q.expiresAt).state, BookingState.expired);
    expect(() => ledger.cancel(q.id, q.expiresAt), throwsStateError);
  });
  test('invalid IDs, rates and dates rejected', () {
    expect(() => ledger.get('missing', now), throwsStateError);
    expect(() => quote(from: now), throwsArgumentError);
    expect(() => quote(to: start), throwsArgumentError);
    expect(() => quote(vehicle: ''), throwsArgumentError);
    expect(
        () => ledger.quote(
            vehicleId: 'v',
            vehicleName: 'V',
            dailyRate: 0,
            start: start,
            end: start.add(const Duration(days: 1)),
            now: now),
        throwsArgumentError);
  });
  test('confirmed overlap rejected including enclosing/contained intervals',
      () {
    final a = quote();
    ledger.confirm(a.id, now);
    for (final range in [
      [start, start.add(const Duration(hours: 1))],
      [
        start.subtract(const Duration(hours: 1)),
        start.add(const Duration(days: 2))
      ],
      [start.add(const Duration(hours: 1)), start.add(const Duration(days: 2))],
    ]) {
      final b = quote(from: range[0], to: range[1]);
      expect(() => ledger.confirm(b.id, now), throwsStateError);
      expect(ledger.get(b.id, now).state, BookingState.quoted);
    }
  });
  test('adjacent slots and separate vehicles do not conflict', () {
    ledger.confirm(quote().id, now);
    ledger.confirm(quote(vehicle: 'v2').id, now);
    ledger.confirm(
        quote(
                from: start.add(const Duration(days: 1)),
                to: start.add(const Duration(days: 2)))
            .id,
        now);
    expect(
        ledger.records.where((r) => r.state == BookingState.confirmed).length,
        3);
  });
  test('cancellation releases allocation, terminal transitions rejected', () {
    final a = quote();
    ledger.confirm(a.id, now);
    expect(() => ledger.confirm(a.id, now), throwsStateError);
    ledger.cancel(a.id, now);
    ledger.confirm(quote().id, now);
    expect(() => ledger.confirm(a.id, now), throwsStateError);
    expect(() => ledger.cancel(a.id, now), throwsStateError);
    final b = quote();
    ledger.cancel(b.id, now);
    expect(ledger.get(b.id, now).state, BookingState.cancelled);
  });
}
