import 'curriculum.dart';

/// MEB müfredatına dayalı doğrulanmış konu düğümü ve önkoşul modeli.
class TopicNodeInfo {
  const TopicNodeInfo({
    required this.topicId,
    required this.topicName,
    required this.subjectId,
    required this.subjectName,
    required this.stage,
    required this.prerequisiteIds,
    this.dependentIds = const [],
    this.status = TopicStatus.notStarted,
    this.answeredCount = 0,
    this.lastStudiedAt,
    this.isReady = true,
    this.needsReview = false,
    this.reviewMessage,
    this.x = 0.0,
    this.y = 0.0,
  });

  final String topicId;
  final String topicName;
  final String subjectId;
  final String subjectName;
  final String stage;
  final List<String> prerequisiteIds;
  final List<String> dependentIds;
  final TopicStatus status;
  final int answeredCount;
  final DateTime? lastStudiedAt;
  final bool isReady;
  final bool needsReview;
  final String? reviewMessage;

  /// Harita grafiğindeki koordinatlar
  final double x;
  final double y;

  TopicNodeInfo copyWith({
    String? topicId,
    String? topicName,
    String? subjectId,
    String? subjectName,
    String? stage,
    List<String>? prerequisiteIds,
    List<String>? dependentIds,
    TopicStatus? status,
    int? answeredCount,
    DateTime? lastStudiedAt,
    bool? isReady,
    bool? needsReview,
    String? reviewMessage,
    double? x,
    double? y,
  }) {
    return TopicNodeInfo(
      topicId: topicId ?? this.topicId,
      topicName: topicName ?? this.topicName,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      stage: stage ?? this.stage,
      prerequisiteIds: prerequisiteIds ?? this.prerequisiteIds,
      dependentIds: dependentIds ?? this.dependentIds,
      status: status ?? this.status,
      answeredCount: answeredCount ?? this.answeredCount,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
      isReady: isReady ?? this.isReady,
      needsReview: needsReview ?? this.needsReview,
      reviewMessage: reviewMessage ?? this.reviewMessage,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
