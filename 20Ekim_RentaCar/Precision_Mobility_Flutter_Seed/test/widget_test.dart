import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/app/precision_app.dart';

void main() {
  testWidgets('demo shell shows discovery and navigation', (tester) async {
    await tester.pumpWidget(const PrecisionApp());
    expect(find.text('Sürüşünüzü keşfedin'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Keşfet'), findsWidgets);
  });
}
