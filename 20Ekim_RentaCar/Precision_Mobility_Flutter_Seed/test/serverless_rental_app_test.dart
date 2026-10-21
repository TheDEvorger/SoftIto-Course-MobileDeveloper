import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/app/rental_app.dart';
import 'package:precision_mobility/features/rental/data/device_rental_repository.dart';
import 'package:precision_mobility/features/rental/data/rental_catalog.dart';
import 'package:precision_mobility/features/rental/presentation/rental_detail_screen.dart';
import 'support/memory_rental_storage.dart';

Future<void> tapRental(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> menu(WidgetTester tester, String label) async {
  final tooltip = find.byTooltip(label);
  await tapRental(
      tester, tooltip.evaluate().isNotEmpty ? tooltip : find.text(label).last);
}

void main() {
  for (final width in [320.0, 1440.0]) {
    for (final dark in [false, true]) {
      for (final scale in [1.0, 1.8]) {
        testWidgets('serverless menus $width dark=$dark scale=$scale',
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
          final repository =
              DeviceRentalRepository(MemoryRentalStorage(), rentalCatalog);
          await tester.pumpWidget(RentalApp(repository: repository));
          await tester.pumpAndSettle();
          expect(find.text('Renault Clio'), findsOneWidget);
          expect(find.textContaining('Sunucuya'), findsNothing);
          expect(find.textContaining('Çalışma alanı'), findsNothing);
          await menu(tester, 'Favoriler');
          expect(find.text('Renault Clio'), findsOneWidget);
          await menu(tester, 'Planlarım');
          expect(find.text('Renault Clio'), findsOneWidget);
          await menu(tester, 'Profil');
          expect(find.text('Tercihleriniz'), findsOneWidget);
          await menu(tester, 'Keşfet');
          await tapRental(tester, find.text('Aracı incele').first);
          expect(find.byType(RentalDetailScreen), findsOneWidget);
          await tester.ensureVisible(find.text('Rezervasyon oluştur'));
          await tester.pumpAndSettle();
        });
      }
    }
  }
  testWidgets('favorite, reserve, restart, details and cancel work without API',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final storage = MemoryRentalStorage();
    var repository = DeviceRentalRepository(storage, rentalCatalog);
    await tester.pumpWidget(RentalApp(repository: repository));
    await tester.pumpAndSettle();
    await tapRental(tester, find.byTooltip('Favorilere ekle').first);
    await menu(tester, 'Favoriler');
    expect(repository.data.favorites, {'clio'});
    await tapRental(tester, find.text('Aracı incele'));
    await tapRental(tester, find.text('Rezervasyon oluştur'));
    await tapRental(tester, find.text('Rezervasyonu kaydet'));
    expect(find.text('Rezervasyonunuz kaydedildi.'), findsOneWidget);
    expect(repository.data.plans.single.totalMinor, 290000);
    await tapRental(tester, find.text('Rezervasyonlarımı gör'));
    await tapRental(tester, find.text('Rezervasyon detayı'));
    expect(find.textContaining('Referans: PM-'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    repository = DeviceRentalRepository(storage, rentalCatalog);
    await tester.pumpWidget(
        RentalApp(key: const ValueKey('restart'), repository: repository));
    await tester.pumpAndSettle();
    await menu(tester, 'Favoriler');
    expect(find.text('Renault Clio'), findsOneWidget);
    await menu(tester, 'Planlarım');
    await tapRental(tester, find.text('Rezervasyonu iptal et'));
    await tapRental(tester, find.text('Evet, iptal et'));
    expect(repository.data.plans.single.cancelled, isTrue);
    expect(find.text('İptal edildi'), findsOneWidget);
  });
  testWidgets(
      'search, empty result recovery, theme and write failure are honest',
      (tester) async {
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final storage = MemoryRentalStorage();
    final repository = DeviceRentalRepository(storage, rentalCatalog);
    await tester.pumpWidget(RentalApp(repository: repository));
    await tester.pumpAndSettle();
    final search = find.widgetWithText(TextField, 'Hangi aracı arıyorsunuz?');
    await tester.ensureVisible(search);
    await tester.enterText(search, 'not-found');
    await tester.pumpAndSettle();
    expect(find.text('Bu seçimle eşleşen araç yok.'), findsOneWidget);
    await tapRental(tester, find.text('Filtreleri temizle'));
    expect(find.text('Renault Clio'), findsOneWidget);
    storage.failWrite = true;
    await tapRental(tester, find.byTooltip('Favorilere ekle').first);
    expect(repository.data.favorites, isEmpty);
    expect(find.text('Değişiklik cihaza kaydedilemedi. Tekrar deneyin.'),
        findsOneWidget);
    storage.failWrite = false;
    await menu(tester, 'Profil');
    await tapRental(tester, find.text('Koyu'));
    expect(repository.data.theme, 'dark');
    expect(Theme.of(tester.element(find.text('Tercihleriniz'))).brightness,
        Brightness.dark);
  });
}
