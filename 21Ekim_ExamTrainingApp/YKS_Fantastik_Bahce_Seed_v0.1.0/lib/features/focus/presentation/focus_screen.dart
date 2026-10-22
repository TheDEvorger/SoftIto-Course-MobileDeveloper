import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/focus_record.dart';
import '../../../domain/repositories/focus_repository.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/garden_progress.dart';
import '../domain/pomodoro_mode.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({
    this.repository,
    this.customDurationSeconds,
    this.nowProvider,
    super.key,
  });

  final FocusRepository? repository;
  final int? customDurationSeconds;
  final DateTime Function()? nowProvider;

  @override
  State<FocusScreen> createState() => FocusScreenState();
}

class FocusScreenState extends State<FocusScreen> with WidgetsBindingObserver {
  FocusRepository? _repo;

  PomodoroMode _mode = PomodoroMode.focus;
  late int _initialSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  DateTime? _deadline;
  DateTime? _sessionStartedAt;

  List<FocusSession> _history = [];
  int _totalElapsedSeconds = 0;
  bool _loading = true;

  DateTime get _now =>
      widget.nowProvider != null ? widget.nowProvider!() : DateTime.now();

  bool get isRunning => _timer != null;
  int get remainingSeconds => _remainingSeconds;
  PomodoroMode get currentMode => _mode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialSeconds = widget.customDurationSeconds ?? _mode.defaultSeconds;
    _remainingSeconds = _initialSeconds;
    _initRepo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isRunning && _deadline != null) {
      _syncWithWallClock();
    }
  }

  void _syncWithWallClock() {
    if (_deadline == null) return;

    final diff = _deadline!.difference(_now).inSeconds;
    if (diff <= 0) {
      _completeSession();
    } else {
      setState(() {
        _remainingSeconds = diff.clamp(0, _initialSeconds);
      });
    }
  }

  Future<void> _initRepo() async {
    try {
      if (widget.repository != null) {
        _repo = widget.repository;
      } else {
        final db = await GardenDatabaseProvider.instance.database;
        _repo = FocusRepository(db);
      }
      await _loadHistory();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadHistory() async {
    if (_repo == null) return;
    setState(() => _loading = true);
    final history = await _repo!.getAllSessions();
    final totalSecs = await _repo!.getTotalElapsedSeconds();

    if (mounted) {
      setState(() {
        _history = history;
        _totalElapsedSeconds = totalSecs;
        _loading = false;
      });
    }
  }

  void switchMode(PomodoroMode newMode) {
    if (_mode == newMode && !isRunning) return;
    _timer?.cancel();
    _timer = null;
    _deadline = null;

    setState(() {
      _mode = newMode;
      _initialSeconds = newMode.defaultSeconds;
      _remainingSeconds = _initialSeconds;
    });
  }

  void setCustomMinutes(int minutes) {
    _timer?.cancel();
    _timer = null;
    _deadline = null;

    setState(() {
      _initialSeconds = minutes * 60;
      _remainingSeconds = _initialSeconds;
    });
  }

  void start() {
    if (isRunning || _remainingSeconds <= 0) return;

    _sessionStartedAt = _now;
    _deadline = _now.add(Duration(seconds: _remainingSeconds));

    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      final diff = _deadline!.difference(_now).inSeconds;
      if (diff <= 0) {
        _completeSession();
      } else {
        setState(() {
          _remainingSeconds = diff.clamp(0, _initialSeconds);
        });
      }
    });

    setState(() {});
  }

  void pause() {
    if (!isRunning) return;
    _syncWithWallClock();
    _timer?.cancel();
    _timer = null;
    _deadline = null;
    setState(() {});
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    _deadline = null;
    setState(() {
      _remainingSeconds = _initialSeconds;
    });
  }

  Future<void> _completeSession() async {
    _timer?.cancel();
    _timer = null;
    _deadline = null;

    final elapsed = _initialSeconds;
    setState(() {
      _remainingSeconds = 0;
    });

    if (_repo != null) {
      final session = FocusSession(
        id: 'focus_${_now.millisecondsSinceEpoch}',
        startedAt: _sessionStartedAt ?? _now,
        durationSeconds: _initialSeconds,
        elapsedSeconds: elapsed,
        subjectId: _mode.name,
        completed: true,
      );

      await _repo!.saveFocusSession(session);
      await _loadHistory();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🌟 Tebrikler! ${_mode.label} oturumunu başarıyla tamamladın.',
          ),
          backgroundColor: GardenPalette.mossEmerald,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    final progress = _initialSeconds > 0
        ? ((_initialSeconds - _remainingSeconds) / _initialSeconds)
            .clamp(0.0, 1.0)
        : 0.0;

    final totalMinutes = _totalElapsedSeconds ~/ 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orman Çalışma Kulübesi'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ForestHeroCard(
            assetPath: GardenScenes.cottage,
            tag: '⏳ Pomodoro & Odaklanma',
            title: 'Sessiz Çalışma Kulübesi',
            subtitle: 'Dış dünyayı unut; sadece öğrenmeye ve hedefine odaklan.',
            height: 190,
          ),
          const SizedBox(height: 14),

          // Total focus time badge
          if (!_loading && totalMinutes > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: WaterInfoCard(
                title: 'Toplam Odaklanma Başarın',
                message:
                    'Bugüne kadar kulübede toplam $totalMinutes dakika boyunca dikkatin dağılmadan çalıştın.',
              ),
            ),

          // Mode Selector
          NatureSegmentedControl<PomodoroMode>(
            items: const {
              PomodoroMode.focus: '25 dk Odak',
              PomodoroMode.shortBreak: '5 dk Mola',
              PomodoroMode.longBreak: '15 dk Uzun Mola',
            },
            selected: _mode,
            onChanged: switchMode,
          ),
          const SizedBox(height: 14),

          // Timer Card
          GardenCard(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                // Mode indicator tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isRunning
                        ? GardenPalette.peachCoral.withAlpha(25)
                        : _mode.accentColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isRunning
                          ? GardenPalette.peachCoral.withAlpha(60)
                          : _mode.accentColor.withAlpha(60),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _mode.icon,
                        size: 16,
                        color: isRunning
                            ? GardenPalette.peachCoral
                            : _mode.accentColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isRunning
                            ? '🌿 ${_mode.label} Devam Ediyor'
                            : '🌱 ${_mode.label} Hazır',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isRunning
                              ? GardenPalette.peachCoral
                              : _mode.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Progress Ring with Countdown Center
                Stack(
                  alignment: Alignment.center,
                  children: [
                    OrganicProgressRing(
                      progress: progress,
                      size: 180,
                      strokeWidth: 10,
                      centerText: '',
                      activeColor: isRunning
                          ? GardenPalette.peachCoral
                          : _mode.accentColor,
                    ),
                    Semantics(
                      label:
                          'Kalan odak süresi $minutes dakika $seconds saniye',
                      child: Text(
                        '$minutes:$seconds',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: isDark
                              ? const Color(0xFFF8F2E8)
                              : GardenPalette.inkPlum,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Controls: Start/Pause and Reset
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GardenPrimaryButton(
                        label: isRunning ? 'Duraklat' : 'Başlat',
                        icon: isRunning ? Icons.pause : Icons.play_arrow,
                        onPressed: isRunning ? pause : start,
                      ),
                    ),
                    const SizedBox(width: 14),
                    BotanicalIconButton(
                      icon: Icons.refresh,
                      tooltip: 'Sıfırla',
                      onPressed: reset,
                      size: 48,
                      iconSize: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Quick Minutes Selector
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [15, 25, 45, 60].map((m) {
                    final isCurrent = _initialSeconds == m * 60;
                    return InkWell(
                      onTap: () => setCustomMinutes(m),
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: disableAnimations
                            ? Duration.zero
                            : const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? GardenPalette.mossEmerald
                              : (isDark
                                  ? GardenPalette.nightCard
                                  : GardenPalette.gardenPaper),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCurrent
                                ? GardenPalette.mossEmerald
                                : GardenPalette.mossEmerald.withAlpha(40),
                          ),
                        ),
                        child: Text(
                          '$m dk',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isCurrent
                                ? Colors.white
                                : (isDark
                                    ? Colors.white70
                                    : GardenPalette.inkPlum),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Session History
          const BotanicalSectionHeader(
            title: 'Tamamlanan Odak Oturumları',
            subtitle: 'Kulübede kaydettiğin gerçek çalışma süreleri',
            icon: Icons.history,
          ),
          const SizedBox(height: 10),

          if (_history.isEmpty)
            GardenCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    size: 32,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Henüz Kayıtlı Oturum Yok',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Başlat butonuna basarak ilk odak seansını tamamlayabilirsin.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            ..._history.take(6).map((item) {
              final durMin = item.elapsedSeconds ~/ 60;
              final durSec = item.elapsedSeconds % 60;
              final dateStr =
                  '${item.startedAt.day}.${item.startedAt.month}.${item.startedAt.year} ${item.startedAt.hour.toString().padLeft(2, '0')}:${item.startedAt.minute.toString().padLeft(2, '0')}';

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GardenCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: GardenPalette.mossEmerald.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          size: 18,
                          color: GardenPalette.mossEmerald,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.subjectId == PomodoroMode.shortBreak.name
                                  ? 'Kısa Mola'
                                  : (item.subjectId ==
                                          PomodoroMode.longBreak.name
                                      ? 'Uzun Mola'
                                      : 'Odak Seansı'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              dateStr,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: GardenPalette.gardenPaper,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: GardenPalette.mossEmerald.withAlpha(50),
                          ),
                        ),
                        child: Text(
                          durMin > 0 ? '$durMin dk' : '$durSec sn',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: GardenPalette.inkPlum,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
