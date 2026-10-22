import 'dart:convert';
import 'package:sqflite/sqflite.dart';

import 'schema.dart';

class BackupService {
  BackupService(this.db);
  final Database db;

  /// Tüm kullanıcı verilerini kayıpsız JSON olarak dışa aktarır.
  Future<String> exportAllDataAsJson() async {
    final prefs = await db.query(GardenDatabaseSchema.tablePreferences);
    final exams = await db.query(GardenDatabaseSchema.tableExamSessions);
    final scores = await db.query(GardenDatabaseSchema.tableExamScores);
    final progress = await db.query(GardenDatabaseSchema.tableTopicProgress);
    final tasks = await db.query(GardenDatabaseSchema.tableDailyTasks);
    final focus = await db.query(GardenDatabaseSchema.tableFocusSessions);

    final exportData = {
      'metadata': {
        'app': 'Fantastik Bahçe YKS',
        'version': GardenDatabaseSchema.currentVersion,
        'exportedAt': DateTime.now().toIso8601String(),
      },
      'preferences': prefs,
      'exam_sessions': exams,
      'exam_scores': scores,
      'topic_progress': progress,
      'daily_tasks': tasks,
      'focus_sessions': focus,
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  /// Kullanıcının tüm verilerini yerel veritabanından kalıcı olarak siler.
  Future<void> clearAllUserData() async {
    await db.transaction((txn) async {
      await txn.delete(GardenDatabaseSchema.tableExamScores);
      await txn.delete(GardenDatabaseSchema.tableExamSessions);
      await txn.delete(GardenDatabaseSchema.tableTopicProgress);
      await txn.delete(GardenDatabaseSchema.tableDailyTasks);
      await txn.delete(GardenDatabaseSchema.tableFocusSessions);

      // Tercihleri varsayılan boş duruma getir
      await txn.delete(GardenDatabaseSchema.tablePreferences);
      await txn.insert(
        GardenDatabaseSchema.tablePreferences,
        {
          'id': 'current',
          'display_name': null,
          'field': 'Sayısal',
          'target_date': null,
          'target_net': null,
          'theme_mode': 'system',
          'humorous_exit_enabled': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }
}
