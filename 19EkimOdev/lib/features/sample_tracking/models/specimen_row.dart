import 'package:flutter/foundation.dart';

import '../../../data/models/collection_visit.dart';
import '../../../data/models/demo_patient.dart';
import '../../../data/models/demo_specimen.dart';

/// Numune listesinde bir satır: numune + ilişkili işlem + hasta.
///
/// Ekranın ihtiyaç duyduğu birleşik görünüm modelidir; ortak modelleri
/// kopyalamaz, yalnızca referans tutar.
@immutable
class SpecimenRow {
  const SpecimenRow({
    required this.specimen,
    required this.visit,
    required this.patient,
  });

  final DemoSpecimen specimen;
  final CollectionVisit? visit;
  final DemoPatient? patient;
}
