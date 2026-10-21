class FocusSession {
  const FocusSession({
    required this.id,
    required this.startedAt,
    required this.durationSeconds,
    required this.elapsedSeconds,
    this.subjectId,
    this.completed = false,
  });

  final String id;
  final DateTime startedAt;
  final int durationSeconds;
  final int elapsedSeconds;
  final String? subjectId;
  final bool completed;

  FocusSession copyWith({
    String? id,
    DateTime? startedAt,
    int? durationSeconds,
    int? elapsedSeconds,
    String? subjectId,
    bool? completed,
  }) {
    return FocusSession(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      subjectId: subjectId ?? this.subjectId,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'started_at': startedAt.toIso8601String(),
      'duration_seconds': durationSeconds,
      'elapsed_seconds': elapsedSeconds,
      'subject_id': subjectId,
      'completed': completed ? 1 : 0,
    };
  }

  factory FocusSession.fromMap(Map<String, dynamic> map) {
    return FocusSession(
      id: map['id'] as String,
      startedAt: DateTime.parse(map['started_at'] as String),
      durationSeconds: map['duration_seconds'] as int? ?? 1500,
      elapsedSeconds: map['elapsed_seconds'] as int? ?? 0,
      subjectId: map['subject_id'] as String?,
      completed: (map['completed'] as int?) == 1,
    );
  }
}
