import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/app/mobility_app.dart';
import 'package:precision_mobility/features/bookings/presentation/reserve_vehicle_screen.dart';
import 'support/workspace_api.dart';

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> connect(WidgetTester tester) async {
  await tapVisible(tester, find.text('Hesabım').last);
  final field = find.widgetWithText(TextField, 'Çalışma alanı anahtarı');
  await tester.ensureVisible(field);
  await tester.pumpAndSettle();
  await tester.enterText(field, testWorkspaceKey);
  await tapVisible(tester, find.text('Çalışma alanına bağlan'));
}

void main() {
  for (final width in [320.0, 1440.0]) {
    for (final dark in [false, true]) {
      for (final scale in [1.0, 1.8]) {
        testWidgets('rebuilt menus $width dark=$dark scale=$scale',
            (tester) async {
          tester.view.physicalSize = Size(width, 1000);
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
          addTearDown(fixture.client.close);
          await tester.pumpWidget(
              MobilityApp(api: fixture.client, initialExamples: false));
          await tester.pumpAndSettle();
          expect(find.text('DEMO'), findsNothing);
          await tapVisible(tester, find.text('Koleksiyonu keşfet'));
          expect(tester.takeException(), isNull);
          await connect(tester);
          await tapVisible(tester, find.text('Araçlar'));
          expect(find.text('Test sedan'), findsOneWidget);
          expect(find.byType(DataTable),
              width >= 1000 && scale < 1.4 ? findsOneWidget : findsNothing);
          await tapVisible(tester, find.text('Sürüşlerim'));
          await tapVisible(tester, find.text('Araçları keşfet'));
          await tapVisible(tester, find.text('Detayları gör'));
          expect(find.byType(ReserveVehicleScreen), findsOneWidget);
          await tester.ensureVisible(find.text('Rezervasyon kaydı oluştur'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
  testWidgets('reserve, cancel and disconnect keep server-owned requests',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fixture = WorkspaceApiFixture();
    addTearDown(fixture.client.close);
    await tester
        .pumpWidget(MobilityApp(api: fixture.client, initialExamples: false));
    await tester.pumpAndSettle();
    await connect(tester);
    await tapVisible(tester, find.text('Keşfet'));
    await tapVisible(tester, find.text('Detayları gör'));
    await tapVisible(tester, find.text('Rezervasyon kaydı oluştur'));
    expect(find.text('Rezervasyon kaydedildi'), findsOneWidget);
    expect(fixture.reservations.single['total_minor'], 123456);
    final request = fixture.requests.firstWhere(
        (r) => r.method == 'POST' && r.url.path.endsWith('/reservations'));
    expect(request.headers['Idempotency-Key'], isNotEmpty);
    expect(request.body, isNot(contains('total_minor')));
    await tapVisible(tester, find.text('Rezervasyonlarıma git'));
    await tapVisible(tester, find.text('Rezervasyonu iptal et'));
    await tapVisible(tester, find.text('İptal et'));
    expect(fixture.reservations.single['status'], 'cancelled');
    await tapVisible(tester, find.text('Hesabım').last);
    await tapVisible(tester, find.text('Bağlantıyı kapat'));
    await tapVisible(tester, find.text('Sürüşlerim'));
    expect(find.text('Test sedan'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
      'empty collection creates a persistent API vehicle and appearance works',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fixture = WorkspaceApiFixture(empty: true);
    addTearDown(fixture.client.close);
    await tester
        .pumpWidget(MobilityApp(api: fixture.client, initialExamples: false));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Araç ekle'));
    await connect(tester);
    await tapVisible(tester, find.text('Araçlar'));
    await tapVisible(tester, find.text('Araç ekle'));
    for (final field in [
      ('Araç adı', 'Registered vehicle'),
      ('Kategori', 'Sedan'),
      ('Enerji türü', 'Elektrik'),
      ('Açıklama', 'User entered vehicle.'),
      ('Günlük ücret (TRY)', '1825,75')
    ]) {
      final target = find.widgetWithText(TextFormField, field.$1);
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
      await tester.enterText(target, field.$2);
    }
    await tapVisible(tester, find.text('Aracı kaydet'));
    expect(fixture.vehicles.single['rate_minor'], 182575);
    await tapVisible(tester, find.text('Keşfet'));
    expect(find.text('Registered vehicle'), findsOneWidget);
    await tapVisible(tester, find.text('Hesabım').last);
    await tapVisible(tester, find.text('Koyu'));
    expect(Theme.of(tester.element(find.text('Görünüm'))).brightness,
        Brightness.dark);
    await tapVisible(tester, find.text('Açık'));
    expect(Theme.of(tester.element(find.text('Görünüm'))).brightness,
        Brightness.light);
    expect(tester.takeException(), isNull);
  });
}
