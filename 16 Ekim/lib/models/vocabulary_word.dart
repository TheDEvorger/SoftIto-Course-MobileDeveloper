/// Dil ve öğrenme aşamaları için açık, tür güvenli modeller.
enum StudyLanguage { german, english }

extension StudyLanguageX on StudyLanguage {
  String get label => switch (this) {
        StudyLanguage.german => 'Almanca',
        StudyLanguage.english => 'İngilizce',
      };

  String get code => switch (this) {
        StudyLanguage.german => 'DE',
        StudyLanguage.english => 'EN',
      };

  String get flag => switch (this) {
        StudyLanguage.german => '🇩🇪',
        StudyLanguage.english => '🇬🇧',
      };
}

enum WordStage { newWord, learning, mastered }

extension WordStageX on WordStage {
  String get label => switch (this) {
        WordStage.newWord => 'Yeni',
        WordStage.learning => 'Çalışılıyor',
        WordStage.mastered => 'Öğrenildi',
      };

  WordStage get next => switch (this) {
        WordStage.newWord => WordStage.learning,
        WordStage.learning => WordStage.mastered,
        WordStage.mastered => WordStage.mastered,
      };
}

class VocabularyWord {
  const VocabularyWord({
    required this.id,
    required this.language,
    required this.word,
    required this.meaning,
    required this.createdAt,
    this.example = '',
    this.stage = WordStage.newWord,
    this.reviewCount = 0,
    this.lastReviewedAt,
  });

  final String id;
  final StudyLanguage language;
  final String word;
  final String meaning;
  final String example;
  final WordStage stage;
  final DateTime createdAt;
  final DateTime? lastReviewedAt;
  final int reviewCount;

  VocabularyWord copyWith({
    WordStage? stage,
    DateTime? lastReviewedAt,
    int? reviewCount,
  }) => VocabularyWord(
        id: id,
        language: language,
        word: word,
        meaning: meaning,
        example: example,
        stage: stage ?? this.stage,
        createdAt: createdAt,
        lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
        reviewCount: reviewCount ?? this.reviewCount,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'language': language.name,
        'word': word,
        'meaning': meaning,
        'example': example,
        'stage': stage.name,
        'createdAt': createdAt.toIso8601String(),
        'lastReviewedAt': lastReviewedAt?.toIso8601String(),
        'reviewCount': reviewCount,
      };

  factory VocabularyWord.fromJson(Map<String, dynamic> json) => VocabularyWord(
        id: json['id'] as String,
        language: StudyLanguage.values.byName(json['language'] as String),
        word: json['word'] as String,
        meaning: json['meaning'] as String,
        example: (json['example'] as String?) ?? '',
        stage: WordStage.values.byName((json['stage'] as String?) ?? 'newWord'),
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastReviewedAt: json['lastReviewedAt'] == null
            ? null
            : DateTime.parse(json['lastReviewedAt'] as String),
        reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      );
}
