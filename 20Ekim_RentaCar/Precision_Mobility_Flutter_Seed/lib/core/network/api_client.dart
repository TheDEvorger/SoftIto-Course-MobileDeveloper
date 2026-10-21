import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message, {this.status});
  final String message;
  final int? status;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({required Uri baseUri, http.Client? client})
      : baseUri = validate(baseUri),
        _client = client ?? http.Client();
  final Uri baseUri;
  final http.Client _client;
  String? _workspaceKey;
  bool _examples = false;
  bool get examples => _examples;
  String? get workspaceKey => _workspaceKey;
  set workspaceKey(String? value) {
    _workspaceKey = value;
    _examples = false;
  }

  bool get authenticated => workspaceKey?.isNotEmpty ?? false;

  Future<void> openExamples() async {
    final result = await request('POST', 'examples/session',
        operational: true, credential: '');
    final key = result['workspace_key'];
    if (result['example'] != true || key is! String || key.length < 32) {
      throw const ApiException('Örnek çalışma alanı yanıtı geçersiz.');
    }
    _workspaceKey = key;
    _examples = true;
  }

  Future<void> connectWorkspace(String key) async {
    await request('GET', 'workspace', operational: true, credential: key);
    workspaceKey = key;
  }

  static Uri validate(Uri uri) {
    final local =
        ['localhost', '127.0.0.1', '10.0.2.2', '::1'].contains(uri.host);
    if ((uri.scheme != 'https' && !(uri.scheme == 'http' && local)) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw ArgumentError(
          'API adresi HTTPS veya yerel geliştirme adresi olmalı.');
    }
    return uri.replace(
        path: uri.path.endsWith('/') ? uri.path : '${uri.path}/');
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) =>
      request('GET', path, query: query);

  Future<Map<String, dynamic>> request(String method, String path,
      {Map<String, dynamic>? body,
      Map<String, String>? query,
      String? requestKey,
      bool operational = false,
      String? credential}) async {
    if (path.startsWith('/') ||
        path.contains('..') ||
        Uri.parse(path).hasScheme) {
      throw ArgumentError('Geçersiz API yolu.');
    }
    final scopedPath = _examples && !operational ? 'examples/$path' : path;
    final key = credential ?? workspaceKey;
    final request = http.Request(
        method, baseUri.resolve(scopedPath).replace(queryParameters: query))
      ..followRedirects = false
      ..headers['Accept'] = 'application/json';
    if (key?.isNotEmpty ?? false) {
      request.headers['Authorization'] = 'Bearer $key';
    }
    if (requestKey != null) request.headers['Idempotency-Key'] = requestKey;
    if (body != null) {
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      request.body = jsonEncode(body);
    }
    try {
      final response =
          await http.Response.fromStream(await _client.send(request))
              .timeout(const Duration(seconds: 10));
      if (response.bodyBytes.length > 2 * 1024 * 1024) {
        throw const FormatException();
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is! Map<String, dynamic>) throw const FormatException();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = data['error'];
        throw ApiException(
            error is Map && error['message'] is String
                ? error['message'] as String
                : 'Sunucu isteği tamamlayamadı.',
            status: response.statusCode);
      }
      return data;
    } on TimeoutException {
      throw const ApiException(
          'Sunucu yanıt vermedi. Bağlantıyı kontrol edip yeniden deneyin.');
    } on http.ClientException {
      throw const ApiException(
          'Sunucuya ulaşılamadı. Yerel sunucunun çalıştığını kontrol edin.');
    } on FormatException {
      throw const ApiException('Sunucu yanıtı beklenen biçimde değil.');
    }
  }

  void close() {
    workspaceKey = null;
    _client.close();
  }
}
