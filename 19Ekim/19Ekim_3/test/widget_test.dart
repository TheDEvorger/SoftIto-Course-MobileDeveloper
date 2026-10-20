import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım app smoke test and theme toggle', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pump();

    // Verify header and initial water counter
    expect(find.text('Susadım'), findsOneWidget);
    expect(find.text('0 / 2000 ml'), findsOneWidget);

    // Tap +250 ml button
    await tester.tap(find.text('+250 ml'));
    await tester.pump();

    // Verify counter updated
    expect(find.text('250 / 2000 ml'), findsOneWidget);

    // Verify theme toggle button exists
    expect(find.byType(IconButton), findsWidgets);
  });
}
