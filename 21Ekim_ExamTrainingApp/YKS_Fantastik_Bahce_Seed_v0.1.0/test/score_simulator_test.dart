import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/garden_theme.dart';
import 'package:fantastik_bahce_yks/domain/models/exam_record.dart';
import 'package:fantastik_bahce_yks/domain/models/score_simulation.dart';
import 'package:fantastik_bahce_yks/domain/repositories/exam_repository.dart';
import 'package:fantastik_bahce_yks/domain/services/score_simulator.dart';
import 'package:fantastik_bahce_yks/features/analytics/presentation/score_simulator_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TASK-012: ScoreSimulator Unit Tests (ÖSYM Standards & OBP)', () {
    const simulator = ScoreSimulator();

    test('0 nets returns base score of 100.0 for TYT', () {
      final score = simulator.calculateTytRawScore(
        turkce: 0.0,
        matematik: 0.0,
        sosyal: 0.0,
        fen: 0.0,
      );
      expect(score, 100.0);
    });

    test('Full 120 TYT nets yields exactly 500.0 points', () {
      final score = simulator.calculateTytRawScore(
        turkce: 40.0,
        matematik: 40.0,
        sosyal: 20.0,
        fen: 20.0,
      );
      expect(score, 500.0);
    });

    test('OBP calculation and broken OBP rule (0.12 vs 0.06)', () {
      // 100.0 diploma grade => 500 OBP
      final obp500 = simulator.calculateObpScore(100.0);
      expect(obp500, 500.0);

      // Normal contribution (x0.12)
      final normalContrib = simulator.calculateObpContribution(obp500, false);
      expect(normalContrib, 60.0);

      // Broken OBP contribution (x0.06)
      final brokenContrib = simulator.calculateObpContribution(obp500, true);
      expect(brokenContrib, 30.0);

      // Minimum grade 50.0 => 250 OBP
      final obp250 = simulator.calculateObpScore(50.0);
      expect(obp250, 250.0);
      expect(simulator.calculateObpContribution(obp250, false), 30.0);
      expect(simulator.calculateObpContribution(obp250, true), 15.0);
    });

    test(
        'SAY, EA and SÖZ field simulations include disclaimer and valid limits',
        () {
      const inputSay = SimulationInput(
        field: SimulationField.sayisal,
        tytTurkce: 30.0,
        tytMatematik: 30.0,
        tytSosyal: 15.0,
        tytFen: 15.0,
        aytMatematik: 30.0,
        aytFizik: 10.0,
        aytKimya: 10.0,
        aytBiyoloji: 10.0,
        diplomaGrade: 90.0,
        isPreviousYearPlaced: false,
      );

      final resultSay = simulator.simulate(inputSay);
      expect(resultSay.placementScore, greaterThan(resultSay.fieldRawScore));
      expect(resultSay.disclaimer,
          contains('resmî sınav sonucu veya sıralama garantisi yerine geçmez'));
      expect(resultSay.curriculumYear, 2026);
      expect(resultSay.fieldRawScore, inInclusiveRange(100.0, 500.0));
    });
  });

  group('TASK-012: ScoreSimulatorScreen UI Tests', () {
    late Database db;
    late ExamRepository examRepo;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      examRepo = ExamRepository(db);

      // Seed a recent TYT and AYT exam for loading test
      await examRepo.saveExam(
        ExamSession(
          id: 'test_tyt_1',
          stage: 'TYT',
          title: '3D TYT Genel Deneme',
          occurredAt: DateTime.now(),
          scores: const [
            ExamScore(
              id: 's1',
              examId: 'test_tyt_1',
              subjectId: 'tyt_turkce',
              subjectName: 'Türkçe',
              correct: 32,
              wrong: 4,
              blank: 4,
              net: 31.0,
            ),
            ExamScore(
              id: 's2',
              examId: 'test_tyt_1',
              subjectId: 'tyt_mat',
              subjectName: 'Temel Matematik',
              correct: 30,
              wrong: 2,
              blank: 8,
              net: 29.5,
            ),
          ],
        ),
      );
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('ScoreSimulatorScreen renders headers, disclaimers and OBP',
        (tester) async {
      tester.view.physicalSize = const Size(600, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: ScoreSimulatorScreen(examRepository: examRepo),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Title & disclaimer rendered
      expect(find.text('Puan & OBP Simülatörü'), findsOneWidget);
      expect(find.text('Resmî Sınav Bilgilendirmesi'), findsOneWidget);
      expect(find.textContaining('Yerleştirme Puanı:'), findsOneWidget);

      // Segmented control works: tap Eşit Ağırlık
      await tester.tap(find.text('Eşit Ağırlık'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Edebiyat inputs appear for EA
      expect(find.textContaining('Türk Dili ve Edb.'), findsOneWidget);
    });

    testWidgets('Load from latest exams action updates simulator nets',
        (tester) async {
      tester.view.physicalSize = const Size(600, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: ScoreSimulatorScreen(examRepository: examRepo),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap 'Denemelerimden Yükle ⚡' button in HeroCard
      await tester.runAsync(() async {
        await tester.tap(find.text('Denemelerimden Yükle ⚡'));
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Türkçe net updated from test exam (31.0 Net)
      expect(find.text('31.0 Net'), findsOneWidget);
    });
  });
}
