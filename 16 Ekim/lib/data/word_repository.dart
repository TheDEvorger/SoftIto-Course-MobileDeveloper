import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/vocabulary_word.dart';

/// Ekranlar veri kaynağına doğrudan dokunmaz. State üst seviyede yönetilir.
abstract class WordRepository {
  Future<List<VocabularyWord>> loadWords();
  Future<void> saveWords(List<VocabularyWord> words);
  Future<int> loadDailyGoal();
  Future<void> saveDailyGoal(int goal);
}

class PreferencesWordRepository implements WordRepository {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static const _wordsKey = 'dil_rotasi_words_v1';
  static const _goalKey = 'dil_rotasi_daily_goal_v1';

  @override
  Future<List<VocabularyWord>> loadWords() async {
    final raw = await _prefs.getString(_wordsKey);
    if (raw == null) return demoWords();
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((json) => VocabularyWord.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveWords(List<VocabularyWord> words) async {
    await _prefs.setString(_wordsKey, jsonEncode(words.map((w) => w.toJson()).toList()));
  }

  @override
  Future<int> loadDailyGoal() async => (await _prefs.getInt(_goalKey)) ?? 5;

  @override
  Future<void> saveDailyGoal(int goal) async {
    await _prefs.setInt(_goalKey, goal);
  }
}

/// İlk çalıştırmada örnek olarak gösterilir; ardından kullanıcı verisi kaydedilir.
List<VocabularyWord> demoWords() {
  final now = DateTime.now();
  final examples = <(StudyLanguage, String, String, String, WordStage)>[
    (StudyLanguage.german, 'die Möglichkeit', 'olasılık, imkân', 'Ich habe eine neue Möglichkeit.', WordStage.learning),
    (StudyLanguage.german, 'zuverlässig', 'güvenilir', 'Er ist sehr zuverlässig.', WordStage.newWord),
    (StudyLanguage.german, 'die Erfahrung', 'deneyim', 'Ich habe zwei Jahre Erfahrung.', WordStage.learning),
    (StudyLanguage.german, 'das Werkzeug', 'alet, araç', 'Das Werkzeug liegt auf dem Tisch.', WordStage.mastered),
    (StudyLanguage.german, 'verstehen', 'anlamak', 'Ich verstehe die Frage.', WordStage.newWord),
    (StudyLanguage.german, 'sich bewerben', 'işe başvurmak', 'Ich möchte mich bewerben.', WordStage.newWord),
    (StudyLanguage.english, 'opportunity', 'fırsat', 'This is a great opportunity.', WordStage.learning),
    (StudyLanguage.english, 'reliable', 'güvenilir', 'The system is reliable.', WordStage.newWord),
    (StudyLanguage.english, 'improve', 'geliştirmek', 'I want to improve my English.', WordStage.learning),
    (StudyLanguage.english, 'experience', 'deneyim', 'I have work experience.', WordStage.mastered),
    (StudyLanguage.english, 'achieve', 'başarmak', 'We can achieve our goals.', WordStage.newWord),
    (StudyLanguage.english, 'troubleshoot', 'arıza gidermek', 'I can troubleshoot the PLC.', WordStage.newWord),
  ];
  return [
    for (var index = 0; index < examples.length; index++)
      VocabularyWord(
        id: 'sample-$index',
        language: examples[index].$1,
        word: examples[index].$2,
        meaning: examples[index].$3,
        example: examples[index].$4,
        stage: examples[index].$5,
        createdAt: now.subtract(Duration(days: index + 1)),
      ),
  ];
}
