import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('AppDatabase must be injected by ProviderScope.');
});
