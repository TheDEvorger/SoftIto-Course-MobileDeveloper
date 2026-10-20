import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/core/theme/precision_theme.dart';
import 'package:precision_mobility/features/discovery/domain/demo_vehicle.dart';
import 'package:precision_mobility/features/discovery/presentation/discovery_map.dart';
import 'package:precision_mobility/features/discovery/presentation/discovery_screen.dart';
import 'package:precision_mobility/features/discovery/presentation/vehicle_card.dart';

void main() {
  Future<void> open(WidgetTester tester, double width,
      {double textScale = 1, bool dark = false}) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      theme: dark ? PrecisionTheme.dark() : PrecisionTheme.light(),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: const Scaffold(body: DiscoveryScreen()),
      ),
    ));
    await tester.pumpAndSettle();
  }

  for (final width in [320.0, 600.0, 899.0, 900.0, 1440.0]) {
    for (final dark in [false, true]) {
      testWidgets('discovery $width dark=$dark filters and map',
          (tester) async {
        await open(tester, width, dark: dark);
        final wide = width >= 900;
        expect(find.byKey(const ValueKey('discovery-split')),
            wide ? findsOneWidget : findsNothing);
        expect(find.byType(SegmentedButton<bool>),
            wide ? findsNothing : findsOneWidget);
        if (!wide) {
          await tester.tap(find.text('Harita'));
          await tester.pumpAndSettle();
        }
        expect(find.byType(DiscoveryMap), findsOneWidget);
        for (final vehicle in demoVehicles) {
          expect(find.byKey(ValueKey('map-${vehicle.name}')), findsOneWidget);
        }
        final marker = find.byKey(const ValueKey('map-Urban E'));
        await tester.ensureVisible(marker);
        await tester.tap(marker);
        await tester.pumpAndSettle();
        expect(find.text('Seçilen örnek: Urban E'), findsOneWidget);
        await tester.ensureVisible(find.byType(FilterChip));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FilterChip));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('map-Urban E')), findsNothing);
        expect(find.byKey(const ValueKey('map-Executive S')), findsOneWidget);
        expect(find.text('Seçilen örnek: Urban E'), findsNothing);
        await tester.enterText(find.byType(TextField), ' GRAND ');
        await tester.pumpAndSettle();
        expect(find.text('Koleksiyon • 1 örnek araç'), findsOneWidget);
        expect(find.byKey(const ValueKey('map-Grand Tourer')), findsOneWidget);
        expect(find.byKey(const ValueKey('map-Executive S')), findsNothing);
        await tester.enterText(find.byType(TextField), 'urban');
        await tester.pumpAndSettle();
        await tester.drag(
            find.byType(CustomScrollView).first, const Offset(0, -500));
        await tester.pumpAndSettle();
        expect(find.text('Araç bulunamadı'), findsOneWidget);
        expect(find.byType(IconButton), findsNothing);
        await tester.ensureVisible(find.byType(FilterChip));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(FilterChip));
        await tester.pumpAndSettle();
        expect(find.text('Koleksiyon • 1 örnek araç'), findsOneWidget);
        if (!wide) {
          await tester.tap(find.text('Liste'));
          await tester.pumpAndSettle();
          expect(find.byType(DiscoveryMap), findsNothing);
        }
        expect(
            tester
                .widget<VehicleCard>(find.byType(VehicleCard).first)
                .vehicle
                .name,
            'Urban E');
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final width in [320.0, 900.0, 1440.0]) {
    testWidgets('discovery $width with large text', (tester) async {
      await open(tester, width, textScale: 2);
      await tester.drag(
          find.byType(CustomScrollView).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
