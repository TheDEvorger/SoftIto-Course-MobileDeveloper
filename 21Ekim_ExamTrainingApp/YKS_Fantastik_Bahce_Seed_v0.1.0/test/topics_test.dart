import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/garden_theme.dart';
import 'package:fantastik_bahce_yks/domain/models/curriculum.dart';
import 'package:fantastik_bahce_yks/domain/repositories/curriculum_repository.dart';
import 'package:fantastik_bahce_yks/features/topics/presentation/subject_detail_screen.dart';
import 'package:fantastik_bahce_yks/features/topics/presentation/topics_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Curriculum & Topics Feature Tests', () {
    late Database db;
    late CurriculumRepository repo;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      repo = CurriculumRepository(db);
      await repo.seedInitialCurriculumIfEmpty();
    });

    tearDown(() async {
      await db.close();
    });

    test('Seeds complete TYT and AYT curriculum', () async {
      final tytSubjects = await repo.getSubjects('TYT');
      final aytSubjects = await repo.getSubjects('AYT');

      expect(tytSubjects.length, greaterThanOrEqualTo(4));
      expect(aytSubjects.length, greaterThanOrEqualTo(7));

      final tytMath = tytSubjects.firstWhere((s) => s.id == 'tyt_mat');
      final mathTopics = await repo.getTopics(tytMath.id);
      expect(mathTopics.length, greaterThanOrEqualTo(10));
    });

    test('Topic progress tracking and status update', () async {
      final tytSubjects = await repo.getSubjects('TYT');
      final firstSubject = tytSubjects.first;
      final topics = await repo.getTopics(firstSubject.id);
      final firstTopic = topics.first;

      // Initially not_started
      var progress = await repo.getTopicProgress(firstTopic.id);
      expect(progress.status, TopicStatus.notStarted);
      expect(progress.answeredCount, 0);

      // Update to completed with solved questions
      await repo.updateTopicProgress(
        TopicProgress(
          topicId: firstTopic.id,
          status: TopicStatus.completed,
          answeredCount: 45,
          lastStudiedAt: DateTime.now(),
        ),
      );

      progress = await repo.getTopicProgress(firstTopic.id);
      expect(progress.status, TopicStatus.completed);
      expect(progress.answeredCount, 45);

      // Stage summary reflects completion
      final summary = await repo.getStageSummary('TYT');
      expect(summary['completedTopics'], greaterThanOrEqualTo(1));
    });

    testWidgets('TopicsScreen renders TYT and AYT tabs and switches',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: Scaffold(
            body: TopicsScreen(repository: repo),
          ),
        ),
      );

      // Allow background SQLite FFI queries to complete
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify screen title and segmented controls
      expect(find.text('Botanik Bilgi Bahçesi'), findsOneWidget);
      expect(find.text('TYT Müfredatı'), findsOneWidget);
      expect(find.text('AYT Müfredatı'), findsOneWidget);

      // Verify subjects are rendered
      expect(find.textContaining('Türkçe'), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -250));
      await tester.pump();
      expect(find.textContaining('Temel Matematik'), findsOneWidget);

      // Switch to AYT tab
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pump();
      await tester.tap(find.text('AYT Müfredatı'));
      await tester.pump();
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.drag(find.byType(ListView), const Offset(0, -250));
      await tester.pump();
      expect(find.textContaining('Edebiyat'), findsOneWidget);
    });

    testWidgets('SubjectDetailScreen filters topics and shows progress',
        (tester) async {
      const mathSubject = Subject(
        id: 'tyt_mat',
        stage: 'TYT',
        name: 'Temel Matematik',
        orderIndex: 2,
        questionCount: 40,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: SubjectDetailScreen(
            repository: repo,
            subject: mathSubject,
          ),
        ),
      );

      // Allow async _loadTopics to resolve
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Temel Matematik'), findsWidgets);
      expect(find.text('Temel Kavramlar'), findsOneWidget);

      // Filter chips should be present
      expect(find.textContaining('Tümü'), findsOneWidget);
      expect(find.textContaining('Eksik'), findsWidgets);
    });
  });
}
