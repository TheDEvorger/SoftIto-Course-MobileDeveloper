import 'package:flutter/foundation.dart';
import '../data/device_rental_repository.dart';
import '../domain/local_reservation.dart';

class RentalController extends ChangeNotifier {
  RentalController(this.repository);
  final DeviceRentalRepository repository;
  bool loading = true, busy = false, ready = false, _disposed = false;
  String? error;
  Future<void> load() async {
    loading = true;
    error = null;
    _notify();
    try {
      await repository.load();
      ready = true;
    } catch (failure) {
      ready = false;
      error = failure.toString();
    } finally {
      loading = false;
      _notify();
    }
  }

  Future<T> _act<T>(Future<T> Function() action) async {
    if (busy) throw const RentalFailure('Önceki işlem kaydediliyor.');
    busy = true;
    _notify();
    try {
      return await action();
    } finally {
      busy = false;
      _notify();
    }
  }

  Future<void> favorite(String id) => _act(() => repository.favorite(id));
  Future<void> cancel(String id) => _act(() => repository.cancel(id));
  Future<LocalReservation> reserve(RentalQuote quote, String requestKey) =>
      _act(() => repository.reserve(quote, requestKey));
  Future<void> preferences({String? theme, String? city}) =>
      _act(() => repository.preferences(theme: theme, city: city));
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
