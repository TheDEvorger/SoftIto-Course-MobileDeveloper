import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/features/discover/domain/evidence.dart';
import 'package:meheng/features/discover/domain/experiment.dart';
import 'package:meheng/features/discover/domain/hypothesis.dart';
import 'package:meheng/features/discover/presentation/decision_card.dart';
import 'package:meheng/features/discover/presentation/decisions_section.dart';
import 'package:meheng/features/discover/presentation/discover_providers.dart';
import '../../fakes/fake_discover_repository.dart';

void main() {
  late FakeDiscoverRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeDiscoverRepository();
  });

  Widget buildSubject() {
    return ProviderScope(
      overrides: [discoverRepositoryProvider.overrideWithValue(fakeRepo)],
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: DecisionsSection(ventureId: 'v1'),
          ),
        ),
      ),
    );
  }

  testWidgets('renders empty state when no decisions recorded', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text('Karar Günlüğü'), findsOneWidget);
    expect(find.text('Henüz stratejik karar yok'), findsOneWidget);
    expect(find.text('Karar ekle'), findsWidgets);
  });

  testWidgets('opens DecisionDialog and records a new strategic decision', (tester) async {
    final now = DateTime.now();
    fakeRepo.addHypothesis(
      Hypothesis(id: 'h1', ventureId: 'v1', statement: 'Hipotez 1', createdAt: now),
    );
    fakeRepo.addExperiment(
      Experiment(id: 'x1', hypothesisId: 'h1', title: 'Deney 1', method: 'Yöntem 1', createdAt: now),
    );
    fakeRepo.addEvidence(
      Evidence(
        id: 'e1',
        experimentId: 'x1',
        note: 'Kullanıcılar fiyatı yüksek buldu',
        direction: EvidenceDirection.contradicts,
        createdAt: now,
      ),
    );

    await tester.pumpWidget(buildSubject());

    // Tap Karar ekle
    await tester.tap(find.text('Karar ekle').first);
    await tester.pumpAndSettle();

    expect(find.text('Stratejik Karar Kaydet'), findsOneWidget);

    // Enter rationale
    await tester.enterText(
      find.byType(TextField),
      'Müşteri geri bildirimleri sebebiyle fiyat modeli yeniden değerlendirilecek.',
    );

    // Select evidence checkbox
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();

    // Tap submit button
    await tester.tap(find.text('Kararı kaydet'));
    await tester.pumpAndSettle();

    // Dialog closed, decision card displayed
    expect(find.byType(DecisionCard), findsOneWidget);
    expect(
      find.text('Müşteri geri bildirimleri sebebiyle fiyat modeli yeniden değerlendirilecek.'),
      findsOneWidget,
    );
    expect(find.textContaining('Kullanıcılar fiyatı yüksek buldu'), findsOneWidget);
  });
}
