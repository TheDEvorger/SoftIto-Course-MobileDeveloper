import 'package:sqflite/sqflite.dart';

import '../../core/database/schema.dart';
import '../models/daily_task.dart';

class PlanningRepository {
  PlanningRepository(this.db);
  final Database db;

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<List<DailyTask>> getTasksForDate(DateTime date) async {
    final dateString = _formatDate(date);
    final maps = await db.query(
      GardenDatabaseSchema.tableDailyTasks,
      where: 'scheduled_date = ?',
      whereArgs: [dateString],
      orderBy: 'is_done ASC, id ASC',
    );
    return maps.map(DailyTask.fromMap).toList();
  }

  Future<void> saveTask(DailyTask task) async {
    await db.insert(
      GardenDatabaseSchema.tableDailyTasks,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> toggleTaskDone(String taskId, bool isDone) async {
    await db.update(
      GardenDatabaseSchema.tableDailyTasks,
      {'is_done': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> deleteTask(String taskId) async {
    await db.delete(
      GardenDatabaseSchema.tableDailyTasks,
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}
