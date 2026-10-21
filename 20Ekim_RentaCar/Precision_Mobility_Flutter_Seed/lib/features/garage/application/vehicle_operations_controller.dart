import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../discovery/domain/vehicle.dart';

class VehicleOperationsController extends ChangeNotifier {
  VehicleOperationsController(this.api, this.vehicle)
      : published = vehicle.published;
  final ApiClient api;
  final Vehicle vehicle;
  bool published, busy = false, _disposed = false;
  String? error;
  List<Map<String, dynamic>> blocks = [], reservations = [];
  Future<void> load() => _run(() async {
        final data = await api.get('vehicles/${vehicle.id}/calendar');
        if (_disposed) return;
        blocks = (data['blocks'] as List).cast<Map<String, dynamic>>();
        reservations =
            (data['reservations'] as List).cast<Map<String, dynamic>>();
      });
  Future<void> publish(bool value) => _run(() async {
        await api.request('PUT', 'vehicles/${vehicle.id}/publication',
            body: {'published': value});
        if (!_disposed) published = value;
      });
  Future<void> block(DateTime start, DateTime end, String reason) async {
    if (await _run(() async {
      await api.request('POST', 'vehicles/${vehicle.id}/calendar', body: {
        'starts_on': dateKey(start),
        'ends_on': dateKey(end),
        'reason': reason
      });
    })) {
      await load();
    }
  }

  Future<void> release(String id) async {
    if (await _run(() async {
      await api.request('POST', 'vehicles/${vehicle.id}/calendar/$id/release');
    })) {
      await load();
    }
  }

  Future<bool> _run(Future<void> Function() action) async {
    if (_disposed || busy) return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (failure) {
      if (!_disposed) error = failure.toString();
      return false;
    } finally {
      if (!_disposed) {
        busy = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
