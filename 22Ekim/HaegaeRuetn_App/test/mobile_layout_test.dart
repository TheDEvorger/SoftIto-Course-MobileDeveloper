import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haegaruuetn/app/hager_app.dart';
import 'package:haegaruuetn/core/data/local_realm_store.dart';
import 'package:haegaruuetn/core/state/realm_controller.dart';
import 'package:haegaruuetn/features/guide/guide_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final size in [const Size(402, 874), const Size(375, 667)]) {
    testWidgets('five tabs and guide keyboard fit on $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues({});
      final controller = RealmController(LocalRealmStore());
      await controller.initialize();
      await tester.pumpWidget(HagerApp(controller: controller));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      for (final label in ['Ahitler', 'Meydan', 'Rehber', 'Kronik']) {
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: label);
      }

      await tester.tap(find.text('Rehber').last);
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextField), 'Bir adım atmak istiyorum');
      await tester.tap(find.byTooltip('Gönder'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
          isEmpty);
      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Bir adım atmak istiyorum'),
        150,
        scrollable: find
            .descendant(
              of: find.byType(GuideScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('Bir adım atmak istiyorum'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
