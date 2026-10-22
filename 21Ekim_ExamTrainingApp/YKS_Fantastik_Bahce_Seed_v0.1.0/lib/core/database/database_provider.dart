import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'schema.dart';

class GardenDatabaseProvider {
  GardenDatabaseProvider._();
  static final GardenDatabaseProvider instance = GardenDatabaseProvider._();

  Database? _database;

  static void initializeFfiIfRequired() {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }
    _database = await open();
    return _database!;
  }

  Future<Database> open({
    String dbName = 'fantastik_bahce.db',
    int version = GardenDatabaseSchema.currentVersion,
    DatabaseFactory? customFactory,
  }) async {
    initializeFfiIfRequired();
    final factory = customFactory ?? databaseFactory;

    final dbPath = await factory.getDatabasesPath();
    final path = p.join(dbPath, dbName);

    return await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: version,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, ver) async {
          await GardenDatabaseSchema.createTables(db);
        },
        onUpgrade: (db, oldVer, newVer) async {
          await GardenDatabaseSchema.onUpgrade(db, oldVer, newVer);
        },
      ),
    );
  }

  /// Birim ve widget testlerinde izole bellek içi veritabanı açar.
  static Future<Database> openInMemory({
    int version = GardenDatabaseSchema.currentVersion,
  }) async {
    initializeFfiIfRequired();
    return await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: version,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, ver) async {
          await GardenDatabaseSchema.createTables(db);
        },
        onUpgrade: (db, oldVer, newVer) async {
          await GardenDatabaseSchema.onUpgrade(db, oldVer, newVer);
        },
      ),
    );
  }

  @visibleForTesting
  void setDatabaseForTesting(Database? db) {
    _database = db;
  }

  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
