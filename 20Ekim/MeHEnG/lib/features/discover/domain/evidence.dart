class Evidence {
  const Evidence({
    required this.id,
    required this.experimentId,
    required this.note,
    required this.direction,
    required this.createdAt,
    this.source,
    this.recordedAt,
    this.hasConsent = true,
  });

  final String id;
  final String experimentId;
  final String note;
  final EvidenceDirection direction;
  final DateTime createdAt;
  final String? source;
  final DateTime? recordedAt;
  final bool hasConsent;
}

enum EvidenceDirection { supports, contradicts, neutral }
