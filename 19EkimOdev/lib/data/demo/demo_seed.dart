import '../../core/utils/formatters.dart';
import '../models/activity_entry.dart';
import '../models/collection_status.dart';
import '../models/collection_visit.dart';
import '../models/demo_patient.dart';
import '../models/demo_specimen.dart';
import 'clinic_state.dart';

/// Hasta kabul formunda seçilebilen hizmet / birimler.
const List<String> demoDepartments = <String>[
  'Dahiliye',
  'Kardiyoloji',
  'Endokrinoloji',
  'Nefroloji',
  'Hematoloji',
  'Genel Check-up',
];

/// Numune kodu üretimi: `NM-1020-0007`
String buildSpecimenCode(DateTime date, int number) {
  final String mm = date.month.toString().padLeft(2, '0');
  final String dd = date.day.toString().padLeft(2, '0');
  return 'NM-$mm$dd-${number.toString().padLeft(4, '0')}';
}

class _SeedRow {
  const _SeedRow(this.name, this.department, this.status, this.minutesAgo);
  final String name;
  final String department;
  final CollectionStatus status;
  final int minutesAgo;
}

/// TAMAMEN KURGUSAL başlangıç verisi. Gerçek kişilerle ilgisi yoktur.
const List<_SeedRow> _rows = <_SeedRow>[
  _SeedRow('Ada Kaya', 'Dahiliye', CollectionStatus.delivered, 95),
  _SeedRow('Deniz Çelik', 'Genel Check-up', CollectionStatus.delivered, 82),
  _SeedRow('Mert Aydın', 'Kardiyoloji', CollectionStatus.sampleCollected, 64),
  _SeedRow('Burak Yıldız', 'Kardiyoloji', CollectionStatus.cancelled, 55),
  _SeedRow('Elif Demir', 'Endokrinoloji', CollectionStatus.inProgress, 41),
  _SeedRow('Can Öztürk', 'Genel Check-up', CollectionStatus.called, 30),
  _SeedRow('Zeynep Arslan', 'Dahiliye', CollectionStatus.waiting, 22),
  _SeedRow('Emre Şahin', 'Nefroloji', CollectionStatus.waiting, 14),
  _SeedRow('Selin Koç', 'Hematoloji', CollectionStatus.waiting, 6),
];

/// Verilen "şimdi" zamanına göre tutarlı demo verisi üretir.
ClinicState buildDemoSeed(DateTime now) {
  final Map<String, DemoPatient> patients = <String, DemoPatient>{};
  final List<CollectionVisit> visits = <CollectionVisit>[];
  final List<DemoSpecimen> specimens = <DemoSpecimen>[];
  final List<ActivityEntry> activities = <ActivityEntry>[];
  int specimenNumber = 1;
  int activityId = 0;

  for (int i = 0; i < _rows.length; i++) {
    final _SeedRow row = _rows[i];
    final int queueNumber = i + 1;
    final String patientId = 'p$queueNumber';
    final String visitId = 'v$queueNumber';
    final DateTime createdAt = now.subtract(Duration(minutes: row.minutesAgo));

    patients[patientId] = DemoPatient(
      id: patientId,
      displayName: row.name,
      code: 'DEMO-${1000 + queueNumber}',
      department: row.department,
    );

    // Duruma kadar olan adımları 4'er dakika arayla geçmişe yaz.
    final Map<CollectionStatus, DateTime> history =
        <CollectionStatus, DateTime>{CollectionStatus.waiting: createdAt};
    if (row.status == CollectionStatus.cancelled) {
      history[CollectionStatus.cancelled] =
          createdAt.add(const Duration(minutes: 5));
    } else {
      for (int step = 1; step <= row.status.flowIndex; step++) {
        history[CollectionStatusX.flow[step]] =
            createdAt.add(Duration(minutes: step * 4));
      }
    }

    visits.add(CollectionVisit(
      id: visitId,
      patientId: patientId,
      queueNumber: queueNumber,
      createdAt: createdAt,
      status: row.status,
      statusHistory: Map<CollectionStatus, DateTime>.unmodifiable(history),
    ));

    final DateTime? collectedAt = history[CollectionStatus.sampleCollected];
    if (collectedAt != null) {
      final bool delivered = row.status == CollectionStatus.delivered;
      specimens.add(DemoSpecimen(
        id: 's$specimenNumber',
        code: buildSpecimenCode(now, specimenNumber),
        visitId: visitId,
        createdAt: collectedAt,
        status: delivered
            ? SpecimenStatus.delivered
            : SpecimenStatus.awaitingDelivery,
        deliveredAt: history[CollectionStatus.delivered],
      ));
      specimenNumber++;
    }

    final String label =
        '${Formatters.queueNumber(queueNumber)} · ${Formatters.shortName(row.name)}';
    history.forEach((CollectionStatus status, DateTime at) {
      activities.add(ActivityEntry(
        id: 'a${activityId++}',
        message: describeActivity(status, label),
        timestamp: at,
        status: status,
        visitId: visitId,
      ));
    });
  }

  activities.sort(
      (ActivityEntry a, ActivityEntry b) => b.timestamp.compareTo(a.timestamp));

  return ClinicState(
    patients: Map<String, DemoPatient>.unmodifiable(patients),
    visits: List<CollectionVisit>.unmodifiable(visits),
    specimens: List<DemoSpecimen>.unmodifiable(specimens),
    activities: List<ActivityEntry>.unmodifiable(activities),
    nextQueueNumber: _rows.length + 1,
    nextSpecimenNumber: specimenNumber,
    nextPatientCodeNumber: 1000 + _rows.length + 1,
    idSeed: 1000,
  );
}

/// Bir durum değişikliği için Türkçe hareket metni.
String describeActivity(CollectionStatus status, String label) {
  return switch (status) {
    CollectionStatus.waiting => '$label sıraya eklendi',
    CollectionStatus.called => '$label çağrıldı',
    CollectionStatus.inProgress => '$label için kan alma işlemi başladı',
    CollectionStatus.sampleCollected => '$label numunesi alındı',
    CollectionStatus.delivered => '$label numunesi laboratuvara teslim edildi',
    CollectionStatus.cancelled => '$label işlemi iptal edildi',
  };
}
