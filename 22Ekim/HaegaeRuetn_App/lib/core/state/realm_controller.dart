import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../data/local_realm_store.dart';
import '../models/badge_definition.dart';
import '../models/era.dart';
import '../models/habit.dart';
import '../models/pact.dart';
import '../services/badge_engine.dart';
import '../services/progression_engine.dart';

class RealmController extends ChangeNotifier {
  RealmController(this._store, {DateTime Function()? clock})
      : _now = clock ?? DateTime.now;
  final RealmStore _store;
  final DateTime Function() _now;
  List<Habit> habits = [];
  List<Pact> pacts = [];
  int xp = 0;
  int reputation = 70;
  int comebackCount = 0;
  String? lastCheckedDate;
  final Set<String> restDates = {};
  String herald =
      'Hoş geldin yolcu! Küçük bir vazife, büyük bir destanın ilk satırıdır.';
  String? celebration;
  int eventNumber = 0;
  Future<void> _writeQueue = Future<void>.value();
  int _idSequence = 0;
  bool _loadFailed = false;
  bool get readOnlyRecoveryMode => _loadFailed;

  String get today => ProgressionEngine.dayKey(_now());
  int get earnedLevel => ProgressionEngine.levelForXp(xp);
  int get level => ProgressionEngine.titleLevel(xp, reputation);
  Era get era => eraForLevel(level);
  String get rank => rankForLevel(level);
  int get todayCompleted =>
      activeHabits.where((h) => h.completedOn(today)).length;
  List<Habit> get activeHabits =>
      habits.where((h) => !h.archived).toList(growable: false);
  int get totalCompletions =>
      habits.fold(0, (sum, h) => sum + h.completedDates.length);
  Set<int> get badgeIds => BadgeEngine.earned(habits, pacts, comebackCount);
  int get badgeCount => badgeIds.length;
  List<BadgeDefinition> get unlockedBadges =>
      badges.where((b) => badgeIds.contains(b.id)).toList();
  int pactProgress(Pact pact) => BadgeEngine.pactProgress(pact, habits);
  int get todayPercent =>
      activeHabits.isEmpty ? 0 : (todayCompleted * 100 ~/ activeHabits.length);

