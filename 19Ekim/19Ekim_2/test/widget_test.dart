import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('shows the Turkish water tracker dashboard', (tester) async {
    await tester.pumpWidget(const SusadimApp());

    expect(find.text('SUSADIM'), findsOneWidget);
    expect(find.text('Günlük su hedefi'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Su ekle'), findsOneWidget);
    expect(find.text('Hareket ve kalori'), findsOneWidget);
    expect(find.byTooltip('Aydınlık moda geç'), findsOneWidget);
  });

  testWidgets('adds a glass of water to today', (tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.tap(find.text('Su ekle'));
    await tester.pump();

    expect(find.text('250'), findsOneWidget);
    expect(find.text('250 ml'), findsOneWidget);
  });

  testWidgets('toggles between dark and light themes dynamically',
      (tester) async {
    await tester.pumpWidget(const SusadimApp());

    // Initially in dark mode, button invites to switch to light mode
    final toggleButton = find.byTooltip('Aydınlık moda geç');
    expect(toggleButton, findsOneWidget);
    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);

    // Tap to switch to light mode
    await tester.tap(toggleButton);
    await tester.pumpAndSettle();

    // Now in light mode, button invites to switch to dark mode
    expect(find.byTooltip('Karanlık moda geç'), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);

    // Tap to switch back to dark mode
    await tester.tap(find.byTooltip('Karanlık moda geç'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Aydınlık moda geç'), findsOneWidget);
  });
}
