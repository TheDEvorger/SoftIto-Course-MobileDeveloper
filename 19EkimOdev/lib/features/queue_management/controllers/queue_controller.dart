import 'package:flutter/foundation.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/demo/clinic_state.dart';
import '../../../data/models/collection_status.dart';
import '../../../data/models/collection_visit.dart';
import '../../../data/models/demo_patient.dart';

/// Sıra ekranındaki arama ve filtre durumunu yönetir.
///
/// AppShell tarafından oluşturulur; böylece Dashboard'daki bir sayaç kartına
/// tıklanınca sıra ekranı ilgili filtreyle açılabilir.
class QueueController {
  final ValueNotifier<String> query = ValueNotifier<String>('');

  /// `null` = Tümü
  final ValueNotifier<CollectionStatus?> filter =
      ValueNotifier<CollectionStatus?>(null);

  void search(String text) => query.value = text;

  void setFilter(CollectionStatus? status) => filter.value = status;

  void clear() {
    query.value = '';
    filter.value = null;
  }

  /// Arama + filtreyi uygular. Aktif kayıtlar önce, tamamlanan/iptal
  /// kayıtlar sonra; her grup kendi içinde sıra numarasına göre.
  static List<CollectionVisit> apply(
    ClinicState state, {
    String query = '',
    CollectionStatus? filter,
  }) {
    final String q = Formatters.searchKey(query);

    final List<CollectionVisit> result =
        state.visits.where((CollectionVisit v) {
      if (filter != null && v.status != filter) return false;
      if (q.isEmpty) return true;
      final DemoPatient? p = state.patientOf(v);
      final String haystack = Formatters.searchKey(<String>[
        Formatters.queueNumber(v.queueNumber),
        v.queueNumber.toString(),
        p?.displayName ?? '',
        p?.code ?? '',
        p?.department ?? '',
      ].join(' '));
      return haystack.contains(q);
    }).toList();

    result.sort((CollectionVisit a, CollectionVisit b) {
      final int groupA = a.status.isTerminal ? 1 : 0;
      final int groupB = b.status.isTerminal ? 1 : 0;
      if (groupA != groupB) return groupA.compareTo(groupB);
      return a.queueNumber.compareTo(b.queueNumber);
    });
    return result;
  }

  void dispose() {
    query.dispose();
    filter.dispose();
  }
}
