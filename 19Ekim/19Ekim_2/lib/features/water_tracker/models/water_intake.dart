class WaterIntake {
  const WaterIntake({
    required this.amountMl,
    required this.recordedAt,
  });

  final int amountMl;
  final DateTime recordedAt;

  WaterIntake copyWith({int? amountMl, DateTime? recordedAt}) {
    return WaterIntake(
      amountMl: amountMl ?? this.amountMl,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    return WaterIntake(
      amountMl: (json['amountMl'] as num).toInt(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amountMl': amountMl,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }
}
