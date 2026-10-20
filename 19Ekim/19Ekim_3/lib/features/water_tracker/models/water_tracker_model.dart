import 'package:flutter/foundation.dart';

@immutable
class WaterTrackerModel {
  const WaterTrackerModel({
    this.currentWater = 0,
    this.dailyGoal = 2000,
  });

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      currentWater: json['currentWater'] as int? ?? 0,
      dailyGoal: json['dailyGoal'] as int? ?? 2000,
    );
  }

  final int currentWater;
  final int dailyGoal;

  WaterTrackerModel copyWith({
    int? currentWater,
    int? dailyGoal,
  }) {
    return WaterTrackerModel(
      currentWater: currentWater ?? this.currentWater,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'currentWater': currentWater,
        'dailyGoal': dailyGoal,
      };

  @override
  bool operator ==(Object other) =>
      other is WaterTrackerModel &&
      other.currentWater == currentWater &&
      other.dailyGoal == dailyGoal;

  @override
  int get hashCode => Object.hash(currentWater, dailyGoal);
}
