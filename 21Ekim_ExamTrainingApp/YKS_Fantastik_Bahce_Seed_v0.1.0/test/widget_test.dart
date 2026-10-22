import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fantastik_bahce_yks/core/database/database_provider.dart';
import 'package:fantastik_bahce_yks/core/theme/garden_theme.dart';
import 'package:fantastik_bahce_yks/domain/repositories/exam_repository.dart';
import 'package:fantastik_bahce_yks/features/exams/presentation/exams_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late ExamRepository repo;

  setUp(() async {
    db = await GardenDatabaseProvider.openInMemory();
    repo = ExamRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('ExamsScreen loads and renders header and calculator',
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

    expect(find.text('Deneme Takip Masası'), findsOneWidget);
    expect(find.text('Henüz Kayıtlı TYT Denemen Yok'), findsOneWidget);
  });
}
