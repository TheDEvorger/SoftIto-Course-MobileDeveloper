enum DecisionOutcome {
  continueRun,
  pivot,
  stop;

  String get label => switch (this) {
        DecisionOutcome.continueRun => 'Devam Et (Persevere)',
        DecisionOutcome.pivot => 'Yön Değiştir (Pivot)',
        DecisionOutcome.stop => 'Sonlandır (Stop)',
      };
}

class Decision {
  const Decision({
    required this.id,
    required this.ventureId,
    required this.outcome,
    required this.rationale,
    required this.evidenceIds,
    required this.createdAt,
    this.hypothesisId,
  });

  final String id;
  final String ventureId;
  final String? hypothesisId;
  final DecisionOutcome outcome;
  final String rationale;
  final List<String> evidenceIds;
  final DateTime createdAt;
}
