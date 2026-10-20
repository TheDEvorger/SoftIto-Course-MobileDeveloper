import 'package:flutter/foundation.dart';

import '../../../data/demo/clinic_state.dart';
import '../../../data/models/collection_status.dart';
import '../../../data/models/collection_visit.dart';

/// Dashboard sayaçları. Tümü AYNI [ClinicState] verisinden hesaplanır;
/// sabit / elle yazılmış sayaç yoktur.
@immutable
class DashboardSummary {
  const DashboardSummary({
    required this.waiting,
    required this.called,
    required this.inProgress,
    required this.sampleCollected,
    required this.delivered,
    required this.cancelled,
    required this.activeVisits,
  });

  factory DashboardSummary.fromState(ClinicState state) {
    return DashboardSummary(
      waiting: state.countByStatus(CollectionStatus.waiting),
      called: state.countByStatus(CollectionStatus.called),
      inProgress: state.countByStatus(CollectionStatus.inProgress),
      sampleCollected: state.countByStatus(CollectionStatus.sampleCollected),
      delivered: state.countByStatus(CollectionStatus.delivered),
      cancelled: state.countByStatus(CollectionStatus.cancelled),
      activeVisits: state.visits
          .where((CollectionVisit v) =>
              v.status == CollectionStatus.called ||
              v.status == CollectionStatus.inProgress)
          .toList(growable: false),
    );
  }

  final int waiting;
  final int called;
  final int inProgress;
  final int sampleCollected;
  final int delivered;
  final int cancelled;

  /// Çağrılmış veya işlemdeki ziyaretler.
  final List<CollectionVisit> activeVisits;

  /// "İşlemde" kartı: çağrılan + kan alma sürenler.
  int get active => called + inProgress;

  int get total =>
      waiting + called + inProgress + sampleCollected + delivered + cancelled;

  /// İptaller hariç, teslim edilenlerin oranı (0..1).
  double get completionRate {
    final int base = total - cancelled;
    if (base <= 0) return 0;
    return delivered / base;
  }

  int countOf(CollectionStatus status) => switch (status) {
        CollectionStatus.waiting => waiting,
        CollectionStatus.called => called,
        CollectionStatus.inProgress => inProgress,
        CollectionStatus.sampleCollected => sampleCollected,
        CollectionStatus.delivered => delivered,
        CollectionStatus.cancelled => cancelled,
      };
}
