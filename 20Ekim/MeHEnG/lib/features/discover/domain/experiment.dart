class Experiment {
  const Experiment({
    required this.id,
    required this.hypothesisId,
    required this.title,
    required this.method,
    required this.createdAt,
  });
  final String id;
  final String hypothesisId;
  final String title;
  final String method;
  final DateTime createdAt;
}
