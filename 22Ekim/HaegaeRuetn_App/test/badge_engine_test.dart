import 'package:flutter_test/flutter_test.dart';
import 'package:haegaruuetn/core/models/habit.dart';
import 'package:haegaruuetn/core/models/pact.dart';
import 'package:haegaruuetn/core/services/badge_engine.dart';

void main() {
  final start = DateTime(2026, 10, 1);
  test('pact counts only days after creation with all its habits completed',
      () {
    final a = Habit(
        id: 'a',
        name: 'Read',
        description: '',
        difficulty: 1,
        createdAt: start,
        completedDates: [
          '2026-09-30',
          '2026-10-01',
          '2026-10-02',
          '2026-10-03'
        ]);
    final b = Habit(
        id: 'b',
        name: 'Study',
        description: '',
        difficulty: 1,
        createdAt: start,
        completedDates: ['2026-10-01', '2026-10-03']);
    final pact = Pact(
        id: 'p',
        title: 'Learning',
        habitIds: ['a', 'b'],
        goalDays: 3,
        startedAt: start);
    expect(BadgeEngine.pactProgress(pact, [a, b]), 2);
  });
  test('badge definitions unlock for genuinely recorded completions', () {
    final a = Habit(
        id: 'a',
        name: 'Read',
        description: '',
        difficulty: 3,
        createdAt: start,
        completedDates: [
          '2026-10-01',
          '2026-10-02',
          '2026-10-03',
          '2026-10-04',
          '2026-10-05'
        ]);
    final unlocked = BadgeEngine.earned([a], [], 0);
    expect(unlocked, containsAll([1, 3, 11]));
    expect(unlocked, isNot(contains(21))); // remote community is never faked
  });
}
