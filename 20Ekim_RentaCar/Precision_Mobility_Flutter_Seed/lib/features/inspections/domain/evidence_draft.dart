import 'evidence_template.dart';

/// 20 açılı araç inceleme taslağı modeli.
/// Slot durumlarını, kabul edilen fotoğraf sayısını ve JSON serileştirme/geri yükleme işlemlerini yönetir.
class EvidenceDraft {
  EvidenceDraft(this.bookingId) {
    if (bookingId.isEmpty) {
      throw ArgumentError('Örnek rezervasyon kimliği gerekli.');
    }
  }

  /// Bağlı olduğu rezervasyonun kimliği
  final String bookingId;

  // 20 çekim açısına karşılık gelen slot listesi
  final List<EvidenceSlot> _slots =
      List.generate(20, (_) => const EvidenceSlot());

  /// Slotların dışarıdan salt-okunur listesi
  List<EvidenceSlot> get slots => List.unmodifiable(_slots);

  /// Kabul edilmiş slotların toplam adedi
  int get acceptedCount => _slots
      .where((s) =>
          s.status == EvidenceStatus.received &&
          s.review == EvidenceReview.accepted)
      .length;

  /// Tüm 20 açının başarıyla incelenip kabul edilip edilmediği
  bool get isComplete => acceptedCount == evidenceAngles.length;

  /// Belirtilen açı için yükleme işlemini başlatır.
  void startUpload(int index) {
    _validate(index);
    if (_slots[index].status == EvidenceStatus.uploading) {
      throw StateError('Bu örnek yükleme zaten sürüyor.');
    }
    _slots[index] = const EvidenceSlot(status: EvidenceStatus.uploading);
  }

  /// Kanıtın sunucuya ulaştığını ve alındı zaman damgasını kaydeder.
  void receive(int index, DateTime now) {
    _validate(index);
    if (_slots[index].status != EvidenceStatus.uploading) {
      throw StateError('Başlatılmış örnek yükleme gerekli.');
    }
    _slots[index] =
        EvidenceSlot(status: EvidenceStatus.received, receivedAt: now);
  }

  /// Yükleme başarısızlığını simüle eder.
  void fail(int index) {
    _validate(index);
    if (_slots[index].status != EvidenceStatus.uploading) {
      throw StateError('Başlatılmış örnek yükleme gerekli.');
    }
    _slots[index] = const EvidenceSlot(status: EvidenceStatus.failed);
  }

  /// Alınan kanıtı insan denetimiyle kabul eder veya yeniden çekim ister.
  void review(int index, {required bool accepted}) {
    _validate(index);
    final slot = _slots[index];
    if (slot.status != EvidenceStatus.received ||
        (accepted && slot.review == EvidenceReview.retake)) {
      throw StateError('Örnek alındı kaydı olmadan inceleme yapılamaz.');
    }
    _slots[index] = EvidenceSlot(
        status: slot.status,
        receivedAt: slot.receivedAt,
        review: accepted ? EvidenceReview.accepted : EvidenceReview.retake);
  }

  void _validate(int index) {
    if (index < 0 || index >= _slots.length) {
      throw RangeError.index(index, _slots);
    }
  }

  Map<String, Object?> toJson() => {
        'version': inspectionTemplateVersion,
        'bookingId': bookingId,
        'slots': [
          for (final slot in _slots)
            {
              'status': slot.status.name,
              'review': slot.review.name,
              'receivedAt': slot.receivedAt?.toIso8601String(),
            }
        ],
      };

  factory EvidenceDraft.restore(Map<String, Object?> json,
      {required String expectedBookingId}) {
    if (json['version'] != inspectionTemplateVersion ||
        json['bookingId'] != expectedBookingId ||
        json['slots'] is! List ||
        (json['slots'] as List).length != evidenceAngles.length) {
      throw const FormatException('Uyumsuz örnek inceleme taslağı.');
    }
    final draft = EvidenceDraft(expectedBookingId);
    try {
      final slots = json['slots'] as List;
      for (var i = 0; i < slots.length; i++) {
        final raw = slots[i] as Map;
        var status = EvidenceStatus.values.byName(raw['status'] as String);
        final review = EvidenceReview.values.byName(raw['review'] as String);
        final time = raw['receivedAt'] == null
            ? null
            : DateTime.parse(raw['receivedAt'] as String);
        if (status == EvidenceStatus.uploading) status = EvidenceStatus.failed;
        if ((status == EvidenceStatus.received) != (time != null) ||
            (status != EvidenceStatus.received &&
                review != EvidenceReview.pending)) {
          throw const FormatException('Geçersiz örnek kayıt durumu.');
        }
        draft._slots[i] =
            EvidenceSlot(status: status, review: review, receivedAt: time);
      }
    } catch (_) {
      throw const FormatException('Bozuk örnek inceleme kaydı.');
    }
    return draft;
  }
}
