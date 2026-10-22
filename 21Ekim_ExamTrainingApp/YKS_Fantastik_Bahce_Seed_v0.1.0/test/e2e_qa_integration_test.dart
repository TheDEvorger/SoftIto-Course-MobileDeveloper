import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/app.dart';
import 'package:fantastik_bahce_yks/core/assets/garden_scenes.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/theme_controller.dart';
import 'package:fantastik_bahce_yks/domain/models/student_preferences.dart';
import 'package:fantastik_bahce_yks/domain/repositories/curriculum_repository.dart';
import 'package:fantastik_bahce_yks/domain/repositories/preferences_repository.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TASK-013: E2E Quality Gates, Accessibility & Visual QA Tests', () {
    late Database db;

    setUp(() async {
      db = await GardenDatabaseProvider.openInMemory();
      GardenDatabaseProvider.instance.setDatabaseForTesting(db);
      final currRepo = CurriculumRepository(db);
      await currRepo.seedInitialCurriculumIfEmpty();
    });

    tearDown(() async {
      GardenDatabaseProvider.instance.setDatabaseForTesting(null);
      await db.close();
    });

    test('All 10 authentic illustration assets exist on local disk', () {
      expect(GardenScenes.all.length, 10);
      for (final scene in GardenScenes.all) {
        final file = File(scene.assetPath);
        expect(file.existsSync(), isTrue,
            reason: 'Asset file missing: ${scene.assetPath}');
      }
    });

    testWidgets(
        'E2E 360px small screen navigation: no overflow across all 5 main tabs',
        (tester) async {
      tester.view.physicalSize = const Size(360, 680);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const GardenYksApp());
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 250)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tab 1: Home Screen renders
      expect(find.text('YKS Geri Sayım Sayacı'), findsOneWidget);

      // Navigate to Tab 2: Konular
      await tester.tap(find.text('Konular'));
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Botanik Bilgi Bahçesi'), findsOneWidget);

      // Navigate to Tab 3: Denemeler
      await tester.tap(find.text('Denemeler'));
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Deneme Takip Masası'), findsOneWidget);

      // Navigate to Tab 4: Analiz
      await tester.tap(find.text('Analiz'));
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Gelişiminin Yolculuğu'), findsOneWidget);

      // Navigate to Tab 5: Profil
      await tester.tap(find.text('Profil'));
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('YKS Hedefin'), findsOneWidget);
    });

    testWidgets(
        'E2E Tablet/Desktop wide screen (>=760px) triggers NavigationRail',
        (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const GardenYksApp());
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 250)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // NavigationRail is present on wide viewports
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('Accessibility: 200% text scaling renders without fatal errors',
        (tester) async {
      tester.view.physicalSize = const Size(420, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            textScaler: TextScaler.linear(2.0),
          ),
          child: GardenYksApp(),
        ),
      );

      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 250)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Home Screen remains readable and functional
      expect(find.text('YKS Geri Sayım Sayacı'), findsOneWidget);
    });

    testWidgets('Dark theme (Gece Bahçesi) visual mode renders accurately',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        AppThemeController.instance.themeModeNotifier.value = ThemeMode.system;
      });

      // Persist dark theme to DB so ProfileScreen doesn't reset it
      await tester.runAsync(() async {
        final prefRepo = PreferencesRepository(db);
        final existing = await prefRepo.getPreferences();
        await prefRepo.savePreferences(
            existing.copyWith(themeMode: ThemeModePreference.dark));
      });
      AppThemeController.instance.themeModeNotifier.value = ThemeMode.dark;

      await tester.pumpWidget(const GardenYksApp());
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 250)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, ThemeMode.dark);
    });
  });
}
