class Pact {
  const Pact({
    required this.id, required this.title, required this.habitIds,
    required this.goalDays, required this.startedAt, this.completedAt,
  });

  final String id;
  final String title;
  final List<String> habitIds;
  final int goalDays;
  final DateTime startedAt;
  final DateTime? completedAt;

  bool get isCompleted => completedAt != null;

  Pact complete(DateTime at) => Pact(
    id: id, title: title, habitIds: habitIds, goalDays: goalDays,
    startedAt: startedAt, completedAt: at,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'habitIds': habitIds, 'goalDays': goalDays,
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  factory Pact.fromJson(Map<String, dynamic> json) => Pact(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    habitIds: (json['habitIds'] as List<dynamic>? ?? []).cast<String>(),
    goalDays: (json['goalDays'] as num?)?.toInt() ?? 7,
    startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '') ?? DateTime.now(),
    completedAt: DateTime.tryParse(json['completedAt'] as String? ?? ''),
  );
}
