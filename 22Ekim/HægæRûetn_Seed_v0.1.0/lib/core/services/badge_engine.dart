import '../models/habit.dart';
import '../models/pact.dart';
import '../services/progression_engine.dart';

class BadgeEngine {
  static Set<int> earned(List<Habit> habits, List<Pact> pacts, int comebackCount) {
    final allDates = <String>{};
    var done = 0;
    var hard = 0;
    for (final habit in habits) {
      done += habit.completedDates.length;
      allDates.addAll(habit.completedDates);
      if (habit.difficulty == 3) hard += habit.completedDates.length;
    }
    final pactDone = pacts.where((p) => p.isCompleted).length;
    final earned = <int>{};
    if (done >= 1) earned.add(1);
    if (pacts.isNotEmpty) earned.add(2);
    if (done >= 5) earned.add(3);
    if (comebackCount >= 1) earned.add(4);
    if (allDates.length >= 7) earned.add(5);
    if (pactDone >= 1) earned.add(6);
    if (done >= 10) earned.add(7);
    final triple = allDates.any((date) => habits.where((h) => h.completedOn(date)).length >= 3);
    if (triple) earned.add(10);
    if (hard >= 5) earned.add(11);
    if (done >= 100) earned.add(12);
    if (comebackCount >= 3) earned.add(14);
    if (pactDone >= 5) earned.add(19);
    return earned;
  }

  static int pactProgress(Pact pact, List<Habit> habits) {
    if (pact.habitIds.isEmpty) return 0;
    final byId = {for (final habit in habits) habit.id: habit};
    final selected = pact.habitIds.map((id) => byId[id]).toList();
    if (selected.any((habit) => habit == null)) return 0;
    final first = selected.first!;
    final from = ProgressionEngine.day(pact.startedAt);
    var count = 0;
    for (final date in first.completedDates.toSet()) {
      final parsed = DateTime.tryParse(date);
      if (parsed == null || parsed.isBefore(from)) continue;
      if (selected.every((habit) => habit!.completedOn(date))) count++;
    }
    return count.clamp(0, pact.goalDays).toInt();
  }
}
