import '../exam/net_calculator.dart';

class ExamScore {
  const ExamScore({
    required this.id,
    required this.examId,
    required this.subjectId,
    required this.subjectName,
    required this.correct,
    required this.wrong,
    required this.blank,
    required this.net,
  });

  final String id;
  final String examId;
  final String subjectId;
  final String subjectName;
  final int correct;
  final int wrong;
  final int blank;
  final double net;

  static ExamScore calculate({
    required String id,
    required String examId,
    required String subjectId,
    required String subjectName,
    required int correct,
    required int wrong,
    required int questionCount,
  }) {
    final net = NetCalculator.calculate(correct: correct, wrong: wrong);
    final blank = (questionCount - correct - wrong).clamp(0, questionCount);
    return ExamScore(
      id: id,
      examId: examId,
      subjectId: subjectId,
      subjectName: subjectName,
      correct: correct,
      wrong: wrong,
      blank: blank,
      net: net,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exam_id': examId,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'correct': correct,
      'wrong': wrong,
      'blank': blank,
      'net': net,
    };
  }

  factory ExamScore.fromMap(Map<String, dynamic> map) {
    return ExamScore(
      id: map['id'] as String,
      examId: map['exam_id'] as String,
      subjectId: map['subject_id'] as String,
      subjectName: map['subject_name'] as String,
      correct: map['correct'] as int? ?? 0,
      wrong: map['wrong'] as int? ?? 0,
      blank: map['blank'] as int? ?? 0,
      net: (map['net'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ExamSession {
  const ExamSession({
    required this.id,
    required this.stage, // 'TYT' or 'AYT'
    required this.title,
    required this.occurredAt,
    this.scope = 'general', // 'general' or 'branch'
    this.totalCorrect = 0,
    this.totalWrong = 0,
    this.totalBlank = 0,
    this.totalNet = 0.0,
    this.scores = const [],
  });

  final String id;
  final String stage;
  final String title;
  final DateTime occurredAt;
  final String scope;
  final int totalCorrect;
  final int totalWrong;
  final int totalBlank;
  final double totalNet;
  final List<ExamScore> scores;

  ExamSession copyWith({
    String? id,
    String? stage,
    String? title,
    DateTime? occurredAt,
    String? scope,
    int? totalCorrect,
    int? totalWrong,
    int? totalBlank,
    double? totalNet,
    List<ExamScore>? scores,
  }) {
    return ExamSession(
      id: id ?? this.id,
      stage: stage ?? this.stage,
      title: title ?? this.title,
      occurredAt: occurredAt ?? this.occurredAt,
      scope: scope ?? this.scope,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
      totalBlank: totalBlank ?? this.totalBlank,
      totalNet: totalNet ?? this.totalNet,
      scores: scores ?? this.scores,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stage': stage,
      'title': title,
      'occurred_at': occurredAt.toIso8601String(),
      'scope': scope,
      'total_correct': totalCorrect,
      'total_wrong': totalWrong,
      'total_blank': totalBlank,
      'total_net': totalNet,
    };
  }

  factory ExamSession.fromMap(
    Map<String, dynamic> map, {
    List<ExamScore> scores = const [],
  }) {
    return ExamSession(
      id: map['id'] as String,
      stage: map['stage'] as String,
      title: map['title'] as String,
      occurredAt: DateTime.parse(map['occurred_at'] as String),
      scope: map['scope'] as String? ?? 'general',
      totalCorrect: map['total_correct'] as int? ?? 0,
      totalWrong: map['total_wrong'] as int? ?? 0,
      totalBlank: map['total_blank'] as int? ?? 0,
      totalNet: (map['total_net'] as num?)?.toDouble() ?? 0.0,
      scores: scores,
    );
  }
}
