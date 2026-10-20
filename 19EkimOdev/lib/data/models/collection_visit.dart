import 'package:flutter/foundation.dart';

import 'collection_status.dart';

/// Bir hastanın kan alma birimine yaptığı günlük ziyaret / işlem kaydı.
@immutable
class CollectionVisit {
  const CollectionVisit({
    required this.id,
    required this.patientId,
    required this.queueNumber,
    required this.createdAt,
    required this.status,
    required this.statusHistory,
    this.appointmentAt,
    this.note,
  });

  final String id;
  final String patientId;

  /// Gün içinde tekrar etmeyen sıra numarası.
  final int queueNumber;
  final DateTime createdAt;
  final CollectionStatus status;

  /// Hangi duruma hangi saatte geçildiği (zaman çizelgesi için).
  final Map<CollectionStatus, DateTime> statusHistory;

  /// Opsiyonel randevu saati.
  final DateTime? appointmentAt;

  /// Opsiyonel, klinik olmayan kısa not.
  final String? note;

  /// Yeni durumla birlikte geçmişe zaman damgası ekleyerek kopya üretir.
  CollectionVisit withStatus(CollectionStatus newStatus, DateTime at) {
    return copyWith(
      status: newStatus,
      statusHistory: Map<CollectionStatus, DateTime>.unmodifiable(
        <CollectionStatus, DateTime>{...statusHistory, newStatus: at},
      ),
    );
  }

  CollectionVisit copyWith({
    CollectionStatus? status,
    Map<CollectionStatus, DateTime>? statusHistory,
    String? note,
  }) {
    return CollectionVisit(
      id: id,
      patientId: patientId,
      queueNumber: queueNumber,
      createdAt: createdAt,
      status: status ?? this.status,
      statusHistory: statusHistory ?? this.statusHistory,
      appointmentAt: appointmentAt,
      note: note ?? this.note,
    );
  }
}
