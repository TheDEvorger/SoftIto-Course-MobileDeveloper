import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:precision_mobility/core/network/api_client.dart';
import 'package:precision_mobility/features/discovery/domain/vehicle.dart';

void check(bool value, String name) {
  if (!value) throw StateError(name);
}

Future<(Process, ApiClient)> start(Directory state) async {
  final process = await Process.start(
      'python3', ['-m', 'server', '--port', '0', '--state-dir', state.path]);
  final ready = Completer<Uri>();
  process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
    const prefix = 'Precision local API: ';
    if (line.startsWith(prefix) && !ready.isCompleted) {
      ready.complete(Uri.parse(line.substring(prefix.length)));
    }
  });
  process.stderr.drain<void>();
  try {
    final api = ApiClient(
        baseUri: await ready.future.timeout(const Duration(seconds: 15)));
    api.workspaceKey =
        (await File('${state.path}/operator.key').readAsString()).trim();
    return (process, api);
  } catch (_) {
    process.kill();
    await process.exitCode;
    rethrow;
  }
}

Future<void> main() async {
  final state =
      await Directory.systemTemp.createTemp('precision-restore-check-');
  Process? process;
  ApiClient? api;
  try {
    final initial = await start(state);
    process = initial.$1;
    api = initial.$2;
    check(((await api.get('vehicles'))['vehicles'] as List).isEmpty,
        'No fixture fallback');
    final vehicle = (await api.request('POST', 'vehicles', body: {
      'name': 'Isolated HTTP test record',
      'category': 'Sedan',
      'energy': 'Elektrik',
      'seats': 5,
      'rate_minor': 98765,
      'ownership': 'private',
      'description': 'Temporary test.',
      'photo_url': '',
      'status': 'active',
    }))['vehicle'] as Map;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final body = {
      'vehicle_id': vehicle['id'],
      'starts_on': dateKey(tomorrow),
      'ends_on': dateKey(tomorrow.add(const Duration(days: 2)))
    };
    final quote =
        (await api.request('POST', 'quotes', body: body))['quote'] as Map;
    final quotedBody = {...body, 'quote_token': quote['token']};
    final record = (await api.request('POST', 'reservations',
        body: quotedBody, requestKey: 'repeatable'))['reservation'] as Map;
    check(record['total_minor'] == 197530, 'Server pricing');
    final repeat = (await api.request('POST', 'reservations',
        body: quotedBody, requestKey: 'repeatable'))['reservation'] as Map;
    check(repeat['id'] == record['id'], 'Idempotency');
    var denied = false;
    try {
      await api.request('POST', 'reservations',
          body: quotedBody, requestKey: 'conflict');
    } on ApiException catch (error) {
      denied = error.status == 409;
    }
    check(denied, 'Overlap denied');
    await api.request('POST', 'reservations/${record['id']}/cancel');
    final privateKey = api.workspaceKey!;
    await api.openExamples();
    check(((await api.get('workspace'))['vehicles'] as List).length == 10,
        'Isolated populated workspace');
    var isolated = false;
    try {
      await api.request('GET', 'workspace', operational: true);
    } on ApiException catch (error) {
      isolated = error.status == 401;
    }
    check(isolated, 'Example key cannot access private data');
    await api.request('POST', 'reservations/example-plan-1/cancel');
    await api.request('PUT', 'vehicles/example-aster/publication',
        body: {'published': false});
    await api.connectWorkspace(privateKey);
    check(((await api.get('workspace'))['vehicles'] as List).length == 1,
        'Switch returns to private records');
    api.close();
    process.kill();
    await process.exitCode;
    final restart = await start(state);
    process = restart.$1;
    api = restart.$2;
    final records = (await api.get('reservations'))['reservations'] as List;
    check(
        records.length == 1 && (records.single as Map)['status'] == 'cancelled',
        'Restart persistence');
    check(((await api.get('vehicles'))['vehicles'] as List).length == 1,
        'Inventory persistence');
    await api.openExamples();
    final exampleVehicles = (await api.get('workspace'))['vehicles'] as List;
    final aster = exampleVehicles
        .cast<Map>()
        .firstWhere((v) => v['id'] == 'example-aster');
    check(aster['published'] == 0,
        'Sample edits survive restart without reseeding');
    final exampleRecords =
        (await api.get('reservations'))['reservations'] as List;
    check(
        exampleRecords
                .cast<Map>()
                .firstWhere((r) => r['id'] == 'example-plan-1')['status'] ==
            'cancelled',
        'Sample cancellation survives restart');
    stdout.writeln(
        'PASS: real Dart HTTP → SQLite quote/create/reserve/conflict/cancel/restart; isolated persistent examples.');
  } finally {
    api?.close();
    process?.kill();
    if (process != null) await process.exitCode;
    await state.delete(recursive: true);
  }
}
