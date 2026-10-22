import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/garden_theme.dart';
import 'package:fantastik_bahce_yks/domain/models/exam_record.dart';
import 'package:fantastik_bahce_yks/domain/models/student_preferences.dart';
import 'package:fantastik_bahce_yks/domain/repositories/exam_repository.dart';
import 'package:fantastik_bahce_yks/domain/repositories/preferences_repository.dart';
import 'package:fantastik_bahce_yks/features/analytics/domain/analytics_models.dart';
import 'package:fantastik_bahce_yks/features/analytics/presentation/analytics_screen.dart';
import 'package:fantastik_bahce_yks/features/analytics/presentation/widgets/garden_line_chart.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TASK-007: Analytics Models & Calculation Tests', () {
    final exam1 = ExamSession(
      id: 'e1',
      stage: 'TYT',
      title: '1. TYT Denemesi',
      occurredAt: DateTime(2026, 1, 10),
      totalCorrect: 70,
      totalWrong: 20,
      totalBlank: 30,
      totalNet: 65.0,
      scores: const [
        ExamScore(
          id: 's1_tr',
          examId: 'e1',
          subjectId: 'tyt_turkce',
          subjectName: 'Türkçe',
          correct: 30,
          wrong: 8,
          blank: 2,
          net: 28.0,
        ),
        ExamScore(
          id: 's1_mat',
          examId: 'e1',
          subjectId: 'tyt_mat',
          subjectName: 'Temel Matematik',
          correct: 25,
          wrong: 4,
          blank: 11,
          net: 24.0,
        ),
      ],
    );

    final exam2 = ExamSession(
      id: 'e2',
      stage: 'TYT',
      title: '2. TYT Denemesi',
      occurredAt: DateTime(2026, 2, 15),
      totalCorrect: 80,
      totalWrong: 16,
      totalBlank: 24,
      totalNet: 76.0,
      scores: const [
        ExamScore(
          id: 's2_tr',
          examId: 'e2',
          subjectId: 'tyt_turkce',
          subjectName: 'Türkçe',
          correct: 34,
          wrong: 4,
          blank: 2,
          net: 33.0,
        ),
        ExamScore(
          id: 's2_mat',
          examId: 'e2',
          subjectId: 'tyt_mat',
          subjectName: 'Temel Matematik',
          correct: 28,
          wrong: 6,
          blank: 6,
          net: 26.5,
        ),
      ],
    );

    test('extractPoints sorts chronologically and filters by subject', () {
      // Pass exams in reverse chronological order
      final points = AnalyticsCalculator.extractPoints(
        exams: [exam2, exam1],
      );

      expect(points.length, 2);
      expect(points.first.id, 'e1'); // older first
      expect(points.last.id, 'e2'); // newer second
      expect(points.first.net, 65.0);
      expect(points.last.net, 76.0);

      // Subject specific extraction
      final mathPoints = AnalyticsCalculator.extractPoints(
        exams: [exam1, exam2],
        subjectId: 'tyt_mat',
      );
      expect(mathPoints.length, 2);
      expect(mathPoints.first.net, 24.0);
      expect(mathPoints.last.net, 26.5);
    });

    test('calculateTrend enforces at least 2 points for trend calculation', () {
      // 0 points
      final emptyTrend = AnalyticsCalculator.calculateTrend([]);
      expect(emptyTrend.hasSufficientData, isFalse);
      expect(emptyTrend.netChange, isNull);

      // 1 point
      final p1 = AnalyticsCalculator.extractPoints(exams: [exam1]);
      final singleTrend = AnalyticsCalculator.calculateTrend(p1);
      expect(singleTrend.hasSufficientData, isFalse);
      expect(singleTrend.netChange, isNull);
      expect(singleTrend.latestNet, 65.0);
      expect(singleTrend.changeText, contains('en az 2 deneme gerekiyor'));

      // 2 points
      final p2 = AnalyticsCalculator.extractPoints(exams: [exam1, exam2]);
      final doubleTrend = AnalyticsCalculator.calculateTrend(p2);
      expect(doubleTrend.hasSufficientData, isTrue);
      expect(doubleTrend.netChange, 11.0); // 76.0 - 65.0
      expect(doubleTrend.averageNet, 70.5);
      expect(doubleTrend.highestNet, 76.0);
      expect(doubleTrend.lowestNet, 65.0);
      expect(doubleTrend.changeText, contains('+11.00 net artış'));
    });

    test('extractSubjectStats aggregates subject performance accurately', () {
      final stats = AnalyticsCalculator.extractSubjectStats([exam1, exam2]);
      expect(stats.length, 2);

      final mathStat = stats.firstWhere((s) => s.subjectId == 'tyt_mat');
      expect(mathStat.subjectName, 'Temel Matematik');
      expect(mathStat.examCount, 2);
      expect(mathStat.averageNet, (24.0 + 26.5) / 2);
      expect(mathStat.latestNet, 26.5);
    });
  });

  group('TASK-007: Analytics UI & Accessibility Tests', () {
    late Database db;
    late ExamRepository examRepo;
    late PreferencesRepository prefRepo;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      examRepo = ExamRepository(db);
      prefRepo = PreferencesRepository(db);

      await prefRepo.savePreferences(
        const StudentPreferences(
          displayName: 'Deniz',
          field: 'Sayısal',
          targetNet: 85.0,
        ),
      );
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('AnalyticsScreen shows empty state initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: Scaffold(
            body: AnalyticsScreen(
              examRepository: examRepo,
              preferencesRepository: prefRepo,
            ),
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Gelişiminin Yolculuğu'), findsOneWidget);
      expect(find.text('Henüz Kayıtlı Deneme Verisi Yok'), findsOneWidget);
      expect(find.text('Henüz Deneme Kaydedilmedi'), findsOneWidget);
    });

    testWidgets(
        'AnalyticsScreen renders chart and subject filters with multiple exams',
        (tester) async {
      final session1 = ExamSession(
        id: 'ex_1',
        stage: 'TYT',
        title: 'Deneme 1',
        occurredAt: DateTime(2026, 3, 1),
        totalCorrect: 75,
        totalWrong: 16,
        totalBlank: 29,
        totalNet: 71.0,
        scores: const [
          ExamScore(
            id: 'sc_1',
            examId: 'ex_1',
            subjectId: 'tyt_turkce',
            subjectName: 'Türkçe',
            correct: 30,
            wrong: 8,
            blank: 2,
            net: 28.0,
          ),
        ],
      );

      final session2 = ExamSession(
        id: 'ex_2',
        stage: 'TYT',
        title: 'Deneme 2',
        occurredAt: DateTime(2026, 3, 15),
        totalCorrect: 82,
        totalWrong: 12,
        totalBlank: 26,
        totalNet: 79.0,
        scores: const [
          ExamScore(
            id: 'sc_2',
            examId: 'ex_2',
            subjectId: 'tyt_turkce',
            subjectName: 'Türkçe',
            correct: 33,
            wrong: 4,
            blank: 3,
            net: 32.0,
          ),
        ],
      );

      await tester.runAsync(() async {
        await examRepo.saveExam(session1);
        await examRepo.saveExam(session2);
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: Scaffold(
            body: AnalyticsScreen(
              examRepository: examRepo,
              preferencesRepository: prefRepo,
            ),
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should show summary and trend
      expect(find.text('2 Deneme Bazında'), findsOneWidget);
      expect(find.textContaining('+8.00 net artış'), findsOneWidget);
      expect(find.text('Hedef: 85 Net'), findsOneWidget);

      // Filter chips
      expect(find.text('Genel Net'), findsOneWidget);
      expect(find.text('Türkçe'), findsWidgets);

      // Scroll down to make chart visible in ListView
      await tester.drag(find.byType(ListView), const Offset(0, -350));
      await tester.pump();

      // Verify GardenLineChart exists
      expect(find.byType(GardenLineChart), findsOneWidget);

      // Semantics verify
      final semanticsFinder = find.byType(Semantics);
      expect(semanticsFinder, findsWidgets);
    });
  });
}
