import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/app/precision_app.dart';
import 'package:precision_mobility/features/discovery/domain/demo_vehicle.dart';
import 'package:precision_mobility/features/discovery/presentation/vehicle_details_screen.dart';

void main() {
  test('fixtures have unique IDs and complete attributes', () {
    expect(demoVehicles.map((v) => v.id).toSet().length, demoVehicles.length);
    for (final v in demoVehicles) {
      expect(findDemoVehicle(v.id), same(v));
      expect(v.seats, greaterThan(0));
      expect(v.energy, isNotEmpty);
      expect(v.description, isNotEmpty);
    }
    expect(findDemoVehicle('missing'), isNull);
  });
  testWidgets('card opens details and back preserves search', (tester) async {
    await tester.pumpWidget(const PrecisionApp());
    await tester.enterText(find.byType(TextField), 'urban');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aracı incele'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aracı incele'));
    await tester.pumpAndSettle();
    expect(find.byType(VehicleDetailsScreen), findsOneWidget);
    expect(find.text('Örnek bireysel araç sahibi'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        'urban');
    expect(tester.takeException(), isNull);
  });
  testWidgets('missing vehicle shows recoverable empty state', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: VehicleDetailsScreen(vehicleId: 'missing')));
    expect(find.text('Araç bulunamadı'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
