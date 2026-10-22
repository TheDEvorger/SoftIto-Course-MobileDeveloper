import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/content/app_copy.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/daily_task.dart';
import '../../../domain/models/student_preferences.dart';
import '../../../domain/repositories/planning_repository.dart';
import '../../../domain/repositories/preferences_repository.dart';
import '../../../shared/widgets/countdown_card.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/garden_progress.dart';
import '../../../shared/widgets/preferences_dialog.dart';
import '../../../shared/widgets/seed_notice.dart';
import '../../mentors/presentation/mentors_screen.dart';
import '../../planning/presentation/daily_plan_screen.dart';
import '../../planning/presentation/task_entry_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.onStartFocus,
    this.preferencesRepository,
    this.planningRepository,
    super.key,
  });

  final VoidCallback onStartFocus;
  final PreferencesRepository? preferencesRepository;
  final PlanningRepository? planningRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StudentPreferences? _preferences;
  PreferencesRepository? _prefRepo;
  PlanningRepository? _planRepo;

  List<DailyTask> _todayTasks = [];
  DailyPlanSummary _planSummary = const DailyPlanSummary(
    totalTasks: 0,
    completedTasks: 0,
    targetQuestions: 0,
    completedQuestions: 0,
  );

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      if (widget.preferencesRepository != null &&
          widget.planningRepository != null) {
        _prefRepo = widget.preferencesRepository;
        _planRepo = widget.planningRepository;
      } else {
        final db = await GardenDatabaseProvider.instance.database;
        _prefRepo = widget.preferencesRepository ?? PreferencesRepository(db);
        _planRepo = widget.planningRepository ?? PlanningRepository(db);
      }
      await _loadContent();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadContent() async {
    if (_prefRepo == null || _planRepo == null) return;
    setState(() => _loading = true);

    final prefs = await _prefRepo!.getPreferences();
    final today = DateTime.now();
    final tasks = await _planRepo!.getTasksForDate(today);
    final summary = await _planRepo!.getSummaryForDate(today);

    if (mounted) {
      setState(() {
        _preferences = prefs;
        _todayTasks = tasks;
        _planSummary = summary;
        _loading = false;
      });
    }
  }

  Future<void> _openPreferences() async {
    if (_prefRepo == null) return;
    final updated = await PreferencesDialog.show(
      context,
      repository: _prefRepo!,
      initialPreferences: _preferences,
    );
    if (updated != null && mounted) {
      setState(() => _preferences = updated);
    }
  }

  Future<void> _openDailyPlan() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DailyPlanScreen(
          planningRepository: _planRepo,
        ),
      ),
    );
    _loadContent();
  }

  Future<void> _openAddTask() async {
    final task = await TaskEntryDialog.show(
      context,
      initialDate: DateTime.now(),
    );

    if (task != null && _planRepo != null) {
      await _planRepo!.saveTask(task);
      await _loadContent();
    }
  }

  Future<void> _toggleTask(DailyTask task) async {
    if (_planRepo == null) return;
    await _planRepo!.toggleTaskDone(task.id, !task.isDone);
    await _loadContent();
  }

  void _openMentors() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const MentorsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _preferences?.displayName;
    final welcomeTitle = name != null && name.isNotEmpty
        ? 'Merhaba, $name! 🌱'
        : 'Bugün senin günün! 🌱';
    final field = _preferences?.field ?? 'Sayısal';

    final progressRatio = _planSummary.targetQuestions > 0
        ? _planSummary.questionProgress
        : _planSummary.taskProgress;

    return ListView(
      key: const PageStorageKey<String>('home'),
      padding: const EdgeInsets.all(16),
      children: [
        ForestHeroCard(
          assetPath: GardenScenes.sunrise,
          tag: '🌿 $field Alanı',
          title: welcomeTitle,
          subtitle: AppCopy.welcome,
          actionLabel: 'Odak Odasına Gir ⏳',
          onAction: widget.onStartFocus,
          height: 220,
        ),
        const SizedBox(height: 12),

        // Kadim Akademi & Canlı Dersler Özel Kartı
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _openMentors,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF203A43), Color(0xFF2C5364)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    image: const DecorationImage(
                      image: AssetImage('assets/illustrations/mentors/mentor_theron.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'CANLI DERS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              'Kadim Bilge Hocalar',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Theron, Sylva, Ignis ve Valerius yayında! Soru sor ve taktik al.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const SeedNotice(),
        const SizedBox(height: 12),

        // YKS Countdown Header & Card
        BotanicalSectionHeader(
          title: 'YKS Geri Sayım Sayacı',
          subtitle: 'Kişiselleştirilmiş hedef sınav tarihi',
          icon: Icons.hourglass_top,
          actionText: 'Tarihi Ayarla',
          onAction: _openPreferences,
        ),
        if (_loading)
          const GardenCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        else
          YksCountdownCard(
            targetDate: _preferences?.targetDate,
            onEditDate: _openPreferences,
          ),
        const SizedBox(height: 14),

        // Today's Goals Section
        BotanicalSectionHeader(
          title: 'Günün Hedefleri',
          subtitle: '${_todayTasks.length} adet planlanan görev',
          icon: Icons.check_circle_outline,
          actionText: 'Tüm Planı Gör',
          onAction: _openDailyPlan,
        ),
        GardenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Bugünkü Hedef İlerlemesi',
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _planSummary.targetQuestions > 0
                        ? '${_planSummary.completedQuestions} / ${_planSummary.targetQuestions} Soru'
                        : '${_planSummary.completedTasks} / ${_planSummary.totalTasks} Görev',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: GardenPalette.mossEmerald,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LeafProgressBar(
                progress: progressRatio,
                label: 'Günün Tamamlanma Oranı',
              ),
              const SizedBox(height: 12),
              if (_todayTasks.isEmpty) ...[
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Bugün için henüz görev eklemedin. Birkaç küçük hedef koyarak başla.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _openAddTask,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Hedef Ekle'),
                    ),
                  ],
                ),
              ] else ...[
                ..._todayTasks.take(3).map((task) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isDone,
                          activeColor: GardenPalette.mossEmerald,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (_) => _toggleTask(task),
                        ),
                        Expanded(
                          child: Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 13,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isDone ? Colors.grey : null,
                            ),
                          ),
                        ),
                        if (task.targetQuestions > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: GardenPalette.gardenPaper,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${task.targetQuestions} S',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: GardenPalette.mossEmerald,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _openAddTask,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Yeni Hedef Ekle'),
                    ),
                    TextButton(
                      onPressed: _openDailyPlan,
                      child: const Text('Tümünü Yönet →'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Achievement Target Card
        GoldenAchievementCard(
          title:
              'Hedef Net: ${_preferences?.targetNet?.toStringAsFixed(1) ?? 'Belirlenmedi'}',
          subtitle:
              'İlk denemeni kaydettiğinde ve konu bitirdiğinde burada parlayacak.',
          badgeText: field,
          progressText: _preferences?.targetDate != null
              ? 'Hedef takvimi devrede'
              : 'Tarih ve net hedefini belirle',
          onTap: _openPreferences,
        ),
        const SizedBox(height: 20),

        GardenPrimaryButton(
          label: 'Odak Odasını Başlat (Pomodoro)',
          icon: Icons.timer_outlined,
          onPressed: widget.onStartFocus,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
