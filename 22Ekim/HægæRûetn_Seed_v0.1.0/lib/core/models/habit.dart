class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.createdAt,
    required this.completedDates,
    this.archived = false,
  });

  final String id;
  final String name;
  final String description;
  final int difficulty;
  final DateTime createdAt;
  final List<String> completedDates;
  final bool archived;

  bool completedOn(String day) => completedDates.contains(day);

  Habit copyWith({
    String? name,
    String? description,
    int? difficulty,
    List<String>? completedDates,
    bool? archived,
  }) => Habit(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    difficulty: difficulty ?? this.difficulty,
    createdAt: createdAt,
    completedDates: completedDates ?? this.completedDates,
    archived: archived ?? this.archived,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'description': description,
    'difficulty': difficulty, 'createdAt': createdAt.toIso8601String(),
    'completedDates': completedDates, 'archived': archived,
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
    createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    completedDates: (json['completedDates'] as List<dynamic>? ?? []).cast<String>(),
    archived: json['archived'] as bool? ?? false,
  );
}
