import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/garden_theme.dart';
import 'package:fantastik_bahce_yks/domain/models/focus_record.dart';
import 'package:fantastik_bahce_yks/domain/repositories/focus_repository.dart';
import 'package:fantastik_bahce_yks/features/focus/domain/pomodoro_mode.dart';
import 'package:fantastik_bahce_yks/features/focus/presentation/focus_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TASK-008: Pomodoro Modes & Logic Tests', () {
    test('PomodoroMode properties and duration values', () {
      expect(PomodoroMode.focus.defaultSeconds, 25 * 60);
      expect(PomodoroMode.shortBreak.defaultSeconds, 5 * 60);
      expect(PomodoroMode.longBreak.defaultSeconds, 15 * 60);

      expect(PomodoroMode.focus.label, 'Odaklanma');
      expect(PomodoroMode.shortBreak.label, 'Kısa Mola');
      expect(PomodoroMode.longBreak.label, 'Uzun Mola');
    });

    test('FocusSession copyWith and toMap/fromMap serialization', () {
      final now = DateTime(2026, 4, 1, 14, 0);
      final session = FocusSession(
        id: 'f1',
        startedAt: now,
        durationSeconds: 1500,
        elapsedSeconds: 1500,
        subjectId: 'focus',
        completed: true,
      );

      final map = session.toMap();
      final fromMap = FocusSession.fromMap(map);

      expect(fromMap.id, 'f1');
      expect(fromMap.startedAt, now);
      expect(fromMap.durationSeconds, 1500);
      expect(fromMap.elapsedSeconds, 1500);
      expect(fromMap.subjectId, 'focus');
      expect(fromMap.completed, isTrue);
    });
  });

  group('TASK-008: Focus UI & Background Wall-Clock Tests', () {
    late Database db;
    late FocusRepository repo;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      repo = FocusRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('FocusScreen switches modes and updates initial time',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: FocusScreen(repository: repo),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Default is 25:00
      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('25 dk Odak'), findsOneWidget);

      // Switch to Short Break (5:00)
      await tester.tap(find.text('5 dk Mola'));
      await tester.pump();
      expect(find.text('05:00'), findsOneWidget);

      // Switch to Long Break (15:00)
      await tester.tap(find.text('15 dk Uzun Mola'));
      await tester.pump();
      expect(find.text('15:00'), findsOneWidget);

      // Quick custom minutes: tap 45 dk
      await tester.tap(find.text('45 dk'));
      await tester.pump();
      expect(find.text('45:00'), findsOneWidget);
    });

    testWidgets('FocusScreen starts, pauses, resets and completes session',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      var simulatedTime = DateTime(2026, 4, 1, 12, 0, 0);

      // Use 2 seconds duration for fast testing
      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: FocusScreen(
            repository: repo,
            customDurationSeconds: 2,
            nowProvider: () => simulatedTime,
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();

      expect(find.text('00:02'), findsOneWidget);
      expect(find.text('Başlat'), findsOneWidget);

      // Start timer
      await tester.tap(find.text('Başlat'));
      await tester.pump();
      expect(find.text('Duraklat'), findsOneWidget);

      // Advance by 1 second
      simulatedTime = simulatedTime.add(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // Pause timer
      await tester.tap(find.text('Duraklat'));
      await tester.pump();
      expect(find.text('Başlat'), findsOneWidget);

      // Reset timer
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();
      expect(find.text('00:02'), findsOneWidget);

      // Start again and advance simulated time to finish
      await tester.tap(find.text('Başlat'));
      await tester.pump();

      simulatedTime = simulatedTime.add(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 3));
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Completed snackbar or zero state
      expect(find.text('00:00'), findsOneWidget);

      // Check DB
      await tester.runAsync(() async {
        final sessions = await repo.getAllSessions();
        expect(sessions.length, 1);
        expect(sessions.first.completed, isTrue);
      });
    });

    testWidgets('FocusScreen respects reduced motion / disableAnimations',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: FocusScreen(),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Sessiz Çalışma Kulübesi'), findsOneWidget);
      expect(find.byType(FocusScreen), findsOneWidget);
    });
  });
}
