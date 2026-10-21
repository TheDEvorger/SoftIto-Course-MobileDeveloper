/// Denetim şablonu sürüm kodu
const inspectionTemplateVersion = 'demo-20-v1';

/// Araç tesliminde ve iadesinde fotoğraflanması gereken standart 20 çekim açısı
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

/// Kanıt slotu yükleme durumları
enum EvidenceStatus { missing, uploading, failed, received }

/// Kanıt insan inceleme durumu (beklemede, kabul edildi, yeniden çekim istendi)
enum EvidenceReview { pending, accepted, retake }

/// 20 açıdan birine ait kanıt kaydı slotu
class EvidenceSlot {
  const EvidenceSlot(
      {this.status = EvidenceStatus.missing,
      this.review = EvidenceReview.pending,
      this.receivedAt});

  /// Slotun yükleme durumu
  final EvidenceStatus status;

  /// Slotun inceleme onay durumu
  final EvidenceReview review;

  /// Sunucuya/sisteme ulaştığı an (temsili zaman)
  final DateTime? receivedAt;

  /// Temsili alındı makbuz numarası (kriptografik iddia içermez)
  String? get demoReceipt => receivedAt == null
      ? null
      : 'demo-receipt-${receivedAt!.microsecondsSinceEpoch}';
}
