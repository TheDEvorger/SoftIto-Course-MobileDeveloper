import 'package:shared_preferences/shared_preferences.dart';

abstract interface class RentalStorage {
  Future<String?> read();
  Future<void> write(String value);
}

/// Local planning data only: no customer identity, payment or supplier contract.
class DeviceRentalStorage implements RentalStorage {
  final _preferences = SharedPreferencesAsync();
  static const key = 'precision.renter.v1';
  @override
  Future<String?> read() => _preferences.getString(key);
  @override
  Future<void> write(String value) => _preferences.setString(key, value);
}
