import '../domain/evidence_draft.dart';

/// Session-only snapshots; deliberately no photos, files or durable persistence.
class DemoInspectionStore {
  final Map<String, Map<String, Object?>> _snapshots = {};
  EvidenceDraft open(String bookingId) => _snapshots.containsKey(bookingId)
      ? EvidenceDraft.restore(_snapshots[bookingId]!,
          expectedBookingId: bookingId)
      : EvidenceDraft(bookingId);
  void save(EvidenceDraft draft) =>
      _snapshots[draft.bookingId] = draft.toJson();
}
