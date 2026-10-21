import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/app/mobility_app.dart';
import 'package:precision_mobility/features/discovery/domain/vehicle.dart';
import 'support/workspace_api.dart';
import 'studio_interface_test.dart' show tapVisible;

void populate(WorkspaceApiFixture fixture) {
  final start = DateTime.now().add(const Duration(days: 2));
  fixture.exampleReservations.addAll([
    for (var i = 0; i < 2; i++)
      {
        'id': 'example-plan-$i',
        'vehicle_id': 'sample-car',
        'vehicle_name': 'Aster Sample',
        'starts_on': dateKey(start),
        'ends_on': dateKey(start.add(const Duration(days: 2))),
        'total_minor': 246912,
        'currency': 'TRY',
        'status': i == 0 ? 'reserved' : 'cancelled'
      }
  ]);
  fixture.blocks.add({
    'id': 'test-block',
    'starts_on': dateKey(start),
    'ends_on': dateKey(start.add(const Duration(days: 1))),
    'reason': 'Planlı bakım'
  });
}

void main() {
  for (final width in [320.0, 1440.0]) {
    for (final dark in [false, true]) {
      for (final scale in [1.0, 1.8]) {
        testWidgets('populated menus and operations $width $dark $scale',
            (tester) async {
          tester.view.physicalSize = Size(width, 1100);
          tester.view.devicePixelRatio = 1;
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          tester.platformDispatcher.platformBrightnessTestValue =
              dark ? Brightness.dark : Brightness.light;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          addTearDown(
              tester.platformDispatcher.clearPlatformBrightnessTestValue);
          final fixture = WorkspaceApiFixture();
          populate(fixture);
          addTearDown(fixture.client.close);
          await tester.pumpWidget(MobilityApp(api: fixture.client));
          await tester.pumpAndSettle();
          expect(fixture.client.examples, isTrue);
          expect(
              find.text(
                  'Örnek çalışma alanı · Kurgusal kayıtlar, kalıcı değişiklikler'),
              findsOneWidget);
          await tapVisible(tester, find.text('Araçlar'));
          final manage = width >= 1000 && scale < 1.4
              ? find.byTooltip('Takvim ve yayın')
              : find.text('Takvim ve yayın');
          await tapVisible(tester, manage);
          expect(find.text('Müsaitlik takvimi'), findsOneWidget);
          await tapVisible(tester, find.text('Tarihleri yeniden aç'));
          expect(fixture.blocks, isEmpty);
          await tapVisible(tester, find.byType(Switch));
          expect(fixture.published, isFalse);
          await tapVisible(tester, find.byType(BackButton));
          await tapVisible(tester, find.text('Sürüşlerim'));
          expect(find.text('Aster Sample'), findsNWidgets(2));
          await tapVisible(tester, find.text('Hesabım').last);
          await tester.ensureVisible(find.text('Çalışma alanına genel bakış'));
          await tester.pumpAndSettle();
        });
      }
    }
  }
  testWidgets(
      'failed real login preserves samples, valid login isolates records',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fixture = WorkspaceApiFixture();
    populate(fixture);
    addTearDown(fixture.client.close);
    await tester.pumpWidget(MobilityApp(api: fixture.client));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Hesabım').last);
    final keyField = find.widgetWithText(TextField, 'Çalışma alanı anahtarı');
    await tester.ensureVisible(keyField);
    await tester.enterText(keyField, 'invalid');
    await tapVisible(tester, find.text('Çalışma alanına bağlan'));
    expect(fixture.client.examples, isTrue);
    expect(find.text('Anahtar geçersiz.'), findsOneWidget);
    await tester.enterText(keyField, testWorkspaceKey);
    await tapVisible(tester, find.text('Çalışma alanına bağlan'));
    expect(fixture.client.examples, isFalse);
    await tapVisible(tester, find.text('Araçlar'));
    expect(find.text('Test sedan'), findsOneWidget);
    expect(find.text('Aster Sample'), findsNothing);
    await tapVisible(tester, find.text('Sürüşlerim'));
    expect(find.text('Aster Sample'), findsNothing);
    await tapVisible(tester, find.text('Hesabım').last);
    await tapVisible(tester, find.text('Örnek çalışma alanını aç'));
    await tapVisible(tester, find.text('Sürüşlerim'));
    expect(find.text('Aster Sample'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
  testWidgets('unavailable quote blocks reservation and refresh recovers',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fixture = WorkspaceApiFixture()..quoteUnavailable = true;
    addTearDown(fixture.client.close);
    await tester.pumpWidget(MobilityApp(api: fixture.client));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Detayları gör'));
    await tester.ensureVisible(find.text('Rezervasyon kaydı oluştur'));
    await tester.pumpAndSettle();
    expect(find.text('Bu tarihler kapalı.'), findsOneWidget);
    final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Rezervasyon kaydı oluştur'));
    expect(button.onPressed, isNull);
    fixture.quoteUnavailable = false;
    await tapVisible(tester, find.text('Fiyatı ve müsaitliği yenile'));
    await tapVisible(tester, find.text('Rezervasyon kaydı oluştur'));
    expect(find.text('Rezervasyon kaydedildi'), findsOneWidget);
    expect(fixture.exampleReservations.length, 1);
    expect(fixture.reservations, isEmpty);
  });
}
