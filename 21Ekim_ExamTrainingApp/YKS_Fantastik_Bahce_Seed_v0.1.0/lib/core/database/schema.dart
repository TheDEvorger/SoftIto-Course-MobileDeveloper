import 'package:sqflite/sqflite.dart';

abstract final class GardenDatabaseSchema {
  static const int currentVersion = 1;

  static const String tablePreferences = 'preferences';
  static const String tableSubjects = 'subjects';
  static const String tableTopics = 'topics';
  static const String tableTopicProgress = 'topic_progress';
  static const String tableExamSessions = 'exam_sessions';
  static const String tableExamScores = 'exam_scores';
  static const String tableDailyTasks = 'daily_tasks';
  static const String tableFocusSessions = 'focus_sessions';

  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE $tablePreferences (
        id TEXT PRIMARY KEY,
        display_name TEXT,
        field TEXT NOT NULL,
        target_date TEXT,
        target_net REAL,
        theme_mode TEXT NOT NULL,
        humorous_exit_enabled INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableSubjects (
        id TEXT PRIMARY KEY,
        stage TEXT NOT NULL,
        name TEXT NOT NULL,
        order_index INTEGER NOT NULL,
        question_count INTEGER NOT NULL DEFAULT 40
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTopics (
        id TEXT PRIMARY KEY,
        subject_id TEXT NOT NULL,
        name TEXT NOT NULL,
        order_index INTEGER NOT NULL,
        curriculum_year INTEGER NOT NULL DEFAULT 2026,
        FOREIGN KEY (subject_id) REFERENCES $tableSubjects(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTopicProgress (
        topic_id TEXT PRIMARY KEY,
        status TEXT NOT NULL,
        answered_count INTEGER NOT NULL DEFAULT 0,
        last_studied_at TEXT,
        FOREIGN KEY (topic_id) REFERENCES $tableTopics(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableExamSessions (
        id TEXT PRIMARY KEY,
        stage TEXT NOT NULL,
        title TEXT NOT NULL,
        occurred_at TEXT NOT NULL,
        scope TEXT NOT NULL DEFAULT 'general',
        total_correct INTEGER NOT NULL DEFAULT 0,
        total_wrong INTEGER NOT NULL DEFAULT 0,
        total_blank INTEGER NOT NULL DEFAULT 0,
        total_net REAL NOT NULL DEFAULT 0.0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableExamScores (
        id TEXT PRIMARY KEY,
        exam_id TEXT NOT NULL,
        subject_id TEXT NOT NULL,
        subject_name TEXT NOT NULL,
        correct INTEGER NOT NULL DEFAULT 0,
        wrong INTEGER NOT NULL DEFAULT 0,
        blank INTEGER NOT NULL DEFAULT 0,
        net REAL NOT NULL DEFAULT 0.0,
        FOREIGN KEY (exam_id) REFERENCES $tableExamSessions(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableDailyTasks (
        id TEXT PRIMARY KEY,
        scheduled_date TEXT NOT NULL,
        description TEXT NOT NULL,
        subject_id TEXT,
        topic_id TEXT,
        target_questions INTEGER NOT NULL DEFAULT 0,
        is_done INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableFocusSessions (
        id TEXT PRIMARY KEY,
        started_at TEXT NOT NULL,
        duration_seconds INTEGER NOT NULL,
        elapsed_seconds INTEGER NOT NULL,
        subject_id TEXT,
        completed INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      // Örnek sürüm 2 migration adımı: indeksler veya ek metadata
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_exam_occurred ON $tableExamSessions(occurred_at)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_tasks_date ON $tableDailyTasks(scheduled_date)',
      );
    }
  }
}
