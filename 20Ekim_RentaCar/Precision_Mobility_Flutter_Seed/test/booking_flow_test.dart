import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/app/precision_app.dart';

void main() {
  testWidgets('details quote confirm and cancel demo', (tester) async {
    await tester.pumpWidget(const PrecisionApp());
    await tester.enterText(find.byType(TextField), 'urban');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Aracı incele'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aracı incele'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Rezervasyon demosunu aç'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rezervasyon demosunu aç'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Örnek teklif oluştur'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Demo onayı ver'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Demo onayı ver'));
    await tester.pumpAndSettle();
    expect(find.text('Demo rezervasyon onaylandı'), findsOneWidget);
    await tester.ensureVisible(find.text('Örnek rezervasyonu iptal et'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Örnek rezervasyonu iptal et'));
    await tester.pumpAndSettle();
    expect(find.text('İptal edildi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
