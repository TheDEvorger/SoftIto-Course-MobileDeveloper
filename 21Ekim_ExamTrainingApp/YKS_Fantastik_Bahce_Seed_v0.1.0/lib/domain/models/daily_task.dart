class DailyTask {
  const DailyTask({
    required this.id,
    required this.scheduledDate,
    required this.description,
    this.subjectId,
    this.topicId,
    this.targetQuestions = 0,
    this.isDone = false,
  });

  final String id;
  final DateTime scheduledDate;
  final String description;
  final String? subjectId;
  final String? topicId;
  final int targetQuestions;
  final bool isDone;

  DailyTask copyWith({
    String? id,
    DateTime? scheduledDate,
    String? description,
    String? subjectId,
    String? topicId,
    int? targetQuestions,
    bool? isDone,
  }) {
    return DailyTask(
      id: id ?? this.id,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      description: description ?? this.description,
      subjectId: subjectId ?? this.subjectId,
      topicId: topicId ?? this.topicId,
      targetQuestions: targetQuestions ?? this.targetQuestions,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scheduled_date':
          '${scheduledDate.year.toString().padLeft(4, '0')}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}',
      'description': description,
      'subject_id': subjectId,
      'topic_id': topicId,
      'target_questions': targetQuestions,
      'is_done': isDone ? 1 : 0,
    };
  }

  factory DailyTask.fromMap(Map<String, dynamic> map) {
    return DailyTask(
      id: map['id'] as String,
      scheduledDate: DateTime.parse(map['scheduled_date'] as String),
      description: map['description'] as String,
      subjectId: map['subject_id'] as String?,
      topicId: map['topic_id'] as String?,
      targetQuestions: map['target_questions'] as int? ?? 0,
      isDone: (map['is_done'] as int?) == 1,
    );
  }
}
