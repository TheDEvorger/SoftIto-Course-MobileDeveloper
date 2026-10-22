import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/garden_theme.dart';
import 'package:fantastik_bahce_yks/domain/exam/net_calculator.dart';
import 'package:fantastik_bahce_yks/domain/models/exam_record.dart';
import 'package:fantastik_bahce_yks/domain/repositories/exam_repository.dart';
import 'package:fantastik_bahce_yks/features/exams/presentation/exams_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TASK-006: Exam CRUD & Net Rules Tests', () {
    late Database db;
    late ExamRepository repo;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      repo = ExamRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Net calculation rules: 30D 8Y => 28.0N', () {
      final net = NetCalculator.calculate(correct: 30, wrong: 8);
      expect(net, 28.0);

      // Question count boundary check
      expect(
        NetCalculator.fitsExam(correct: 30, wrong: 8, questionCount: 40),
        isTrue,
      );
      // Overflow rejection
      expect(
        NetCalculator.fitsExam(correct: 35, wrong: 10, questionCount: 40),
        isFalse,
      );
      // Negative rejection
      expect(
        NetCalculator.fitsExam(correct: -1, wrong: 5, questionCount: 40),
        isFalse,
      );
    });

    test('ExamRepository: save, retrieve, edit, and delete exam', () async {
      final session = ExamSession(
        id: 'test_tyt_1',
        stage: 'TYT',
        title: 'Özdebir Türkiye Geneli TYT',
        occurredAt: DateTime(2026, 3, 15),
        scope: 'general',
        totalCorrect: 85,
        totalWrong: 20,
        totalBlank: 15,
        totalNet: 80.0,
        scores: const [
          ExamScore(
            id: 'score_turkce',
            examId: 'test_tyt_1',
            subjectId: 'tyt_turkce',
            subjectName: 'Türkçe',
            correct: 32,
            wrong: 6,
            blank: 2,
            net: 30.5,
          ),
          ExamScore(
            id: 'score_mat',
            examId: 'test_tyt_1',
            subjectId: 'tyt_mat',
            subjectName: 'Temel Matematik',
            correct: 28,
            wrong: 4,
            blank: 8,
            net: 27.0,
          ),
        ],
      );

      // Save
      await repo.saveExam(session);

      // Retrieve
      final list = await repo.getExams(stage: 'TYT');
      expect(list.length, 1);
      expect(list.first.title, 'Özdebir Türkiye Geneli TYT');
      expect(list.first.totalNet, 80.0);
      expect(list.first.scores.length, 2);

      // Edit
      final updated = session.copyWith(
        title: 'Özdebir TYT (Revize)',
        totalNet: 82.5,
      );
      await repo.saveExam(updated);

      final retrieved = await repo.getExamById('test_tyt_1');
      expect(retrieved?.title, 'Özdebir TYT (Revize)');
      expect(retrieved?.totalNet, 82.5);

      // Delete
      await repo.deleteExam('test_tyt_1');
      final afterDelete = await repo.getExams(stage: 'TYT');
      expect(afterDelete, isEmpty);
    });

    testWidgets(
        'ExamsScreen shows empty state initially and adds exam via quick calculator',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: Scaffold(
            body: ExamsScreen(repository: repo),
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Header and empty state check
      expect(find.text('Deneme Takip Masası'), findsOneWidget);
      expect(find.text('Henüz Kayıtlı TYT Denemen Yok'), findsOneWidget);

      // Scroll to quick calculator
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();

      // Quick calculator is present
      expect(find.text('Hızlı Net Hesaplayıcı'), findsOneWidget);
      expect(find.text('Bu Neti Denemelerime Ekle'), findsOneWidget);
      await tester.tap(find.text('Bu Neti Denemelerime Ekle'));

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Scroll back up
      await tester.drag(find.byType(ListView), const Offset(0, 500));
      await tester.pump();

      // Exam should now be listed
      expect(find.text('Henüz Kayıtlı TYT Denemen Yok'), findsNothing);
      expect(find.text('Hızlı Branş Denemesi'), findsOneWidget);
      expect(find.text('28.00'), findsWidgets);
    });
  });
}
