import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'app/meheng_app.dart';
import 'core/database/app_database.dart';
import 'core/database/database_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationSupportDirectory();
  final file = '${directory.path}${Platform.pathSeparator}meheng.sqlite';
  final database = AppDatabase.open(file);
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const MehengApp(),
    ),
  );
}
