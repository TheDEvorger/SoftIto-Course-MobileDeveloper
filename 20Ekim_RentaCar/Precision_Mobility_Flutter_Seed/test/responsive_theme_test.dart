import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/app/precision_app.dart';
import 'package:precision_mobility/shared/widgets/precision_empty_state.dart';

void main() {
  for (final width in [320.0, 1200.0]) {
    for (final brightness in Brightness.values) {
      testWidgets('$width $brightness shell and empty search', (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.platformBrightnessTestValue = brightness;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
        await tester.pumpWidget(const PrecisionApp());
        await tester.pumpAndSettle();
        expect(find.byType(width < 840 ? NavigationBar : NavigationRail),
            findsOneWidget);
        expect(Theme.of(tester.element(find.byType(TextField))).brightness,
            brightness);
        expect(tester.takeException(), isNull);
        await tester.enterText(find.byType(TextField), 'zzzz-no-match');
        await tester.pumpAndSettle();
        expect(find.byType(PrecisionEmptyState), findsOneWidget);
        expect(find.text('Araç bulunamadı'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
