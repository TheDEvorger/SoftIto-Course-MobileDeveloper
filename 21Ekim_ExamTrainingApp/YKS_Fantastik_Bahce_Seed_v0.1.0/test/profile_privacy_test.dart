import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/core/content/app_copy.dart';
import 'package:fantastik_bahce_yks/core/database/backup_service.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/garden_theme.dart';
import 'package:fantastik_bahce_yks/core/theme/theme_controller.dart';
import 'package:fantastik_bahce_yks/domain/models/daily_task.dart';
import 'package:fantastik_bahce_yks/domain/models/exam_record.dart';
import 'package:fantastik_bahce_yks/domain/models/student_preferences.dart';
import 'package:fantastik_bahce_yks/domain/repositories/exam_repository.dart';
import 'package:fantastik_bahce_yks/domain/repositories/planning_repository.dart';
import 'package:fantastik_bahce_yks/domain/repositories/preferences_repository.dart';
import 'package:fantastik_bahce_yks/features/profile/presentation/profile_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TASK-010: BackupService Logic Tests', () {
    late Database db;
    late BackupService backupService;
    late ExamRepository examRepo;
    late PlanningRepository planRepo;
    late PreferencesRepository prefRepo;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      backupService = BackupService(db);
      examRepo = ExamRepository(db);
      planRepo = PlanningRepository(db);
      prefRepo = PreferencesRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('exportAllDataAsJson exports lossless JSON structure', () async {
      // Add sample preferences, exam, and daily task
      await prefRepo.savePreferences(
        const StudentPreferences(
          displayName: 'Baran',
          field: 'Sözel',
          targetNet: 75.0,
          themeMode: ThemeModePreference.dark,
          humorousExitEnabled: false,
        ),
      );

      final exam = ExamSession(
        id: 'ex_test',
        stage: 'TYT',
        title: 'Örnek Deneme',
        occurredAt: DateTime(2026, 4, 1),
        totalNet: 72.5,
      );
      await examRepo.saveExam(exam);

      final task = DailyTask(
        id: 'task_test',
        scheduledDate: DateTime(2026, 4, 1),
        description: 'Tarih testi',
      );
      await planRepo.saveTask(task);

      final jsonStr = await backupService.exportAllDataAsJson();
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(decoded.containsKey('metadata'), isTrue);
      expect(decoded['metadata']['app'], 'Fantastik Bahçe YKS');

      final prefsList = decoded['preferences'] as List;
      expect(prefsList.isNotEmpty, isTrue);
      expect(prefsList.first['display_name'], 'Baran');

      final examsList = decoded['exam_sessions'] as List;
      expect(examsList.length, 1);
      expect(examsList.first['title'], 'Örnek Deneme');

      final tasksList = decoded['daily_tasks'] as List;
      expect(tasksList.length, 1);
    });

    test('clearAllUserData clears data and resets preferences safely',
        () async {
      final exam = ExamSession(
        id: 'ex_to_delete',
        stage: 'AYT',
        title: 'Silinecek Sınav',
        occurredAt: DateTime(2026, 4, 1),
        totalNet: 60.0,
      );
      await examRepo.saveExam(exam);

      // Perform clear
      await backupService.clearAllUserData();

      final examsAfter = await examRepo.getExams();
      expect(examsAfter, isEmpty);

      final prefsAfter = await prefRepo.getPreferences();
      expect(prefsAfter.displayName, isNull);
      expect(prefsAfter.field, 'Sayısal'); // Default
    });
  });

  group('TASK-010: ProfileScreen UI, Theme & Privacy Tests', () {
    late Database db;
    late PreferencesRepository prefRepo;
    late BackupService backupService;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      prefRepo = PreferencesRepository(db);
      backupService = BackupService(db);

      await prefRepo.savePreferences(
        const StudentPreferences(
          displayName: 'Derya',
          field: 'Sayısal',
          targetNet: 95.0,
          humorousExitEnabled: false,
          themeMode: ThemeModePreference.light,
        ),
      );
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets(
        'ProfileScreen displays user info, manages humorous quote visibility',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: Scaffold(
            body: ProfileScreen(
              preferencesRepository: prefRepo,
              backupService: backupService,
            ),
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // User name and fields are shown
      expect(find.text('Derya'), findsOneWidget);
      expect(find.text('Hedef Alan: Sayısal'), findsOneWidget);
      expect(find.text('95.0 Net'), findsOneWidget);

      // Acceptance criterion: humorous quote is OFF by default and NOT displayed
      expect(find.text(AppCopy.optionalFarewell), findsNothing);

      // Toggle humorous switch ON
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      await tester.runAsync(() async {
        await tester.tap(switchFinder);
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Now humorous quote appears!
      expect(find.text(AppCopy.optionalFarewell), findsOneWidget);

      // Toggle it OFF again
      await tester.runAsync(() async {
        await tester.tap(switchFinder);
        await Future<void>.delayed(const Duration(milliseconds: 150));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text(AppCopy.optionalFarewell), findsNothing);
    });

    testWidgets('ProfileScreen theme mode selection updates app theme',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: Scaffold(
            body: ProfileScreen(
              preferencesRepository: prefRepo,
              backupService: backupService,
            ),
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Theme Mode tile
      await tester.tap(find.text('Tema Modu'));
      await tester.pumpAndSettle();

      // Dialog options appear
      expect(find.text('🌙 Gece Bahçesi'), findsOneWidget);
      await tester.tap(find.text('🌙 Gece Bahçesi'));
      await tester.pump();
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 300)));
      await tester.pumpAndSettle();

      // Theme mode updated in controller
      expect(
        AppThemeController.instance.themeModeNotifier.value,
        ThemeMode.dark,
      );
    });

    testWidgets('ProfileScreen export dialog and clear data modal cancel',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: GardenTheme.light,
          home: Scaffold(
            body: ProfileScreen(
              preferencesRepository: prefRepo,
              backupService: backupService,
            ),
          ),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 150)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Open Export dialog
      await tester.runAsync(() async {
        await tester.tap(find.text('Yerel Verileri Dışa Aktar (JSON)'));
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });
      await tester.pumpAndSettle();

      expect(find.text('📦 Yerel Veri Yedeği (JSON)'), findsOneWidget);
      expect(find.text('Kapat'), findsOneWidget);
      await tester.tap(find.text('Kapat'));
      await tester.pumpAndSettle();

      // Open Clear Data modal
      await tester.tap(find.text('Tüm Verileri Sıfırla'));
      await tester.pumpAndSettle();

      expect(find.text('⚠️ Tüm Verileri Sıfırla'), findsOneWidget);
      expect(find.text('Vazgeç'), findsOneWidget);
      await tester.tap(find.text('Vazgeç'));
      await tester.pumpAndSettle();

      // Verification that data was not wiped
      await tester.runAsync(() async {
        final prefs = await prefRepo.getPreferences();
        expect(prefs.displayName, 'Derya');
      });
    });
  });
}
