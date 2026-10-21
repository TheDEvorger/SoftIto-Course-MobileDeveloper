enum TopicStatus {
  notStarted,
  inProgress,
  completed;

  String get label {
    switch (this) {
      case TopicStatus.notStarted:
        return 'Eksik';
      case TopicStatus.inProgress:
        return 'Çalışılıyor';
      case TopicStatus.completed:
        return 'Tamamlandı';
    }
  }
}

class Subject {
  const Subject({
    required this.id,
    required this.stage,
    required this.name,
    required this.orderIndex,
    this.questionCount = 40,
  });

  final String id;
  final String stage; // 'TYT' or 'AYT'
  final String name;
  final int orderIndex;
  final int questionCount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stage': stage,
      'name': name,
      'order_index': orderIndex,
      'question_count': questionCount,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] as String,
      stage: map['stage'] as String,
      name: map['name'] as String,
      orderIndex: map['order_index'] as int? ?? 0,
      questionCount: map['question_count'] as int? ?? 40,
    );
  }
}

class Topic {
  const Topic({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.orderIndex,
    this.curriculumYear = 2026,
  });

  final String id;
  final String subjectId;
  final String name;
  final int orderIndex;
  final int curriculumYear;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_id': subjectId,
      'name': name,
      'order_index': orderIndex,
      'curriculum_year': curriculumYear,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map) {
    return Topic(
      id: map['id'] as String,
      subjectId: map['subject_id'] as String,
      name: map['name'] as String,
      orderIndex: map['order_index'] as int? ?? 0,
      curriculumYear: map['curriculum_year'] as int? ?? 2026,
    );
  }
}

class TopicProgress {
  const TopicProgress({
    required this.topicId,
    this.status = TopicStatus.notStarted,
    this.answeredCount = 0,
    this.lastStudiedAt,
  });

  final String topicId;
  final TopicStatus status;
  final int answeredCount;
  final DateTime? lastStudiedAt;

  TopicProgress copyWith({
    String? topicId,
    TopicStatus? status,
    int? answeredCount,
    DateTime? lastStudiedAt,
  }) {
    return TopicProgress(
      topicId: topicId ?? this.topicId,
      status: status ?? this.status,
      answeredCount: answeredCount ?? this.answeredCount,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topic_id': topicId,
      'status': status.name,
      'answered_count': answeredCount,
      'last_studied_at': lastStudiedAt?.toIso8601String(),
    };
  }

  factory TopicProgress.fromMap(Map<String, dynamic> map) {
    return TopicProgress(
      topicId: map['topic_id'] as String,
      status: TopicStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TopicStatus.notStarted,
      ),
      answeredCount: map['answered_count'] as int? ?? 0,
      lastStudiedAt: map['last_studied_at'] != null
          ? DateTime.tryParse(map['last_studied_at'] as String)
          : null,
    );
  }
}
