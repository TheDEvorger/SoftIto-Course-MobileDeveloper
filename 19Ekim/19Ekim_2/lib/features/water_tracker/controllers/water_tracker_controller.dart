import 'package:flutter/foundation.dart';

import '../models/water_intake.dart';

class WaterTrackerController {
  WaterTrackerController({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  static const int dailyGoalMl = 2500;
  static const int defaultServingMl = 250;

  final DateTime Function() _clock;
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final ValueNotifier<List<WaterIntake>> intakes =
      ValueNotifier<List<WaterIntake>>([]);

  void addWater([int amountMl = defaultServingMl]) {
    if (amountMl <= 0) {
      throw ArgumentError.value(amountMl, 'amountMl', 'Must be positive.');
    }

    currentWater.value += amountMl;
    intakes.value = [
      WaterIntake(amountMl: amountMl, recordedAt: _clock()),
      ...intakes.value,
    ];
  }

  void resetDay() {
    currentWater.value = 0;
    intakes.value = [];
  }

  void dispose() {
    currentWater.dispose();
    intakes.dispose();
  }
}
