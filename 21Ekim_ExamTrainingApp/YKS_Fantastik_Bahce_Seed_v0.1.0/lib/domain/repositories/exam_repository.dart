import 'package:sqflite/sqflite.dart';

import '../../core/database/schema.dart';
import '../models/exam_record.dart';

class ExamRepository {
  ExamRepository(this.db);
  final Database db;

  Future<void> saveExam(ExamSession session) async {
    await db.transaction((txn) async {
      await txn.insert(
        GardenDatabaseSchema.tableExamSessions,
        session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Eski skorları temizle (güncelleme durumunda)
      await txn.delete(
        GardenDatabaseSchema.tableExamScores,
        where: 'exam_id = ?',
        whereArgs: [session.id],
      );

      for (final score in session.scores) {
        await txn.insert(
          GardenDatabaseSchema.tableExamScores,
          score.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<ExamSession>> getExams({String? stage}) async {
    final sessionMaps = await db.query(
      GardenDatabaseSchema.tableExamSessions,
      where: stage != null ? 'stage = ?' : null,
      whereArgs: stage != null ? [stage] : null,
      orderBy: 'occurred_at DESC',
    );

    final results = <ExamSession>[];
    for (final sMap in sessionMaps) {
      final examId = sMap['id'] as String;
      final scoreMaps = await db.query(
        GardenDatabaseSchema.tableExamScores,
        where: 'exam_id = ?',
        whereArgs: [examId],
      );
      final scores = scoreMaps.map(ExamScore.fromMap).toList();
      results.add(ExamSession.fromMap(sMap, scores: scores));
    }
    return results;
  }

  Future<ExamSession?> getExamById(String id) async {
    final maps = await db.query(
      GardenDatabaseSchema.tableExamSessions,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;

    final scoreMaps = await db.query(
      GardenDatabaseSchema.tableExamScores,
      where: 'exam_id = ?',
      whereArgs: [id],
    );
    final scores = scoreMaps.map(ExamScore.fromMap).toList();
    return ExamSession.fromMap(maps.first, scores: scores);
  }

  Future<void> deleteExam(String id) async {
    await db.transaction((txn) async {
      await txn.delete(
        GardenDatabaseSchema.tableExamScores,
        where: 'exam_id = ?',
        whereArgs: [id],
      );
      await txn.delete(
        GardenDatabaseSchema.tableExamSessions,
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<int> getExamCount({String? stage}) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM ${GardenDatabaseSchema.tableExamSessions} ${stage != null ? "WHERE stage = ?" : ""}',
        stage != null ? [stage] : null,
      ),
    );
    return count ?? 0;
  }
}