  Future<void> initialize() async {
    try {
      final raw = await _store.read();
      if (raw != null) {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        habits = (data['habits'] as List<dynamic>? ?? [])
            .map((item) =>
                Habit.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        pacts = (data['pacts'] as List<dynamic>? ?? [])
            .map(
                (item) => Pact.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        xp = (data['xp'] as num?)?.toInt() ?? 0;
        reputation = (data['reputation'] as num?)?.toInt() ?? 70;
        comebackCount = (data['comebackCount'] as num?)?.toInt() ?? 0;
        lastCheckedDate = data['lastCheckedDate'] as String?;
        restDates
            .addAll((data['restDates'] as List<dynamic>? ?? []).cast<String>());
        _idSequence = (data['idSequence'] as num?)?.toInt() ?? 0;
      } else {
        // The first launch contains editable examples, not fabricated progress.
        final now = _now();
        habits = [
          Habit(
              id: _id(),
              name: '20 dakika kitap oku',
              description: 'Bilgi seferi',
              difficulty: 1,
              createdAt: now,
              completedDates: []),
          Habit(
              id: _id(),
              name: '15 dakika dil çalış',
              description: 'Yeni kelimelerin izinde',
              difficulty: 2,
              createdAt: now,
              completedDates: []),
          Habit(
              id: _id(),
              name: 'Kısa bir yürüyüş yap',
              description: 'Yolcunun adımları',
              difficulty: 1,
              createdAt: now,
              completedDates: []),
        ];
      }
      _applyElapsedDays();
      _persist();
    } catch (_) {
      _loadFailed = true;
      // Corrupt persistence must never silently overwrite a user's backup.
      herald =
          'Yerel kayıt yüklenemedi. Veriler korunuyor; lütfen yedek alıp tekrar dene.';
      habits = [];
      pacts = [];
    }
    notifyListeners();
  }

  void _applyElapsedDays() {
    final current = ProgressionEngine.day(_now());
    final previous = DateTime.tryParse(lastCheckedDate ?? '');
    if (previous != null && activeHabits.isNotEmpty) {
      var pointer = ProgressionEngine.day(previous);
      var missed = 0;
      while (pointer.isBefore(current)) {
        final key = ProgressionEngine.dayKey(pointer);
        final due = activeHabits
            .where((h) => !ProgressionEngine.day(h.createdAt).isAfter(pointer))
            .toList();
        if (due.isNotEmpty &&
            !restDates.contains(key) &&
            due.any((h) => !h.completedOn(key))) {
          missed++;
        }
        pointer = DateTime(pointer.year, pointer.month, pointer.day + 1);
      }
      if (missed > 0) {
        reputation = (reputation - missed * 12).clamp(0, 100).toInt();
        herald =
            'Kraliyet kâtibi $missed aksayan gün buldu. Tahtı toparlayacak bir küçük görev seçelim!';
      }
    }
    lastCheckedDate = ProgressionEngine.dayKey(current);
  }

  String _id() => '${_now().microsecondsSinceEpoch}_${_idSequence++}';

  void addHabit(String name, String description, int difficulty) {
    if (_loadFailed) return;
    final clean = name.trim();
    if (clean.isEmpty) return;
    habits = [
      ...habits,
      Habit(
          id: _id(),
          name: clean,
          description: description.trim(),
          difficulty: difficulty.clamp(1, 3).toInt(),
          createdAt: _now(),
          completedDates: [])
    ];
    _event('Yeni vazife kayda geçti. Kâtipler mürekkep siparişi verdi.');
  }

  void editHabit(Habit habit, String name, String description, int difficulty) {
    if (_loadFailed) return;
    if (name.trim().isEmpty) return;
    habits = habits
        .map((h) => h.id == habit.id
            ? h.copyWith(
                name: name.trim(),
                description: description.trim(),
                difficulty: difficulty.clamp(1, 3).toInt())
            : h)
        .toList();
    _event('Vazife yeniden düzenlendi. Ferman geçerlidir.');
  }

  void archiveHabit(Habit habit) {
    if (_loadFailed) return;
    habits = habits
        .map((h) => h.id == habit.id ? h.copyWith(archived: true) : h)
        .toList();
    _event('Vazife arşive kaldırıldı. Eski kayıtlar saklanıyor.');
  }

  void toggleHabit(Habit habit) {
    if (_loadFailed) return;
    final key = today;
    if (habit.completedOn(key)) {
      habits = habits
          .map((h) => h.id == habit.id
              ? h.copyWith(
                  completedDates:
                      h.completedDates.where((d) => d != key).toList())
              : h)
          .toList();
      xp =
          (xp - ProgressionEngine.rewardFor(habit)).clamp(0, 999999999).toInt();
      reputation = (reputation - 4).clamp(0, 100).toInt();
      _event('Çentik geri alındı. Günlük kayıt düzeltildi.');
      return;
    }
    final before = badgeIds;
    final levelBefore = level;
    final dates = [...habit.completedDates, key];
    final hadPriorDay = habit.completedDates.any((day) => day != key);
    if (hadPriorDay) {
      final yesterday = ProgressionEngine.dayKey(
          ProgressionEngine.day(_now()).subtract(const Duration(days: 1)));
      if (!habit.completedOn(yesterday)) comebackCount++;
    }
    habits = habits
        .map((h) => h.id == habit.id ? h.copyWith(completedDates: dates) : h)
        .toList();
    xp += ProgressionEngine.rewardFor(habit);
    reputation = (reputation + 4).clamp(0, 100).toInt();
    _checkPacts();
    final newBadges = badgeIds.difference(before);
    if (level > levelBefore) {
      _event('RÜTBE YÜKSELDİ! Artık $rank. Borazanları uyandırın!',
          celebrate: true);
    } else if (newBadges.isNotEmpty) {
      final badge = badges.firstWhere((b) => b.id == newBadges.first);
      _event(
          'ROZET KAZANILDI: ${badge.name}! Mühürdar sevinçten mührünü düşürdü.',
          celebrate: true);
    } else {
      _event(
          'Vazife tamamlandı! +${ProgressionEngine.rewardFor(habit)} XP. Krallık bir adım daha ileri.',
          celebrate: true);
    }
  }

  void _checkPacts() {
    for (var i = 0; i < pacts.length; i++) {
      final pact = pacts[i];
      if (!pact.isCompleted &&
          BadgeEngine.pactProgress(pact, habits) >= pact.goalDays) {
        pacts[i] = pact.complete(_now());
        xp += 90 + pact.goalDays * 10;
        reputation = (reputation + 8).clamp(0, 100).toInt();
      }
    }
  }

  void addPact(String title, List<String> habitIds, int goalDays) {
    if (_loadFailed) return;
    if (title.trim().isEmpty || habitIds.isEmpty) return;
    final validIds = activeHabits.map((h) => h.id).toSet();
    if (!habitIds.every(validIds.contains)) return;
    pacts = [
      ...pacts,
      Pact(
          id: _id(),
          title: title.trim(),
          habitIds: habitIds.toSet().toList(),
          goalDays: goalDays.clamp(3, 90).toInt(),
          startedAt: _now())
    ];
    _event('Yeni ahit mühürlendi. Artık ferman defterindesin!');
  }

  void removePact(Pact pact) {
    if (_loadFailed) return;
    pacts = pacts.where((p) => p.id != pact.id).toList();
    _event('Ahit arşivden kaldırıldı. Kazanılmış tecrübe korunur.');
  }

  void toggleRestDay() {
    if (_loadFailed) return;
    if (restDates.contains(today)) {
      restDates.remove(today);
      _event('Bugünün istirahat mührü kaldırıldı.');
    } else {
      restDates.add(today);
      _event('Bugün planlı istirahat. İtibar kaybı uygulanmaz.');
    }
  }

  void _event(String message, {bool celebrate = false}) {
    herald = message;
    celebration = celebrate ? message : null;
    eventNumber++;
    _persist();
    notifyListeners();
  }

  void _persist() {
    if (_loadFailed) return;
    final encoded = jsonEncode({
      'version': 1,
      'idSequence': _idSequence,
      'xp': xp,
      'reputation': reputation,
      'comebackCount': comebackCount,
      'lastCheckedDate': lastCheckedDate,
      'restDates': restDates.toList(),
      'habits': habits.map((h) => h.toJson()).toList(),
      'pacts': pacts.map((p) => p.toJson()).toList(),
    });
    _writeQueue = _writeQueue
        .then((_) => _store.write(encoded))
        .catchError((Object error) {
      debugPrint('Yerel kayıt hatası: $error');
    });
  }
}
