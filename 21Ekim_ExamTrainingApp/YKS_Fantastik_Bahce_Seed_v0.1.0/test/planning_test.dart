import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/garden_theme.dart';
import 'package:fantastik_bahce_yks/domain/models/daily_task.dart';
import 'package:fantastik_bahce_yks/domain/models/student_preferences.dart';
import 'package:fantastik_bahce_yks/domain/repositories/planning_repository.dart';
import 'package:fantastik_bahce_yks/domain/repositories/preferences_repository.dart';
import 'package:fantastik_bahce_yks/features/home/presentation/home_screen.dart';
import 'package:fantastik_bahce_yks/features/planning/presentation/daily_plan_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TASK-009: PlanningRepository Logic Tests', () {
    late Database db;
    late PlanningRepository repo;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      repo = PlanningRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveTask, getTasksForDate and getSummaryForDate accuracy', () async {
      final today = DateTime(2026, 10, 21);
      final tomorrow = DateTime(2026, 10, 22);

      final task1 = DailyTask(
        id: 't1',
        scheduledDate: today,
        description: 'Türkçe Paragraf',
        targetQuestions: 40,
        isDone: false,
      );

      final task2 = DailyTask(
        id: 't2',
        scheduledDate: today,
        description: 'Matematik Problemler',
        targetQuestions: 30,
        isDone: true,
      );

      final taskTomorrow = DailyTask(
        id: 't3',
        scheduledDate: tomorrow,
        description: 'Fizik Kuvvet',
        targetQuestions: 25,
        isDone: false,
      );

      await repo.saveTask(task1);
      await repo.saveTask(task2);
      await repo.saveTask(taskTomorrow);

      // Verify date filtering
      final todayTasks = await repo.getTasksForDate(today);
      expect(todayTasks.length, 2);

      final tomorrowTasks = await repo.getTasksForDate(tomorrow);
      expect(tomorrowTasks.length, 1);
      expect(tomorrowTasks.first.description, 'Fizik Kuvvet');

      // Verify summary calculations
      final summary = await repo.getSummaryForDate(today);
      expect(summary.totalTasks, 2);
      expect(summary.completedTasks, 1);
      expect(summary.taskProgress, 0.5);
      expect(summary.targetQuestions, 70);
      expect(summary.completedQuestions, 30);
      expect(summary.questionProgress, closeTo(30 / 70, 0.001));

      // Toggle task1 to done
      await repo.toggleTaskDone('t1', true);
      final updatedSummary = await repo.getSummaryForDate(today);
      expect(updatedSummary.completedTasks, 2);
      expect(updatedSummary.taskProgress, 1.0);
      expect(updatedSummary.completedQuestions, 70);
      expect(updatedSummary.questionProgress, 1.0);

      // Delete task
      await repo.deleteTask('t1');
      final afterDelete = await repo.getTasksForDate(today);
      expect(afterDelete.length, 1);
      expect(afterDelete.first.id, 't2');
    });
  });

  group('TASK-009: DailyPlanScreen & HomeScreen Integration Tests', () {
    late Database db;
    late PlanningRepository planRepo;
    late PreferencesRepository prefRepo;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      planRepo = PlanningRepository(db);
      prefRepo = PreferencesRepository(db);

      await prefRepo.savePreferences(
        const StudentPreferences(
          displayName: 'Elif',
          field: 'Eşit Ağırlık',
          targetNet: 90.0,
        ),
      );
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('DailyPlanScreen displays tasks and navigates dates',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final testDate = DateTime(2026, 10, 21);
      final task = DailyTask(
        id: 'plan_1',
        scheduledDate: testDate,
        description: 'Tarih Soru Çözümü',
        targetQuestions: 35,
        isDone: false,
      );

      await tester.runAsync(() async {
        await planRepo.saveTask(task);
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: DailyPlanScreen(
            planningRepository: planRepo,
            initialDate: testDate,
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Header and task presence
      expect(find.text('Günlük Çalışma Planı'), findsOneWidget);
      expect(find.text('Tarih Soru Çözümü'), findsOneWidget);
      expect(find.text('35 Soru Hedefi'), findsOneWidget);
      expect(find.text('0 / 1 Görev Bitti'), findsOneWidget);

      // Toggle checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('1 / 1 Görev Bitti'), findsOneWidget);
    });

    testWidgets(
        'HomeScreen integrates with PlanningRepository and shows daily tasks',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final today = DateTime.now();
      final task = DailyTask(
        id: 'home_task_1',
        scheduledDate: today,
        description: 'Paragraf 25 Soru',
        targetQuestions: 25,
        isDone: false,
      );

      await tester.runAsync(() async {
        await planRepo.saveTask(task);
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: Scaffold(
            body: HomeScreen(
              onStartFocus: () {},
              preferencesRepository: prefRepo,
              planningRepository: planRepo,
            ),
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Welcome and user name
      expect(find.text('Merhaba, Elif! 🌱'), findsOneWidget);

      // Daily goals header
      expect(find.text('Günün Hedefleri'), findsOneWidget);
      expect(find.text('Paragraf 25 Soru'), findsOneWidget);
      expect(find.text('0 / 25 Soru'), findsOneWidget);

      // Check off the task directly on home screen
      await tester.tap(find.byType(Checkbox).first);
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('25 / 25 Soru'), findsOneWidget);
    });
  });
}
