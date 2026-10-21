import '../domain/evidence_draft.dart';

/// Oturum süresince denetim taslaklarını bellekte saklayan depo sınıfı.
/// Gerçek fotoğraf dosyaları veya kalıcı veritabanı kullanmaz.
class DemoInspectionStore {
  // Rezervasyon kimliğine göre taslak anlık görüntüleri (snapshots)
  final Map<String, Map<String, Object?>> _snapshots = {};

  /// Rezervasyon kimliği için mevcut taslağı geri yükler veya yeni bir taslak açar.
  EvidenceDraft open(String bookingId) => _snapshots.containsKey(bookingId)
      ? EvidenceDraft.restore(_snapshots[bookingId]!,
          expectedBookingId: bookingId)
      : EvidenceDraft(bookingId);

  /// Taslağı anlık görüntü olarak belleğe kaydeder.
  void save(EvidenceDraft draft) =>
      _snapshots[draft.bookingId] = draft.toJson();
}
