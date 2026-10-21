import 'package:sqflite/sqflite.dart';

import '../../core/database/schema.dart';
import '../models/focus_record.dart';

class FocusRepository {
  FocusRepository(this.db);
  final Database db;

  Future<void> saveFocusSession(FocusSession session) async {
    await db.insert(
      GardenDatabaseSchema.tableFocusSessions,
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FocusSession>> getAllSessions() async {
    final maps = await db.query(
      GardenDatabaseSchema.tableFocusSessions,
      orderBy: 'started_at DESC',
    );
    return maps.map(FocusSession.fromMap).toList();
  }

  Future<int> getTotalElapsedSeconds() async {
    final result = await db.rawQuery(
      'SELECT SUM(elapsed_seconds) as total FROM ${GardenDatabaseSchema.tableFocusSessions}',
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toInt();
    }
    return 0;
  }
}
