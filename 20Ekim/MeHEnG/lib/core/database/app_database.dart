import 'package:sqlite3/sqlite3.dart';
import 'schema_v2.dart';
import 'schema_v3.dart';

class AppDatabase {
  AppDatabase._(this.db);
  final Database db;

  factory AppDatabase.open(String path) {
    final result = AppDatabase._(sqlite3.open(path));
    result._initialize();
    return result;
  }

  factory AppDatabase.inMemory() {
    final result = AppDatabase._(sqlite3.openInMemory());
    result._initialize();
    return result;
  }

  void _initialize() {
    db.execute('PRAGMA foreign_keys = ON');
    final version = db.select('PRAGMA user_version').first.values.first as int;
    if (version > 3) {
      throw StateError('Database version $version is newer than app.');
    }
    if (version == 0) {
      db.execute('BEGIN TRANSACTION');
      try {
        createSchemaV3(db);
        db.execute('PRAGMA user_version = 3');
        db.execute('COMMIT');
      } catch (_) {
        db.execute('ROLLBACK');
        rethrow;
      }
    } else {
      if (version == 1) {
        db.execute('BEGIN TRANSACTION');
        try {
          migrateV1ToV2(db);
          migrateV2ToV3(db);
          db.execute('PRAGMA user_version = 3');
          db.execute('COMMIT');
        } catch (_) {
          db.execute('ROLLBACK');
          rethrow;
        }
      } else if (version == 2) {
        db.execute('BEGIN TRANSACTION');
        try {
          migrateV2ToV3(db);
          db.execute('PRAGMA user_version = 3');
          db.execute('COMMIT');
        } catch (_) {
          db.execute('ROLLBACK');
          rethrow;
        }
      }
    }
  }

  void dispose() => db.close();
}
