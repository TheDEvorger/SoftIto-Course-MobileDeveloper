import 'package:flutter/material.dart';

/// Bir kan alma işleminin (ziyaretin) durumu.
///
/// Ana akış:
/// `waiting -> called -> inProgress -> sampleCollected -> delivered`
///
/// `cancelled` ayrı bir terminal (son) durumdur.
enum CollectionStatus {
  waiting,
  called,
  inProgress,
  sampleCollected,
  delivered,
  cancelled,
}

/// Durum geçiş kuralları ve Türkçe görünür etiketler.
extension CollectionStatusX on CollectionStatus {
  /// Ana akıştaki adımlar (iptal hariç), sırasıyla.
  static const List<CollectionStatus> flow = <CollectionStatus>[
    CollectionStatus.waiting,
    CollectionStatus.called,
    CollectionStatus.inProgress,
    CollectionStatus.sampleCollected,
    CollectionStatus.delivered,
  ];

  String get label => switch (this) {
        CollectionStatus.waiting => 'Bekliyor',
        CollectionStatus.called => 'Çağrıldı',
        CollectionStatus.inProgress => 'İşlemde',
        CollectionStatus.sampleCollected => 'Numune Alındı',
        CollectionStatus.delivered => 'Teslim Edildi',
        CollectionStatus.cancelled => 'İptal',
      };

  IconData get icon => switch (this) {
        CollectionStatus.waiting => Icons.hourglass_top_rounded,
        CollectionStatus.called => Icons.campaign_rounded,
        CollectionStatus.inProgress => Icons.vaccines_rounded,
        CollectionStatus.sampleCollected => Icons.science_rounded,
        CollectionStatus.delivered => Icons.task_alt_rounded,
        CollectionStatus.cancelled => Icons.cancel_rounded,
      };

  /// Akıştaki bir sonraki durum. Terminal durumlarda `null`.
  CollectionStatus? get next => switch (this) {
        CollectionStatus.waiting => CollectionStatus.called,
        CollectionStatus.called => CollectionStatus.inProgress,
        CollectionStatus.inProgress => CollectionStatus.sampleCollected,
        CollectionStatus.sampleCollected => CollectionStatus.delivered,
        CollectionStatus.delivered => null,
        CollectionStatus.cancelled => null,
      };

  /// Bir sonraki adıma geçiren butonun Türkçe metni.
  String? get nextActionLabel => switch (this) {
        CollectionStatus.waiting => 'Çağır',
        CollectionStatus.called => 'İşleme Al',
        CollectionStatus.inProgress => 'Numune Alındı',
        CollectionStatus.sampleCollected => 'Teslim Et',
        CollectionStatus.delivered => null,
        CollectionStatus.cancelled => null,
      };

  IconData? get nextActionIcon => switch (this) {
        CollectionStatus.waiting => Icons.campaign_outlined,
        CollectionStatus.called => Icons.play_arrow_rounded,
        CollectionStatus.inProgress => Icons.science_outlined,
        CollectionStatus.sampleCollected => Icons.local_shipping_outlined,
        CollectionStatus.delivered => null,
        CollectionStatus.cancelled => null,
      };

  bool get isTerminal =>
      this == CollectionStatus.delivered || this == CollectionStatus.cancelled;

  /// Numune laboratuvara teslim edilmeden önce iptal edilebilir.
  bool get canCancel => !isTerminal;

  /// Kurallara uygun geçiş mi? Yalnızca bir sonraki adım veya iptal.
  bool canTransitionTo(CollectionStatus target) {
    if (target == CollectionStatus.cancelled) return canCancel;
    return next == target;
  }

  /// Akıştaki sıra (0..4). İptal için -1.
  int get flowIndex => flow.indexOf(this);
}
