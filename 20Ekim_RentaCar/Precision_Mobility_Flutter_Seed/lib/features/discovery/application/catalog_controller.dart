import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../domain/vehicle.dart';

class CatalogController extends ChangeNotifier {
  CatalogController(this.api);
  final ApiClient api;
  List<Vehicle> vehicles = [];
  bool loading = false;
  String? error;
  int _request = 0;
  bool _disposed = false, _workspace = false;
  DateTime? _start, _end;
  Future<void> refresh() =>
      load(start: _start, end: _end, workspace: _workspace);

  Future<void> load(
      {DateTime? start, DateTime? end, bool workspace = false}) async {
    if (_disposed) return;
    _start = start;
    _end = end;
    _workspace = workspace;
    final request = ++_request;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await api.get(workspace ? 'workspace' : 'vehicles',
          query: start == null || end == null
              ? null
              : {'start': dateKey(start), 'end': dateKey(end)});
      final values = (result['vehicles'] as List)
          .map((v) => Vehicle.fromJson(v as Map<String, dynamic>))
          .toList();
      if (!_disposed && request == _request) {
        vehicles = List.unmodifiable(values);
      }
    } catch (failure) {
      if (!_disposed && request == _request) {
        vehicles = [];
        error = failure is ApiException
            ? failure.message
            : 'Araç bilgileri okunamadı.';
      }
    } finally {
      if (!_disposed && request == _request) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<Vehicle> save(Map<String, dynamic> body, {String? id}) async {
    final response = await api.request(
        id == null ? 'POST' : 'PUT', id == null ? 'vehicles' : 'vehicles/$id',
        body: body);
    return Vehicle.fromJson(response['vehicle'] as Map<String, dynamic>);
  }

  void clear() {
    _request++;
    vehicles = [];
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
