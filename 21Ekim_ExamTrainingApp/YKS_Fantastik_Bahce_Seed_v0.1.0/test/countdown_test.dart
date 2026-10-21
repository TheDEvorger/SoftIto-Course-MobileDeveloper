import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fantastik_bahce_yks/domain/countdown/countdown_calculator.dart';
import 'package:fantastik_bahce_yks/shared/widgets/countdown_card.dart';

void main() {
  group('TASK-004: CountdownCalculator Unit Tests', () {
    test('targetDate is null returns notSet', () {
      final result = CountdownCalculator.calculate(
        targetDate: null,
        now: DateTime(2026, 10, 21, 12, 0),
      );
      expect(result.state, CountdownState.notSet);
      expect(result.isNotSet, isTrue);
    });

    test('targetDate in the past returns completed', () {
      final result = CountdownCalculator.calculate(
        targetDate: DateTime(2026, 6, 20, 10, 15),
        now: DateTime(2026, 10, 21, 12, 0),
      );
      expect(result.state, CountdownState.completed);
      expect(result.isCompleted, isTrue);
    });

    test(
        'targetDate in the future calculates exact days, hours, minutes, seconds',
        () {
      final now = DateTime(2026, 10, 21, 10, 0, 0);
      final target = DateTime(2026, 10, 23, 15, 30, 45);

      final result = CountdownCalculator.calculate(
        targetDate: target,
        now: now,
      );

      expect(result.state, CountdownState.running);
      expect(result.days, 2);
      expect(result.hours, 5);
      expect(result.minutes, 30);
      expect(result.seconds, 45);
    });
  });

  group('TASK-004: YksCountdownCard Widget Tests', () {
    testWidgets('renders notSet state and triggers onEditDate', (tester) async {
      var edited = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YksCountdownCard(
              targetDate: null,
              onEditDate: () => edited = true,
            ),
          ),
        ),
      );

      expect(find.text('Sınav Tarihi Henüz Belirlenmedi'), findsOneWidget);
      expect(find.text('Sınav Tarihini Belirle'), findsOneWidget);

      await tester.tap(find.text('Sınav Tarihini Belirle'));
      await tester.pumpAndSettle();
      expect(edited, isTrue);
    });

    testWidgets('renders completed state for past exam date', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YksCountdownCard(
              targetDate: DateTime.now().subtract(const Duration(days: 2)),
              onEditDate: () {},
            ),
          ),
        ),
      );

      expect(find.text('Sınav Günü Geldi! 🌱'), findsOneWidget);
    });

    testWidgets('renders active countdown for future exam date',
        (tester) async {
      final futureDate =
          DateTime.now().add(const Duration(days: 120, hours: 4));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YksCountdownCard(
              targetDate: futureDate,
              onEditDate: () {},
            ),
          ),
        ),
      );

      expect(find.text('YKS Geri Sayımı'), findsOneWidget);
      expect(find.text('GÜN'), findsOneWidget);
      expect(find.text('SAAT'), findsOneWidget);
      expect(find.text('DAKİKA'), findsOneWidget);
      expect(find.text('SANİYE'), findsOneWidget);
    });
  });
}
