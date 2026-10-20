const inspectionTemplateVersion = 'demo-20-v1';
const evidenceAngles = [
  'Ön genel',
  'Arka genel',
  'Sol genel',
  'Sağ genel',
  'Sol ön köşe',
  'Sağ ön köşe',
  'Sol arka köşe',
  'Sağ arka köşe',
  'Ön cam',
  'Arka cam',
  'Tavan',
  'Kaput',
  'Sol ön jant',
  'Sağ ön jant',
  'Sol arka jant',
  'Sağ arka jant',
  'Ön kabin',
  'Arka kabin',
  'Bagaj',
  'Gösterge paneli',
];

enum EvidenceStatus { missing, uploading, failed, received }

enum EvidenceReview { pending, accepted, retake }

class EvidenceSlot {
  const EvidenceSlot(
      {this.status = EvidenceStatus.missing,
      this.review = EvidenceReview.pending,
      this.receivedAt});
  final EvidenceStatus status;
  final EvidenceReview review;
  final DateTime? receivedAt;
  // An explicit placeholder, never a cryptographic integrity claim.
  String? get demoReceipt => receivedAt == null
      ? null
      : 'demo-receipt-${receivedAt!.microsecondsSinceEpoch}';
}
