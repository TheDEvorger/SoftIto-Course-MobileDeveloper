import 'package:precision_mobility/features/rental/data/rental_storage.dart';

class MemoryRentalStorage implements RentalStorage {
  String? value;
  bool failRead = false, failWrite = false;
  int writes = 0;
  @override
  Future<String?> read() async {
    if (failRead) throw StateError('test read failure');
    return value;
  }

  @override
  Future<void> write(String next) async {
    if (failWrite) throw StateError('test write failure');
    value = next;
    writes++;
  }
}
