import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/garden_theme.dart';
import 'package:fantastik_bahce_yks/domain/models/curriculum.dart';
import 'package:fantastik_bahce_yks/domain/repositories/curriculum_repository.dart';
import 'package:fantastik_bahce_yks/domain/services/topic_map_service.dart';
import 'package:fantastik_bahce_yks/features/topics/presentation/topic_map_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TASK-011: TopicMapService Logic & MEB Prerequisites Tests', () {
    late Database db;
    late CurriculumRepository repo;
    late TopicMapService service;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      repo = CurriculumRepository(db);
      await repo.seedInitialCurriculumIfEmpty();
      service = TopicMapService(repo);
    });

    tearDown(() async {
      await db.close();
    });

    test('getTopicNodesForBranch builds verified MEB chain for math', () async {
      final nodes =
          await service.getTopicNodesForBranch(branchKey: 'matematik');
      expect(nodes.isNotEmpty, isTrue);

      // Verify Temel Kavramlar has no prerequisites and is ready
      final temelKavramlar = nodes.firstWhere((n) => n.topicId == 'tyt_mat_1');
      expect(temelKavramlar.prerequisiteIds, isEmpty);
      expect(temelKavramlar.isReady, isTrue);

      // Verify Türev (ayt_mat_8) depends on Limit (ayt_mat_7) and is initially not ready
      final turev = nodes.firstWhere((n) => n.topicId == 'ayt_mat_8');
      expect(turev.prerequisiteIds, contains('ayt_mat_7'));
      expect(turev.isReady, isFalse);
    });

    test('completing prerequisite unlocks dependent topic isReady', () async {
      // Initially Sayı Basamakları depends on Temel Kavramlar and is not ready
      var nodes = await service.getTopicNodesForBranch(branchKey: 'matematik');
      var sayiBasamaklari = nodes.firstWhere((n) => n.topicId == 'tyt_mat_2');
      expect(sayiBasamaklari.isReady, isFalse);

      // Complete Temel Kavramlar
      await repo.updateTopicProgress(
        TopicProgress(
          topicId: 'tyt_mat_1',
          status: TopicStatus.completed,
          answeredCount: 30,
          lastStudiedAt: DateTime.now(),
        ),
      );

      // Now Sayı Basamakları should be ready
      nodes = await service.getTopicNodesForBranch(branchKey: 'matematik');
      sayiBasamaklari = nodes.firstWhere((n) => n.topicId == 'tyt_mat_2');
      expect(sayiBasamaklari.isReady, isTrue);
    });

    test('spaced repetition identifies topics needing review', () async {
      // Completed topic studied 12 days ago with few questions
      final twelveDaysAgo = DateTime.now().subtract(const Duration(days: 12));
      await repo.updateTopicProgress(
        TopicProgress(
          topicId: 'tyt_mat_1',
          status: TopicStatus.completed,
          answeredCount: 10,
          lastStudiedAt: twelveDaysAgo,
        ),
      );

      final reviews = await service.getReviewRecommendations();
      expect(reviews.any((r) => r.topicId == 'tyt_mat_1'), isTrue);

      final node = reviews.firstWhere((r) => r.topicId == 'tyt_mat_1');
      expect(node.needsReview, isTrue);
      expect(node.reviewMessage, contains('gündür tekrar edilmedi'));
    });
  });

  group('TASK-011: TopicMapScreen UI & Accessibility Tests', () {
    late Database db;
    late CurriculumRepository repo;
    late TopicMapService service;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      repo = CurriculumRepository(db);
      await repo.seedInitialCurriculumIfEmpty();
      service = TopicMapService(repo);
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('TopicMapScreen renders on 360px screen with canvas and legend',
        (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: TopicMapScreen(
            repository: repo,
            mapService: service,
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Hero and legend appear without render overflow
      expect(find.text('Konu Bağlantıları ve Tekrar'), findsOneWidget);
      expect(find.text('✓ Tamamlandı'), findsOneWidget);
      expect(find.text('🌱 Çalışılıyor'), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('Switching to accessible list mode displays semantic topics',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: TopicMapScreen(
            repository: repo,
            mapService: service,
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap list mode segment
      await tester.tap(find.text('📋 Erişilebilir Liste Modu'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Accessible list items with MEB topics are rendered
      expect(find.text('TYT • Temel Kavramlar'), findsOneWidget);
      expect(find.text('Temel Başlangıç Konusu (Önkoşulsuz)'), findsOneWidget);

      // Checkmark icon button exists for completing
      expect(find.byIcon(Icons.check), findsWidgets);
    });
  });
}
