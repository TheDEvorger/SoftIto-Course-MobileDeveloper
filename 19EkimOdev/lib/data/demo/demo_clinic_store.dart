import 'package:flutter/foundation.dart';

import '../../core/utils/formatters.dart';
import '../models/activity_entry.dart';
import '../models/collection_status.dart';
import '../models/collection_visit.dart';
import '../models/demo_patient.dart';
import '../models/demo_specimen.dart';
import 'clinic_state.dart';
import 'demo_seed.dart';

/// Uygulama kapsamındaki TEK kurgusal veri kaynağı.
///
/// - Veriler yalnızca bellekte tutulur; uygulama kapanınca sıfırlanır.
/// - Tüm değişiklikler buradan geçer ve kurallar (durum geçişleri, benzersiz
///   sıra numarası) burada doğrulanır. View'lar listeyi doğrudan değiştirmez.
/// - Her işlem yeni bir [ClinicState] üretir; `ValueListenableBuilder` ile
///   dinleyen tüm ekranlar aynı anda güncellenir.
class DemoClinicStore {
  DemoClinicStore({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now,
        state = ValueNotifier<ClinicState>(
            buildDemoSeed((clock ?? DateTime.now)()));

  final DateTime Function() _clock;

  /// Ekranların dinlediği tek veri kaynağı.
  final ValueNotifier<ClinicState> state;

  /// Son durum değişikliği geri alınabilir mi?
  final ValueNotifier<bool> canUndo = ValueNotifier<bool>(false);

  ClinicState? _undoSnapshot;

  static const int _maxActivities = 40;

  ClinicState get current => state.value;

  // ---------------------------------------------------------------------------
  // Hasta kabul
  // ---------------------------------------------------------------------------

  /// Formda önerilecek, kullanılmayan demo hasta kodu.
  String suggestPatientCode() {
    int n = current.nextPatientCodeNumber;
    while (isPatientCodeTaken('DEMO-$n')) {
      n++;
    }
    return 'DEMO-$n';
  }

  bool isPatientCodeTaken(String code) {
    final String normalized = code.trim().toUpperCase();
    return current.patients.values
        .any((DemoPatient p) => p.code.toUpperCase() == normalized);
  }

  /// Yeni kurgusal hastayı kaydeder ve benzersiz sıra numarası ile sıraya ekler.
  ///
  /// Geçersiz girdide [ArgumentError] fırlatır.
  CollectionVisit registerPatient({
    required String displayName,
    required String code,
    required String department,
    DateTime? appointmentAt,
    String? note,
  }) {
    final String name = displayName.trim();
    final String normalizedCode = code.trim().toUpperCase();
    if (name.isEmpty) throw ArgumentError('Hasta adı boş olamaz.');
    if (normalizedCode.isEmpty) throw ArgumentError('Hasta kodu boş olamaz.');
    if (department.trim().isEmpty) throw ArgumentError('Birim seçilmelidir.');
    if (isPatientCodeTaken(normalizedCode)) {
      throw ArgumentError('Bu demo hasta kodu zaten kayıtlı.');
    }

    final ClinicState s = current;
    final DateTime now = _clock();
    final int seed = s.idSeed + 1;
    final String patientId = 'p$seed';
    final String visitId = 'v$seed';
    final int queueNumber = s.nextQueueNumber;
    final String trimmedNote = note?.trim() ?? '';

    final DemoPatient patient = DemoPatient(
      id: patientId,
      displayName: name,
      code: normalizedCode,
      department: department,
    );
    final CollectionVisit visit = CollectionVisit(
      id: visitId,
      patientId: patientId,
      queueNumber: queueNumber,
      createdAt: now,
      status: CollectionStatus.waiting,
      statusHistory: Map<CollectionStatus, DateTime>.unmodifiable(
          <CollectionStatus, DateTime>{CollectionStatus.waiting: now}),
      appointmentAt: appointmentAt,
      note: trimmedNote.isEmpty ? null : trimmedNote,
    );

    final ActivityEntry activity = ActivityEntry(
      id: 'a$seed',
      message: describeActivity(CollectionStatus.waiting, _label(visit, patient)),
      timestamp: now,
      status: CollectionStatus.waiting,
      visitId: visitId,
    );

    // Yeni kayıt sonrası eski "geri al" anlık görüntüsü geçersiz olur.
    _clearUndo();

    state.value = s.copyWith(
      patients: Map<String, DemoPatient>.unmodifiable(
          <String, DemoPatient>{...s.patients, patientId: patient}),
      visits: List<CollectionVisit>.unmodifiable(
          <CollectionVisit>[...s.visits, visit]),
      activities: _prependActivity(s.activities, activity),
      nextQueueNumber: queueNumber + 1,
      nextPatientCodeNumber: s.nextPatientCodeNumber + 1,
      idSeed: seed,
    );
    return visit;
  }

  // ---------------------------------------------------------------------------
  // Durum geçişleri
  // ---------------------------------------------------------------------------

  /// Kurallara uygunsa durumu değiştirir ve `true` döner.
  /// Geçersiz geçişler (ör. adım atlama) reddedilir ve `false` döner.
  bool changeStatus(String visitId, CollectionStatus target) {
    final ClinicState s = current;
    final CollectionVisit? visit = s.visitById(visitId);
    if (visit == null || !visit.status.canTransitionTo(target)) return false;

    final DateTime now = _clock();
    final DemoPatient? patient = s.patientOf(visit);
    final CollectionVisit updated = visit.withStatus(target, now);
    int seed = s.idSeed;
    int nextSpecimen = s.nextSpecimenNumber;
    List<DemoSpecimen> specimens = s.specimens;

    switch (target) {
      case CollectionStatus.sampleCollected:
        seed++;
        specimens = <DemoSpecimen>[
          ...specimens,
          DemoSpecimen(
            id: 's$seed',
            code: buildSpecimenCode(now, nextSpecimen),
            visitId: visitId,
            createdAt: now,
            status: SpecimenStatus.awaitingDelivery,
          ),
        ];
        nextSpecimen++;
      case CollectionStatus.delivered:
        specimens = _updateSpecimen(
          specimens,
          visitId,
          (DemoSpecimen sp) =>
              sp.copyWith(status: SpecimenStatus.delivered, deliveredAt: now),
        );
      case CollectionStatus.cancelled:
        specimens = _updateSpecimen(
          specimens,
          visitId,
          (DemoSpecimen sp) => sp.copyWith(status: SpecimenStatus.cancelled),
        );
      case CollectionStatus.waiting:
      case CollectionStatus.called:
      case CollectionStatus.inProgress:
        break;
    }

    seed++;
    final ActivityEntry activity = ActivityEntry(
      id: 'a$seed',
      message: describeActivity(target, _label(visit, patient)),
      timestamp: now,
      status: target,
      visitId: visitId,
    );

    _undoSnapshot = s;
    canUndo.value = true;

    state.value = s.copyWith(
      visits: List<CollectionVisit>.unmodifiable(
        s.visits.map((CollectionVisit v) => v.id == visitId ? updated : v),
      ),
      specimens: List<DemoSpecimen>.unmodifiable(specimens),
      activities: _prependActivity(s.activities, activity),
      nextSpecimenNumber: nextSpecimen,
      idSeed: seed,
    );
    return true;
  }

  /// Ziyareti akıştaki bir sonraki adıma taşır.
  bool advance(String visitId) {
    final CollectionStatus? next = current.visitById(visitId)?.status.next;
    if (next == null) return false;
    return changeStatus(visitId, next);
  }

  bool cancel(String visitId) =>
      changeStatus(visitId, CollectionStatus.cancelled);

  /// Sıradaki (en küçük numaralı bekleyen) hastayı çağırır.
  /// Bekleyen yoksa `null` döner.
  CollectionVisit? callNext() {
    final CollectionVisit? next = current.nextWaiting;
    if (next == null) return null;
    changeStatus(next.id, CollectionStatus.called);
    return current.visitById(next.id);
  }

  /// Son durum değişikliğini geri alır.
  bool undo() {
    final ClinicState? snapshot = _undoSnapshot;
    if (snapshot == null) return false;
    _clearUndo();
    state.value = snapshot;
    return true;
  }

  /// Demoyu ilk kurgusal duruma döndürür.
  void reset() {
    _clearUndo();
    state.value = buildDemoSeed(_clock());
  }

  void dispose() {
    state.dispose();
    canUndo.dispose();
  }

  // ---------------------------------------------------------------------------
  // Yardımcılar
  // ---------------------------------------------------------------------------

  void _clearUndo() {
    _undoSnapshot = null;
    canUndo.value = false;
  }

  String _label(CollectionVisit visit, DemoPatient? patient) {
    final String number = Formatters.queueNumber(visit.queueNumber);
    if (patient == null) return number;
    return '$number · ${Formatters.shortName(patient.displayName)}';
  }

  List<ActivityEntry> _prependActivity(
      List<ActivityEntry> list, ActivityEntry entry) {
    return List<ActivityEntry>.unmodifiable(
      <ActivityEntry>[entry, ...list].take(_maxActivities),
    );
  }

  List<DemoSpecimen> _updateSpecimen(
    List<DemoSpecimen> list,
    String visitId,
    DemoSpecimen Function(DemoSpecimen) update,
  ) {
    return list
        .map((DemoSpecimen sp) => sp.visitId == visitId ? update(sp) : sp)
        .toList();
  }
}
