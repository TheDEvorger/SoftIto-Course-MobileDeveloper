class Venture {
  const Venture({
    required this.id,
    required this.name,
    required this.problem,
    required this.audience,
    required this.createdAt,
    this.isArchived = false,
  });

  final String id;
  final String name;
  final String problem;
  final String audience;
  final DateTime createdAt;
  final bool isArchived;

  Venture copyWith({
    String? name,
    String? problem,
    String? audience,
    bool? isArchived,
  }) => Venture(
    id: id,
    name: name ?? this.name,
    problem: problem ?? this.problem,
    audience: audience ?? this.audience,
    createdAt: createdAt,
    isArchived: isArchived ?? this.isArchived,
  );

  static String? validateName(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.length < 3) return 'En az 3 karakter girin.';
    if (value.length > 80) return 'En fazla 80 karakter girin.';
    return null;
  }
}
