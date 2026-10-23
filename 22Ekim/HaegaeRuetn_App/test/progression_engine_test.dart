import 'package:flutter_test/flutter_test.dart';
import 'package:haegaruuetn/core/models/era.dart';
import 'package:haegaruuetn/core/models/badge_definition.dart';
import 'package:haegaruuetn/core/services/progression_engine.dart';

void main() {
  test('six eras with four ranks produce exactly 24 levels', () {
    expect(eras, hasLength(6));
    expect(eras.expand((era) => era.ranks).length, 24);
    expect(badges, hasLength(24));
    expect(rankForLevel(23), 'Kral Naibi');
    expect(rankForLevel(24), 'Taç Giyen');
  });

  test('xp thresholds increase monotonically', () {
    for (var level = 2; level <= 24; level++) {
      expect(ProgressionEngine.xpThreshold(level),
          greaterThan(ProgressionEngine.xpThreshold(level - 1)));
    }
    expect(ProgressionEngine.levelForXp(0), 1);
    expect(ProgressionEngine.levelForXp(ProgressionEngine.xpThreshold(24)), 24);
  });

  test(
      'low reputation temporarily lowers rank but does not change earned xp level',
      () {
    final xp = ProgressionEngine.xpThreshold(14);
    expect(ProgressionEngine.levelForXp(xp), 14);
    expect(ProgressionEngine.titleLevel(xp, 10), 9);
    expect(ProgressionEngine.titleLevel(xp, 75), 14);
  });
}
