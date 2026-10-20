import 'package:flutter/foundation.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/demo/clinic_state.dart';
import '../../../data/models/collection_visit.dart';
import '../../../data/models/demo_patient.dart';
import '../../../data/models/demo_specimen.dart';
import '../models/specimen_row.dart';

/// Numune ekranının arama ve filtre durumu.
class SampleTrackingController {
  final ValueNotifier<String> query = ValueNotifier<String>('');

  /// `null` = Tümü
  final ValueNotifier<SpecimenStatus?> filter =
      ValueNotifier<SpecimenStatus?>(null);

  void search(String text) => query.value = text;

  void setFilter(SpecimenStatus? status) => filter.value = status;

  /// Numuneleri filtreler; en yeni numune en üstte.
  static List<SpecimenRow> apply(
    ClinicState state, {
    String query = '',
    SpecimenStatus? filter,
  }) {
    final String q = Formatters.searchKey(query);
    final List<SpecimenRow> rows = <SpecimenRow>[];

    for (final DemoSpecimen s in state.specimens) {
      if (filter != null && s.status != filter) continue;
      final CollectionVisit? visit = state.visitById(s.visitId);
      final DemoPatient? patient = visit == null ? null : state.patientOf(visit);

      if (q.isNotEmpty) {
        final String haystack = Formatters.searchKey(<String>[
          s.code,
          if (visit != null) Formatters.queueNumber(visit.queueNumber),
          patient?.displayName ?? '',
          patient?.code ?? '',
        ].join(' '));
        if (!haystack.contains(q)) continue;
      }
      rows.add(SpecimenRow(specimen: s, visit: visit, patient: patient));
    }

    rows.sort((SpecimenRow a, SpecimenRow b) =>
        b.specimen.createdAt.compareTo(a.specimen.createdAt));
    return rows;
  }

  static int countByStatus(ClinicState state, SpecimenStatus status) =>
      state.specimens.where((DemoSpecimen s) => s.status == status).length;

  void dispose() {
    query.dispose();
    filter.dispose();
  }
}
