class Hypothesis {
  const Hypothesis({
    required this.id,
    required this.ventureId,
    required this.statement,
    required this.createdAt,
  });
  final String id;
  final String ventureId;
  final String statement;
  final DateTime createdAt;
}
