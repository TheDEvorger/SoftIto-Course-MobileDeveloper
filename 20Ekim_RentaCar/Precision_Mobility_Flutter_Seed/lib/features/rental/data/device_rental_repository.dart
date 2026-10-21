import 'dart:async';
import 'dart:math';
import '../domain/local_reservation.dart';
import '../domain/rental_vehicle.dart';
import 'rental_snapshot.dart';
import 'rental_storage.dart';

class DeviceRentalRepository {
  DeviceRentalRepository(this.storage, this.catalog,
      {DateTime Function()? clock})
      : clock = clock ?? DateTime.now;
  final RentalStorage storage;
  final List<RentalVehicle> catalog;
  final DateTime Function() clock;
  RentalSnapshot _data = RentalSnapshot();
  RentalSnapshot get data => _data.copy();
  Future<void> _tail = Future.value();
  bool _ready = false;
  Future<void> load() async {
    try {
      final raw = await storage.read();
      final next = raw == null ? RentalSnapshot() : RentalSnapshot.decode(raw);
      if (next.plans.any((r) => !catalog.any((v) => v.id == r.vehicleId))) {
        throw const FormatException();
      }
      _data = next;
      _ready = true;
    } catch (_) {
      _ready = false;
      throw const RentalFailure(
          'Cihazdaki kayıtlar okunamadı. Veriler korunuyor; yeniden deneyin.');
    }
  }

  RentalVehicle vehicle(String id) => catalog.firstWhere((v) => v.id == id,
      orElse: () => throw const RentalFailure('Araç bulunamadı.'));
  bool available(String id, DateTime start, DateTime end,
          {RentalSnapshot? data}) =>
      !(data ?? _data).plans.any((r) =>
          r.vehicleId == id &&
          !r.cancelled &&
          r.start.isBefore(end) &&
          r.end.isAfter(start));
  RentalQuote quote(String id, DateTime start, DateTime end) {
    _validateDates(start, end);
    if (!available(id, start, end)) {
      throw const RentalFailure(
          'Bu araç için seçilen tarihlerde bir planınız var.');
    }
    return RentalQuote(
        vehicleId: id,
        start: start,
        end: end,
        dailyMinor: vehicle(id).dailyMinor,
        expiresAt: clock().add(const Duration(minutes: 5)));
  }

  void _validateDates(DateTime start, DateTime end) {
    final today = clock();
    if (start.isBefore(DateTime(today.year, today.month, today.day)) ||
        start.hour != 0 ||
        end.hour != 0 ||
        start.minute != 0 ||
        end.minute != 0 ||
        calendarDays(start, end) < 1 ||
        calendarDays(start, end) > 7) {
      throw const RentalFailure(
          'Bugünden itibaren 1–7 günlük bir aralık seçin.');
    }
  }

  Future<LocalReservation> reserve(RentalQuote quote, String requestKey) =>
      _write((next) {
        for (final old in next.plans) {
          if (old.requestKey == requestKey) {
            if (old.vehicleId != quote.vehicleId ||
                old.start != quote.start ||
                old.end != quote.end) {
              throw const RentalFailure(
                  'İşlem anahtarı başka bir plan için kullanılmış.');
            }
            return old;
          }
        }
        _validateDates(quote.start, quote.end);
        if (!quote.expiresAt.isAfter(clock()) ||
            quote.dailyMinor != vehicle(quote.vehicleId).dailyMinor) {
          throw const RentalFailure(
              'Fiyat özeti güncellendi. Tekrar kontrol edip onaylayın.');
        }
        if (!available(quote.vehicleId, quote.start, quote.end, data: next)) {
          throw const RentalFailure(
              'Bu araç için seçilen tarihlerde bir planınız var.');
        }
        if (requestKey.isEmpty) {
          throw const RentalFailure('İşlem anahtarı gerekli.');
        }
        final record = LocalReservation(
            id: 'PM-${clock().year}-${newRequestKey().substring(0, 8).toUpperCase()}',
            vehicleId: quote.vehicleId,
            start: quote.start,
            end: quote.end,
            totalMinor: quote.totalMinor,
            requestKey: requestKey);
        next.plans.insert(0, record);
        return record;
      });
  Future<void> cancel(String id) => _write((next) {
        final index = next.plans.indexWhere((r) => r.id == id);
        if (index < 0) throw const RentalFailure('Rezervasyon bulunamadı.');
        next.plans[index] = next.plans[index].cancel();
      });
  Future<void> favorite(String id) => _write((next) {
        vehicle(id);
        if (!next.favorites.remove(id)) next.favorites.add(id);
      });
  Future<void> preferences({String? theme, String? city}) => _write((next) {
        if (theme != null) {
          if (!['system', 'light', 'dark'].contains(theme)) {
            throw const RentalFailure('Görünüm seçimi geçersiz.');
          }
          next.theme = theme;
        }
        if (city != null) {
          if (!['Tüm şehirler', 'İstanbul', 'Ankara', 'İzmir'].contains(city)) {
            throw const RentalFailure('Şehir seçimi geçersiz.');
          }
          next.city = city;
        }
      });
  Future<T> _write<T>(T Function(RentalSnapshot) mutate) {
    final result = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        if (!_ready) {
          throw const RentalFailure('Cihaz kayıtlarını yeniden yükleyin.');
        }
        final raw = await storage.read();
        final next =
            raw == null ? RentalSnapshot() : RentalSnapshot.decode(raw);
        final value = mutate(next);
        await storage.write(next.encode());
        _data = next;
        result.complete(value);
      } catch (error, stack) {
        result.completeError(
            error is RentalFailure
                ? error
                : const RentalFailure(
                    'Değişiklik cihaza kaydedilemedi. Tekrar deneyin.'),
            stack);
      }
    });
    return result.future;
  }

  static String newRequestKey() {
    final random = Random.secure();
    return List.generate(
            16, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'))
        .join();
  }
}
