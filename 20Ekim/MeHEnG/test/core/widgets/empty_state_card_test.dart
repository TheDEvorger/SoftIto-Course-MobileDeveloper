import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/app/theme/meheng_theme.dart';
import 'package:meheng/core/widgets/empty_state_card.dart';

void main() {
  group('EmptyStateCard', () {
    testWidgets('renders title, description, and icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateCard(
              icon: Icons.lightbulb_outline,
              title: 'Henüz bir girişim yok',
              description: 'İlk fikrini oluşturarak başla.',
            ),
          ),
        ),
      );

      expect(find.text('Henüz bir girişim yok'), findsOneWidget);
      expect(find.text('İlk fikrini oluşturarak başla.'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
    });

    testWidgets('renders action button and handles tap event', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: MehengTheme.light,
          darkTheme: MehengTheme.dark,
          home: Scaffold(
            body: EmptyStateCard(
              title: 'Başlık',
              description: 'Açıklama metni',
              actionLabel: 'Yeni Ekle',
              onAction: () => tapped = true,
            ),
          ),
        ),
      );

      final button = find.widgetWithText(FilledButton, 'Yeni Ekle');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('provides accessible semantics', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateCard(
              title: 'Hipotez Yok',
              description: 'Lütfen bir hipotez ekleyin.',
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(EmptyStateCard));
      expect(
        semantics.label,
        contains('Hipotez Yok. Lütfen bir hipotez ekleyin.'),
      );
    });
  });
}
