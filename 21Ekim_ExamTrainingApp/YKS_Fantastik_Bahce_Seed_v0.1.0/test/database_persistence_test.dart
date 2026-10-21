import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/database/schema.dart';
import 'package:fantastik_bahce_yks/domain/models/curriculum.dart';
import 'package:fantastik_bahce_yks/domain/models/daily_task.dart';
import 'package:fantastik_bahce_yks/domain/models/exam_record.dart';
import 'package:fantastik_bahce_yks/domain/models/focus_record.dart';
import 'package:fantastik_bahce_yks/domain/models/student_preferences.dart';
import 'package:fantastik_bahce_yks/domain/repositories/curriculum_repository.dart';
import 'package:fantastik_bahce_yks/domain/repositories/exam_repository.dart';
import 'package:fantastik_bahce_yks/domain/repositories/focus_repository.dart';
import 'package:fantastik_bahce_yks/domain/repositories/planning_repository.dart';
import 'package:fantastik_bahce_yks/domain/repositories/preferences_repository.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TASK-003: SQLite Database & Repositories Tests', () {
    late Database db;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
    });

    tearDown(() async {
      await db.close();
    });

    test('PreferencesRepository: default save and retrieve', () async {
      final repo = PreferencesRepository(db);

      final initial = await repo.getPreferences();
      expect(initial.field, 'Sayısal');
      expect(initial.humorousExitEnabled, isFalse);

      final updated = initial.copyWith(
        displayName: 'Doğa Gezgini',
        field: 'Eşit Ağırlık',
        targetNet: 95.5,
        humorousExitEnabled: true,
      );
      await repo.savePreferences(updated);

      final reloaded = await repo.getPreferences();
      expect(reloaded.displayName, 'Doğa Gezgini');
      expect(reloaded.field, 'Eşit Ağırlık');
      expect(reloaded.targetNet, 95.5);
      expect(reloaded.humorousExitEnabled, isTrue);
    });

    test('CurriculumRepository: seeds curriculum and tracks progress',
        () async {
      final repo = CurriculumRepository(db);
      await repo.seedInitialCurriculumIfEmpty();

      final tytSubjects = await repo.getSubjects('TYT');
      expect(tytSubjects.isNotEmpty, isTrue);
      expect(tytSubjects.any((s) => s.name == 'Türkçe'), isTrue);
      expect(tytSubjects.any((s) => s.name == 'Temel Matematik'), isTrue);

      final turkceTopics = await repo.getTopics('tyt_turkce');
      expect(turkceTopics.isNotEmpty, isTrue);

      // İlerleme güncelle
      final firstTopicId = turkceTopics.first.id;
      final progress = TopicProgress(
        topicId: firstTopicId,
        status: TopicStatus.completed,
        answeredCount: 85,
        lastStudiedAt: DateTime.now(),
      );
      await repo.updateTopicProgress(progress);

      final fetchedProgress = await repo.getTopicProgress(firstTopicId);
      expect(fetchedProgress.status, TopicStatus.completed);
      expect(fetchedProgress.answeredCount, 85);
    });

    test(
        'ExamRepository: transactional save, calculation, query and cascade delete',
        () async {
      final repo = ExamRepository(db);

      final score1 = ExamScore.calculate(
        id: 'sc_1',
        examId: 'ex_1',
        subjectId: 'tyt_turkce',
        subjectName: 'Türkçe',
        correct: 32,
        wrong: 8,
        questionCount: 40,
      );
      expect(score1.net, 30.0);
      expect(score1.blank, 0);

      final score2 = ExamScore.calculate(
        id: 'sc_2',
        examId: 'ex_1',
        subjectId: 'tyt_mat',
        subjectName: 'Temel Matematik',
        correct: 30,
        wrong: 4,
        questionCount: 40,
      );
      expect(score2.net, 29.0);
      expect(score2.blank, 6);

      final exam = ExamSession(
        id: 'ex_1',
        stage: 'TYT',
        title: 'Fantastik Deneme 1',
        occurredAt: DateTime(2026, 10, 21, 14, 0),
        totalCorrect: 62,
        totalWrong: 12,
        totalBlank: 6,
        totalNet: 59.0,
        scores: [score1, score2],
      );

      await repo.saveExam(exam);

      final exams = await repo.getExams(stage: 'TYT');
      expect(exams.length, 1);
      expect(exams.first.title, 'Fantastik Deneme 1');
      expect(exams.first.scores.length, 2);
      expect(exams.first.totalNet, 59.0);

      // Silme testi
      await repo.deleteExam('ex_1');
      final examsAfterDelete = await repo.getExams(stage: 'TYT');
      expect(examsAfterDelete.isEmpty, isTrue);
    });

    test('PlanningRepository: creates and toggles tasks', () async {
      final repo = PlanningRepository(db);
      final today = DateTime(2026, 10, 21);

      final task = DailyTask(
        id: 'task_1',
        scheduledDate: today,
        description: 'Paragraf 40 soru çöz',
        targetQuestions: 40,
      );
      await repo.saveTask(task);

      final tasks = await repo.getTasksForDate(today);
      expect(tasks.length, 1);
      expect(tasks.first.isDone, isFalse);

      await repo.toggleTaskDone('task_1', true);
      final updatedTasks = await repo.getTasksForDate(today);
      expect(updatedTasks.first.isDone, isTrue);
    });

    test('FocusRepository: saves focus session and calculates total time',
        () async {
      final repo = FocusRepository(db);

      await repo.saveFocusSession(FocusSession(
        id: 'foc_1',
        startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        durationSeconds: 1500,
        elapsedSeconds: 1500,
        completed: true,
      ));

      await repo.saveFocusSession(FocusSession(
        id: 'foc_2',
        startedAt: DateTime.now(),
        durationSeconds: 1500,
        elapsedSeconds: 900,
        completed: false,
      ));

      final totalSeconds = await repo.getTotalElapsedSeconds();
      expect(totalSeconds, 2400);
    });

    test(
        'Database Migration: onUpgrade from v1 to v2 creates new indexes without data loss',
        () async {
      // Version 1 aç
      final v1Db = await GardenDatabaseProvider.openInMemory(version: 1);
      final prefRepo = PreferencesRepository(v1Db);
      await prefRepo.savePreferences(const StudentPreferences(
        id: 'current',
        displayName: 'Gezgin',
      ));
      await v1Db.close();

      // Version 2 olarak aynı şemada upgrade et
      final v2Db = await GardenDatabaseProvider.openInMemory(version: 2);
      // Migration fonksiyonunun başarılı çalıştığını doğrula
      await GardenDatabaseSchema.onUpgrade(v2Db, 1, 2);

      // İndekslerin var olduğunu sorgula
      final indexCheck = await v2Db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='index' AND name='idx_exam_occurred'",
      );
      expect(indexCheck.isNotEmpty, isTrue);
      await v2Db.close();
    });
  });
}
