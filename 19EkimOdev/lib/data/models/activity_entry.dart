import 'package:flutter/foundation.dart';

import 'collection_status.dart';

/// "Son hareketler" listesinde gösterilen bir olay kaydı.
@immutable
class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.status,
    this.visitId,
  });

  final String id;
  final String message;
  final DateTime timestamp;

  /// Olayın ilişkili olduğu durum (ikon / renk seçimi için).
  final CollectionStatus status;
  final String? visitId;
}
