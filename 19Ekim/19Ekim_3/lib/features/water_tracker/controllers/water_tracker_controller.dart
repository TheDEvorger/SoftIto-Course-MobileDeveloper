import 'package:flutter/foundation.dart';

class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final int dailyGoalWater = 2000; // 2 litre

  void addWater() {
    currentWater.value += 250;
  }

  void resetWater() {
    currentWater.value = 0;
  }

  void dispose() {
    currentWater.dispose();
  }
}
