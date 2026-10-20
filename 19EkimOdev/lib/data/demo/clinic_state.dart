import 'package:flutter/foundation.dart';

import '../models/activity_entry.dart';
import '../models/collection_status.dart';
import '../models/collection_visit.dart';
import '../models/demo_patient.dart';
import '../models/demo_specimen.dart';

/// Uygulamadaki tüm demo verisinin TEK ve değişmez (immutable) anlık görüntüsü.
///
/// Store her değişiklikte yeni bir `ClinicState` üretir; böylece güncellemeler
/// atomiktir ve tüm ekranlar aynı tutarlı veriyi görür.
@immutable
class ClinicState {
  const ClinicState({
    required this.patients,
    required this.visits,
    required this.specimens,
    required this.activities,
    required this.nextQueueNumber,
    required this.nextSpecimenNumber,
    required this.nextPatientCodeNumber,
    required this.idSeed,
  });

  /// id -> hasta
  final Map<String, DemoPatient> patients;

  /// Sıra numarasına göre artan sırada ziyaretler.
  final List<CollectionVisit> visits;
  final List<DemoSpecimen> specimens;

  /// En yeni en başta olacak şekilde son hareketler.
  final List<ActivityEntry> activities;

  final int nextQueueNumber;
  final int nextSpecimenNumber;
  final int nextPatientCodeNumber;

  /// Benzersiz id üretimi için artan sayaç.
  final int idSeed;

  DemoPatient? patientOf(CollectionVisit visit) => patients[visit.patientId];

  CollectionVisit? visitById(String id) {
    for (final CollectionVisit v in visits) {
      if (v.id == id) return v;
    }
    return null;
  }

  DemoSpecimen? specimenForVisit(String visitId) {
    for (final DemoSpecimen s in specimens) {
      if (s.visitId == visitId) return s;
    }
    return null;
  }

  int countByStatus(CollectionStatus status) =>
      visits.where((CollectionVisit v) => v.status == status).length;

  /// Sırada bekleyen ilk hasta (en küçük sıra numarası).
  CollectionVisit? get nextWaiting {
    for (final CollectionVisit v in visits) {
      if (v.status == CollectionStatus.waiting) return v;
    }
    return null;
  }

  ClinicState copyWith({
    Map<String, DemoPatient>? patients,
    List<CollectionVisit>? visits,
    List<DemoSpecimen>? specimens,
    List<ActivityEntry>? activities,
    int? nextQueueNumber,
    int? nextSpecimenNumber,
    int? nextPatientCodeNumber,
    int? idSeed,
  }) {
    return ClinicState(
      patients: patients ?? this.patients,
      visits: visits ?? this.visits,
      specimens: specimens ?? this.specimens,
      activities: activities ?? this.activities,
      nextQueueNumber: nextQueueNumber ?? this.nextQueueNumber,
      nextSpecimenNumber: nextSpecimenNumber ?? this.nextSpecimenNumber,
      nextPatientCodeNumber:
          nextPatientCodeNumber ?? this.nextPatientCodeNumber,
      idSeed: idSeed ?? this.idSeed,
    );
  }
}
