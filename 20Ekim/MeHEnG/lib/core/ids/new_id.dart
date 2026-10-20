import 'dart:math';

final _random = Random.secure();
String newId() {
  final millis = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final salt = _random.nextInt(1 << 30).toRadixString(36);
  return '$millis-$salt';
}
