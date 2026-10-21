import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/features/rental/data/device_rental_repository.dart';
import 'package:precision_mobility/features/rental/data/rental_catalog.dart';
import 'package:precision_mobility/features/rental/domain/local_reservation.dart';
import 'package:precision_mobility/features/rental/domain/rental_vehicle.dart';
import 'support/memory_rental_storage.dart';

void main() {
  late MemoryRentalStorage storage;
  late DeviceRentalRepository repository;
  var now = DateTime(2026, 10, 21, 10);
  final start = DateTime(2026, 10, 22), end = DateTime(2026, 10, 24);
  setUp(() async {
    now = DateTime(2026, 10, 21, 10);
    storage = MemoryRentalStorage();
    repository =
        DeviceRentalRepository(storage, rentalCatalog, clock: () => now);
    await repository.load();
  });
  test('cold start has bundled catalog, no fabricated user plans or favorites',
      () {
    expect(repository.catalog.length, 9);
    expect(repository.data.plans, isEmpty);
    expect(repository.data.favorites, isEmpty);
    expect(storage.writes, 0);
  });
  test('integer quote, idempotent retry, conflict and cancel preserve history',
      () async {
    final quote = repository.quote('clio', start, end);
    expect(quote.totalMinor, 290000);
    final record = await repository.reserve(quote, 'stable');
    expect(record.totalMinor, 290000);
    now = now.add(const Duration(minutes: 10));
    expect((await repository.reserve(quote, 'stable')).id, record.id);
    expect(repository.available('clio', start, end), isFalse);
    expect(() => repository.quote('clio', start, end),
        throwsA(isA<RentalFailure>()));
    await repository.cancel(record.id);
    expect(repository.data.plans.single.cancelled, isTrue);
    expect(repository.available('clio', start, end), isTrue);
    final next = repository.quote('clio', start, end);
    await repository.reserve(next, 'second');
    expect(repository.data.plans.length, 2);
  });
  test('concurrent same-window requests allocate exactly one plan', () async {
    final quote = repository.quote('clio', start, end);
    final results = await Future.wait(List.generate(6, (i) async {
      try {
        await repository.reserve(quote, 'concurrent-$i');
        return true;
      } on RentalFailure {
        return false;
      }
    }));
    expect(results.where((success) => success).length, 1);
    expect(repository.data.plans.length, 1);
  });
  test('write failure keeps old state and retry can save once', () async {
    storage.failWrite = true;
    final quote = repository.quote('clio', start, end);
    await expectLater(
        repository.reserve(quote, 'retry'), throwsA(isA<RentalFailure>()));
    await expectLater(
        repository.favorite('clio'), throwsA(isA<RentalFailure>()));
    expect(repository.data.plans, isEmpty);
    expect(repository.data.favorites, isEmpty);
    storage.failWrite = false;
    await repository.reserve(quote, 'retry');
    await repository.reserve(quote, 'retry');
    expect(repository.data.plans.length, 1);
  });
  test('restart restores favorites, preferences and cancelled booking',
      () async {
    await repository.favorite('bmw-320');
    await repository.preferences(theme: 'dark', city: 'İzmir');
    final record = await repository.reserve(
        repository.quote('clio', start, end), 'persist');
    await repository.cancel(record.id);
    final restored =
        DeviceRentalRepository(storage, rentalCatalog, clock: () => now);
    await restored.load();
    expect(restored.data.favorites, {'bmw-320'});
    expect(restored.data.theme, 'dark');
    expect(restored.data.city, 'İzmir');
    expect(restored.data.plans.single.id, record.id);
    expect(restored.data.plans.single.cancelled, isTrue);
  });
  test('corrupt or unavailable storage never silently overwrites old data',
      () async {
    storage.value = 'broken-record';
    await expectLater(repository.load(), throwsA(isA<RentalFailure>()));
    await expectLater(
        repository.favorite('clio'), throwsA(isA<RentalFailure>()));
    expect(storage.value, 'broken-record');
    expect(storage.writes, 0);
    storage.value = null;
    storage.failRead = true;
    await expectLater(repository.load(), throwsA(isA<RentalFailure>()));
    storage.failRead = false;
    await repository.load();
    await repository.favorite('clio');
    expect(repository.data.favorites, {'clio'});
  });
  test('invalid dates, forged price, expired quote and reused key are rejected',
      () async {
    for (final dates in [
      (start, start),
      (start, DateTime(2026, 11, 2)),
      (DateTime(2026, 10, 20), end)
    ]) {
      expect(() => repository.quote('clio', dates.$1, dates.$2),
          throwsA(isA<RentalFailure>()));
    }
    final forged = RentalQuote(
        vehicleId: 'clio',
        start: start,
        end: end,
        dailyMinor: 1,
        expiresAt: now.add(const Duration(minutes: 5)));
    await expectLater(
        repository.reserve(forged, 'forged'), throwsA(isA<RentalFailure>()));
    final quote = repository.quote('clio', start, end);
    now = now.add(const Duration(minutes: 5));
    await expectLater(
        repository.reserve(quote, 'expired'), throwsA(isA<RentalFailure>()));
    await repository.reserve(repository.quote('clio', start, end), 'same-key');
    final other = repository.quote('bmw-320', start, end);
    await expectLater(
        repository.reserve(other, 'same-key'), throwsA(isA<RentalFailure>()));
  });
  test('calendar days and formatting are independent of fractional currency',
      () {
    expect(calendarDays(DateTime(2026, 3, 28), DateTime(2026, 3, 30)), 2);
    expect(rentalMoney(123456), '1.234,56 ₺');
  });
}
