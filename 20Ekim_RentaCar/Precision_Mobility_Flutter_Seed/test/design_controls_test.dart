import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/core/theme/precision_theme.dart';
import 'package:precision_mobility/shared/widgets/precision_button.dart';
import 'package:precision_mobility/shared/widgets/precision_empty_state.dart';
import 'package:precision_mobility/shared/widgets/precision_search_field.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('$brightness controls support keyboard and disabled states',
        (tester) async {
      var clicks = 0;
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(MaterialApp(
          theme: brightness == Brightness.light
              ? PrecisionTheme.light()
              : PrecisionTheme.dark(),
          home: Scaffold(
            body: Column(children: [
              PrecisionButton(label: 'Devam', onPressed: () => clicks++),
              const PrecisionButton(label: 'Devre dışı', onPressed: null),
              PrecisionButton(
                label: 'Geri',
                style: PrecisionButtonStyle.secondary,
                onPressed: () => clicks++,
              ),
            ]),
          ),
        ));
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(clicks, 1);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(clicks, 2, reason: 'Tab skips the disabled control');
        await tester.tap(find.text('Devre dışı'));
        expect(clicks, 2);
        expect(tester.getSize(find.byType(FilledButton).first).height,
            greaterThanOrEqualTo(48));
        expect(tester.getSize(find.byType(OutlinedButton)).height,
            greaterThanOrEqualTo(48));
        expect(
            tester.getSemantics(find.text('Devam')),
            matchesSemantics(
                isButton: true,
                hasEnabledState: true,
                isEnabled: true,
                isFocusable: true,
                hasTapAction: true,
                hasFocusAction: true,
                label: 'Devam'));
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    });
  }

  testWidgets('search keeps a label and reports edited text', (tester) async {
    var query = '';
    await tester.pumpWidget(MaterialApp(
      theme: PrecisionTheme.light(),
      home: Scaffold(
          body: PrecisionSearchField(
        label: 'Araç adı ara',
        onChanged: (value) => query = value,
      )),
    ));
    await tester.enterText(find.byType(TextField), 'Demo');
    await tester.pump();
    expect(query, 'Demo');
    expect(find.text('Araç adı ara'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).textInputAction,
        TextInputAction.search);
  });

  testWidgets('empty state announces text without relying on color',
      (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: PrecisionEmptyState(title: 'Sonuç yok', message: 'Tekrar ara'),
      )));
      expect(find.text('Sonuç yok'), findsOneWidget);
      expect(find.text('Tekrar ara'), findsOneWidget);
      final nodes = tester.widgetList<Semantics>(find.byType(Semantics));
      expect(nodes.any((node) => node.properties.liveRegion == true), isTrue);
    } finally {
      semantics.dispose();
    }
  });
}
