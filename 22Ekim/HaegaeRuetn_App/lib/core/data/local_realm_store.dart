import 'package:shared_preferences/shared_preferences.dart';

abstract class RealmStore {
  Future<String?> read();
  Future<void> write(String encoded);
}

class LocalRealmStore implements RealmStore {
  static const _key = 'haegaruuetn_realm_v1';

  @override
  Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  @override
  Future<void> write(String encoded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, encoded);
  }
}
