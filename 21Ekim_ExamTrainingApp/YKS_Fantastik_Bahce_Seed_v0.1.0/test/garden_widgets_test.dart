import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fantastik_bahce_yks/shared/widgets/garden_buttons.dart';
import 'package:fantastik_bahce_yks/shared/widgets/garden_cards.dart';
import 'package:fantastik_bahce_yks/shared/widgets/garden_inputs.dart';
import 'package:fantastik_bahce_yks/shared/widgets/garden_progress.dart';

void main() {
  group('GardenButtons Tests', () {
    testWidgets('GardenPrimaryButton renders label and fires callback',
        (tester) async {
      var clicked = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GardenPrimaryButton(
              label: 'Başla',
              onPressed: () => clicked = true,
            ),
          ),
        ),
      );

      expect(find.text('Başla'), findsOneWidget);
      await tester.tap(find.text('Başla'));
      await tester.pumpAndSettle();
      expect(clicked, isTrue);
    });

    testWidgets('GoldenActionButton renders badge and handles tap',
        (tester) async {
      var clicked = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoldenActionButton(
              label: 'Hedef Belirle',
              badgeText: 'YENİ',
              onPressed: () => clicked = true,
            ),
          ),
        ),
      );

      expect(find.text('Hedef Belirle'), findsOneWidget);
      expect(find.text('YENİ'), findsOneWidget);
      await tester.tap(find.text('Hedef Belirle'));
      await tester.pumpAndSettle();
      expect(clicked, isTrue);
    });

    testWidgets('NatureSegmentedControl switches selected option',
        (tester) async {
      var selected = 'TYT';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => NatureSegmentedControl<String>(
                items: const {'TYT': 'TYT', 'AYT': 'AYT'},
                selected: selected,
                onChanged: (val) => setState(() => selected = val),
              ),
            ),
          ),
        ),
      );

      expect(find.text('TYT'), findsOneWidget);
      expect(find.text('AYT'), findsOneWidget);

      await tester.tap(find.text('AYT'));
      await tester.pumpAndSettle();
      expect(selected, 'AYT');
    });
  });

  group('GardenCards Tests', () {
    testWidgets('GardenCard renders child content and triggers onTap',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GardenCard(
              onTap: () => tapped = true,
              child: const Text('İçerik'),
            ),
          ),
        ),
      );

      expect(find.text('İçerik'), findsOneWidget);
      await tester.tap(find.text('İçerik'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('WaterInfoCard renders title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WaterInfoCard(
              title: 'Önemli Bilgi',
              message: 'Net hesaplamasında dikkat edilmesi gereken kurallar.',
            ),
          ),
        ),
      );

      expect(find.text('Önemli Bilgi'), findsOneWidget);
      expect(find.textContaining('Net hesaplamasında'), findsOneWidget);
    });
  });

  group('GardenProgress Tests', () {
    testWidgets('LeafProgressBar displays percentage correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LeafProgressBar(
              progress: 0.75,
              label: 'Matematik',
            ),
          ),
        ),
      );

      expect(find.text('Matematik'), findsOneWidget);
      expect(find.text('%75'), findsOneWidget);
    });

    testWidgets('OrganicProgressRing renders center text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OrganicProgressRing(
              progress: 0.50,
              centerText: '%50',
              subText: 'Tamamlandı',
            ),
          ),
        ),
      );

      expect(find.text('%50'), findsOneWidget);
      expect(find.text('Tamamlandı'), findsOneWidget);
    });
  });

  group('GardenInputs Tests', () {
    testWidgets('GardenExamScoreField updates value', (tester) async {
      final controller = TextEditingController(text: '10');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GardenExamScoreField(
              controller: controller,
              type: ScoreFieldType.correct,
            ),
          ),
        ),
      );

      expect(find.text('Doğru'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '25');
      await tester.pumpAndSettle();
      expect(controller.text, '25');
    });

    testWidgets('NatureSearchField can input and clear text', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NatureSearchField(
              controller: controller,
              hintText: 'Arama yap...',
            ),
          ),
        ),
      );

      expect(find.text('Arama yap...'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Türev');
      await tester.pumpAndSettle();
      expect(controller.text, 'Türev');

      // Clear icon should appear
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      expect(controller.text, '');
    });
  });
}
