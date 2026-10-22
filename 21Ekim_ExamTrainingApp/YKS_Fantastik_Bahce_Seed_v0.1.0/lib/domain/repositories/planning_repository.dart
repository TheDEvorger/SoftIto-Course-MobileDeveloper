import 'package:sqflite/sqflite.dart';

import '../../core/database/schema.dart';
import '../models/daily_task.dart';

class DailyPlanSummary {
  const DailyPlanSummary({
    required this.totalTasks,
    required this.completedTasks,
    required this.targetQuestions,
    required this.completedQuestions,
  });

  final int totalTasks;
  final int completedTasks;
  final int targetQuestions;
  final int completedQuestions;

  double get taskProgress =>
      totalTasks > 0 ? (completedTasks / totalTasks).clamp(0.0, 1.0) : 0.0;

  double get questionProgress => targetQuestions > 0
      ? (completedQuestions / targetQuestions).clamp(0.0, 1.0)
      : 0.0;
}

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

  Future<DailyPlanSummary> getSummaryForDate(DateTime date) async {
    final tasks = await getTasksForDate(date);
    int completedTasks = 0;
    int targetQuestions = 0;
    int completedQuestions = 0;

    for (final t in tasks) {
      targetQuestions += t.targetQuestions;
      if (t.isDone) {
        completedTasks++;
        completedQuestions += t.targetQuestions;
      }
    }

    return DailyPlanSummary(
      totalTasks: tasks.length,
      completedTasks: completedTasks,
      targetQuestions: targetQuestions,
      completedQuestions: completedQuestions,
    );
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
