import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../discovery/domain/vehicle.dart';
import '../domain/reservation.dart';
import '../domain/price_quote.dart';

class ReservationController extends ChangeNotifier {
  ReservationController(this.api);
  final ApiClient api;
  List<Reservation> records = [];
  bool loading = false, _disposed = false;
  String? error;
  int _request = 0;
  static String requestKey() {
    final random = Random.secure();
    return List.generate(
            24, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'))
        .join();
  }

  Future<void> load() async {
    if (_disposed) return;
    final request = ++_request;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final response = await api.get('reservations');
      final result = (response['reservations'] as List)
          .map((r) => Reservation.fromJson(r as Map<String, dynamic>))
          .toList();
      if (!_disposed && request == _request) {
        records = List.unmodifiable(result);
      }
    } catch (failure) {
      if (!_disposed && request == _request) {
        records = [];
        error = failure is ApiException
            ? failure.message
            : 'Rezervasyonlar okunamadı.';
      }
    } finally {
      if (!_disposed && request == _request) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<PriceQuote> quote(String id, DateTime start, DateTime end) async {
    final response = await api.request('POST', 'quotes', body: {
      'vehicle_id': id,
      'starts_on': dateKey(start),
      'ends_on': dateKey(end)
    });
    return PriceQuote.fromJson(response['quote'] as Map<String, dynamic>);
  }

  Future<Reservation> reserve(String id, DateTime start, DateTime end,
      {required String requestKey, required String quoteToken}) async {
    final response = await api
        .request('POST', 'reservations', requestKey: requestKey, body: {
      'vehicle_id': id,
      'starts_on': dateKey(start),
      'ends_on': dateKey(end),
      'quote_token': quoteToken
    });
    final record =
        Reservation.fromJson(response['reservation'] as Map<String, dynamic>);
    await load();
    return record;
  }

  Future<void> cancel(String id) async {
    await api.request('POST', 'reservations/$id/cancel');
    await load();
  }

  void clear() {
    _request++;
    records = [];
    error = null;
    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
