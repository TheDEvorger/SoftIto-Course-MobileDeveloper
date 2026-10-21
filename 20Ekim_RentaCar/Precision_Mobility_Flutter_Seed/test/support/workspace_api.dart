import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:precision_mobility/core/network/api_client.dart';

const testExampleKey = 'test-example-key-01234567890123456789';
const testWorkspaceKey = 'test-only-key-not-a-real-credential';
Map<String, dynamic> testVehicle() => {
      'id': 'test-car',
      'name': 'Test sedan',
      'category': 'Sedan',
      'energy': 'Elektrik',
      'seats': 5,
      'rate_minor': 123456,
      'ownership': 'fleet',
      'description': 'Test-only vehicle.',
      'photo_url': '',
      'status': 'active',
      'currency': 'TRY',
    };

class WorkspaceApiFixture {
  WorkspaceApiFixture({bool empty = false}) {
    if (!empty) vehicles.add(testVehicle());
    client = ApiClient(
        baseUri: Uri.parse('http://localhost:8765/api/v1/'),
        client: MockClient(_handle));
  }
  late final ApiClient client;
  final exampleVehicles = [
    {
      ...testVehicle(),
      'id': 'sample-car',
      'name': 'Aster Sample',
      'example': true,
      'artwork': 'touring'
    }
  ];
  final List<Map<String, dynamic>> exampleReservations = [];
  final List<Map<String, dynamic>> blocks = [];
  bool published = true;
  bool quoteUnavailable = false;
  final List<Map<String, dynamic>> vehicles = [], reservations = [];
  final List<http.Request> requests = [];
  Future<http.Response> _handle(http.Request request) async {
    requests.add(request);
    final rawParts = request.url.pathSegments;
    final example = rawParts[2] == 'examples';
    if (request.url.path.endsWith('/examples/session')) {
      return _json({'workspace_key': testExampleKey, 'example': true});
    }
    final parts = ['api', 'v1', ...rawParts.skip(example ? 3 : 2)];
    final path = '/${parts.join('/')}';
    final currentVehicles = example ? exampleVehicles : vehicles;
    final currentReservations = example ? exampleReservations : reservations;
    final public = request.method == 'GET' && path.endsWith('/vehicles');
    if (!public &&
        request.headers['Authorization'] !=
            'Bearer ${example ? testExampleKey : testWorkspaceKey}') {
      return _json({
        'error': {'message': 'Anahtar geçersiz.'}
      }, 401);
    }
    if (path.endsWith('/quotes')) {
      if (quoteUnavailable) {
        return _json({
          'error': {'message': 'Bu tarihler kapalı.'}
        }, 409);
      }
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      final v =
          currentVehicles.firstWhere((v) => v['id'] == body['vehicle_id']);
      final days = DateTime.parse(body['ends_on'] as String)
          .difference(DateTime.parse(body['starts_on'] as String))
          .inDays;
      return _json({
        'quote': {
          ...body,
          'rate_minor': v['rate_minor'],
          'total_minor': (v['rate_minor'] as int) * days,
          'currency': 'TRY',
          'token': 'test-quote',
          'expires_at': DateTime.now()
                  .add(const Duration(minutes: 5))
                  .millisecondsSinceEpoch ~/
              1000
        }
      });
    }
    if (path.endsWith('/publication')) {
      published = (jsonDecode(request.body) as Map)['published'] as bool;
      currentVehicles.firstWhere((v) => v['id'] == parts[3])['published'] =
          published;
      return _json({'published': published});
    }
    if (parts.contains('calendar')) {
      if (request.method == 'GET') {
        return _json({'blocks': blocks, 'reservations': []});
      }
      if (path.endsWith('/release')) {
        blocks.clear();
        return _json({'status': 'released'});
      }
      final block = {
        ...jsonDecode(request.body) as Map<String, dynamic>,
        'id': 'test-block'
      };
      blocks.add(block);
      return _json({'block': block}, 201);
    }
    if (path.endsWith('/workspace') ||
        (path.endsWith('/vehicles') && request.method == 'GET')) {
      return _json({'vehicles': currentVehicles});
    }
    if (parts[2] == 'vehicles' && ['POST', 'PUT'].contains(request.method)) {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      final vehicle = {
        ...body,
        'id': parts.length > 3 ? parts[3] : 'new-${currentVehicles.length}',
        'currency': 'TRY'
      };
      if (request.method == 'PUT') {
        currentVehicles.removeWhere((v) => v['id'] == vehicle['id']);
      }
      currentVehicles.add(vehicle);
      return _json({'vehicle': vehicle}, 201);
    }
    if (path.endsWith('/reservations') && request.method == 'GET') {
      return _json({'reservations': currentReservations});
    }
    if (path.endsWith('/reservations') && request.method == 'POST') {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      final v =
          currentVehicles.firstWhere((v) => v['id'] == body['vehicle_id']);
      final days = DateTime.parse(body['ends_on'] as String)
          .difference(DateTime.parse(body['starts_on'] as String))
          .inDays;
      final record = {
        ...body,
        'id': 'reservation-${currentReservations.length}',
        'vehicle_name': v['name'],
        'total_minor': (v['rate_minor'] as int) * days,
        'currency': 'TRY',
        'status': 'reserved'
      };
      currentReservations.add(record);
      return _json({'reservation': record}, 201);
    }
    if (path.endsWith('/cancel')) {
      final record = currentReservations.firstWhere((r) => r['id'] == parts[3])
        ..['status'] = 'cancelled';
      return _json({'reservation': record});
    }
    return _json({
      'error': {'message': 'Unknown test route'}
    }, 404);
  }

  http.Response _json(Map<String, dynamic> data, [int status = 200]) =>
      http.Response(jsonEncode(data), status,
          headers: {'content-type': 'application/json; charset=utf-8'});
}
