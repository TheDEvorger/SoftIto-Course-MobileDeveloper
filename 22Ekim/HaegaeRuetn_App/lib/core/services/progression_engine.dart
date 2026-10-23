import '../models/era.dart';
import '../models/habit.dart';

class ProgressionEngine {
  static int xpThreshold(int level) {
    final index = (level - 1).clamp(0, 23);
    return 45 * index * index + 30 * index;
  }

  static int levelForXp(int xp) {
    var level = 1;
    while (level < 24 && xp >= xpThreshold(level + 1)) {
      level++;
    }
    return level;
  }

  static int titleLevel(int xp, int reputation) {
    final earned = levelForXp(xp);
    if (reputation < 16) return (earned - 5).clamp(1, 24).toInt();
    if (reputation < 36) return (earned - 2).clamp(1, 24).toInt();
    return earned;
  }

  static int rewardFor(Habit habit) =>
      12 + habit.difficulty.clamp(1, 3).toInt() * 6;
  static String dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  static DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
  static int get eraCount => eras.length;
}
