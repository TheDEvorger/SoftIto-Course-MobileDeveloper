import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dil_rotasi/data/word_repository.dart';
import 'package:dil_rotasi/main.dart';
import 'package:dil_rotasi/models/vocabulary_word.dart';

class FakeRepository implements WordRepository {
  List<VocabularyWord> words = [];
  int goal = 5;

  @override
  Future<List<VocabularyWord>> loadWords() async => List.of(words);
  @override
  Future<void> saveWords(List<VocabularyWord> value) async => words = List.of(value);
  @override
  Future<int> loadDailyGoal() async => goal;
  @override
  Future<void> saveDailyGoal(int value) async => goal = value;
}

void main() {
  test('JSON dönüştürme dil, aşama ve tekrar sayısını korur', () {
    final source = VocabularyWord(
      id: 'test-01',
      language: StudyLanguage.german,
      word: 'lernen',
      meaning: 'öğrenmek',
      example: 'Ich lerne Deutsch.',
      stage: WordStage.learning,
      reviewCount: 3,
      createdAt: DateTime(2026, 10, 16),
    );
    final copy = VocabularyWord.fromJson(source.toJson());
    expect(copy.word, 'lernen');
    expect(copy.stage, WordStage.learning);
    expect(copy.reviewCount, 3);
    expect(copy.example, 'Ich lerne Deutsch.');
  });

  testWidgets('Üç ekran açılır ve eklenen kelime deftere gider', (tester) async {
    final repo = FakeRepository();
    await tester.pumpWidget(DilRotasiApp(repository: repo));
    await tester.pumpAndSettle();

    expect(find.textContaining('Bir kelime daha'), findsOneWidget);
    await tester.tap(find.widgetWithText(NavigationDestination, 'Defterim'));
    await tester.pumpAndSettle();
    expect(find.text('Kelime defterim'), findsOneWidget);

    await tester.tap(find.widgetWithText(NavigationDestination, 'Kelime ekle'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Defterine bir'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'die Arbeit');
    await tester.enterText(find.byType(TextFormField).at(1), 'iş');
    await tester.ensureVisible(find.text('Kelimeyi deftere kaydet'));
    await tester.tap(find.text('Kelimeyi deftere kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Kelime defterim'), findsOneWidget);
    expect(find.text('die Arbeit'), findsOneWidget);
    expect(repo.words.single.meaning, 'iş');
  });
}
