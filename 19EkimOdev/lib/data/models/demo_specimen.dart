import 'package:flutter/material.dart';

/// Kurgusal numunenin durumu.
enum SpecimenStatus { awaitingDelivery, delivered, cancelled }

extension SpecimenStatusX on SpecimenStatus {
  String get label => switch (this) {
        SpecimenStatus.awaitingDelivery => 'Teslim Bekliyor',
        SpecimenStatus.delivered => 'Teslim Edildi',
        SpecimenStatus.cancelled => 'İptal',
      };

  IconData get icon => switch (this) {
        SpecimenStatus.awaitingDelivery => Icons.pending_actions_rounded,
        SpecimenStatus.delivered => Icons.task_alt_rounded,
        SpecimenStatus.cancelled => Icons.block_rounded,
      };
}

/// Kurgusal numune kaydı. Gerçek barkod / LIS bağlantısı yoktur.
@immutable
class DemoSpecimen {
  const DemoSpecimen({
    required this.id,
    required this.code,
    required this.visitId,
    required this.createdAt,
    required this.status,
    this.deliveredAt,
  });

  final String id;

  /// Kurgusal numune kodu (ör. `NM-1020-0007`).
  final String code;
  final String visitId;
  final DateTime createdAt;
  final SpecimenStatus status;
  final DateTime? deliveredAt;

  DemoSpecimen copyWith({SpecimenStatus? status, DateTime? deliveredAt}) {
    return DemoSpecimen(
      id: id,
      code: code,
      visitId: visitId,
      createdAt: createdAt,
      status: status ?? this.status,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }
}
