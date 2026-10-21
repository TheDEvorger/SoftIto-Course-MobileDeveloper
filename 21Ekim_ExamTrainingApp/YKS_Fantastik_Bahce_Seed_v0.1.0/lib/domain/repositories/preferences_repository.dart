import 'package:sqflite/sqflite.dart';

import '../../core/database/schema.dart';
import '../models/student_preferences.dart';

class PreferencesRepository {
  PreferencesRepository(this.db);
  final Database db;

  Future<StudentPreferences> getPreferences() async {
    final maps = await db.query(
      GardenDatabaseSchema.tablePreferences,
      where: 'id = ?',
      whereArgs: ['current'],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return StudentPreferences.fromMap(maps.first);
    }

    const defaultPrefs = StudentPreferences(id: 'current');
    await savePreferences(defaultPrefs);
    return defaultPrefs;
  }

  Future<void> savePreferences(StudentPreferences preferences) async {
    await db.insert(
      GardenDatabaseSchema.tablePreferences,
      preferences.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
