import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadim/features/water_tracker/models/water_intake.dart';

void main() {
  group('WaterTrackerController', () {
    late WaterTrackerController controller;

    setUp(() {
      controller = WaterTrackerController(
        clock: () => DateTime(2026, 10, 19, 12),
      );
    });

    tearDown(() => controller.dispose());

    test('adds a glass and records its time', () {
      controller.addWater();

      expect(controller.currentWater.value, 250);
      expect(controller.intakes.value, hasLength(1));
      expect(controller.intakes.value.single.amountMl, 250);
      expect(controller.intakes.value.single.recordedAt,
          DateTime(2026, 10, 19, 12));
    });

    test('supports custom amounts and resets daily data', () {
      controller.addWater(500);
      controller.resetDay();

      expect(controller.currentWater.value, 0);
      expect(controller.intakes.value, isEmpty);
    });

    test('rejects non-positive amounts', () {
      expect(() => controller.addWater(0), throwsArgumentError);
      expect(controller.currentWater.value, 0);
    });
  });

  test('WaterIntake round-trips JSON data', () {
    final intake = WaterIntake(
      amountMl: 250,
      recordedAt: DateTime(2026, 10, 19, 12),
    );

    expect(WaterIntake.fromJson(intake.toJson()).amountMl, 250);
    expect(WaterIntake.fromJson(intake.toJson()).recordedAt, intake.recordedAt);
  });
}
