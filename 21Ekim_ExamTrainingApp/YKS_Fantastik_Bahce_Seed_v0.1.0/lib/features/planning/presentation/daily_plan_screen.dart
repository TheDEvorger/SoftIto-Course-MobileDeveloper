import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/daily_task.dart';
import '../../../domain/repositories/curriculum_repository.dart';
import '../../../domain/repositories/planning_repository.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/garden_progress.dart';
import 'task_entry_dialog.dart';

class DailyPlanScreen extends StatefulWidget {
  const DailyPlanScreen({
    this.planningRepository,
    this.curriculumRepository,
    this.initialDate,
    super.key,
  });

  final PlanningRepository? planningRepository;
  final CurriculumRepository? curriculumRepository;
  final DateTime? initialDate;

  @override
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends State<DailyPlanScreen> {
  PlanningRepository? _planRepo;
  CurriculumRepository? _currRepo;

  late DateTime _currentDate;
  List<DailyTask> _tasks = [];
  DailyPlanSummary _summary = const DailyPlanSummary(
    totalTasks: 0,
    completedTasks: 0,
    targetQuestions: 0,
    completedQuestions: 0,
  );
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate ?? DateTime.now();
    _initRepos();
  }

  Future<void> _initRepos() async {
    try {
      if (widget.planningRepository != null) {
        _planRepo = widget.planningRepository;
        _currRepo = widget.curriculumRepository;
      } else {
        final db = await GardenDatabaseProvider.instance.database;
        _planRepo = PlanningRepository(db);
        _currRepo = CurriculumRepository(db);
      }
      await _loadTasks();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadTasks() async {
    if (_planRepo == null) return;
    setState(() => _loading = true);

    final tasks = await _planRepo!.getTasksForDate(_currentDate);
    final summary = await _planRepo!.getSummaryForDate(_currentDate);

    if (mounted) {
      setState(() {
        _tasks = tasks;
        _summary = summary;
        _loading = false;
      });
    }
  }

  void _changeDate(int dayOffset) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: dayOffset));
    });
    _loadTasks();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null && mounted) {
      setState(() => _currentDate = picked);
      _loadTasks();
    }
  }

  Future<void> _openAddTask() async {
    final task = await TaskEntryDialog.show(
      context,
      initialDate: _currentDate,
      curriculumRepository: _currRepo,
    );

    if (task != null && _planRepo != null) {
      await _planRepo!.saveTask(task);
      await _loadTasks();
    }
  }

  Future<void> _openEditTask(DailyTask task) async {
    final updated = await TaskEntryDialog.show(
      context,
      existingTask: task,
      initialDate: task.scheduledDate,
      curriculumRepository: _currRepo,
    );

    if (updated != null && _planRepo != null) {
      await _planRepo!.saveTask(updated);
      await _loadTasks();
    }
  }

  Future<void> _toggleTask(DailyTask task) async {
    if (_planRepo == null) return;
    await _planRepo!.toggleTaskDone(task.id, !task.isDone);
    await _loadTasks();
  }

  Future<void> _deleteTask(DailyTask task) async {
    if (_planRepo == null) return;
    await _planRepo!.deleteTask(task.id);
    await _loadTasks();
  }

  bool get _isToday {
    final now = DateTime.now();
    return _currentDate.year == now.year &&
        _currentDate.month == now.month &&
        _currentDate.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final dateTitle = _isToday
        ? 'Bugün, ${_formatDate(_currentDate)}'
        : _formatDate(_currentDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Günlük Çalışma Planı'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Yeni Görev Ekle',
            icon: const Icon(Icons.add),
            onPressed: _openAddTask,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: GardenPalette.mossEmerald,
        foregroundColor: Colors.white,
        onPressed: _openAddTask,
        icon: const Icon(Icons.add),
        label: const Text('Görev Ekle'),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(color: GardenPalette.mossEmerald),
            )
          : RefreshIndicator(
              color: GardenPalette.mossEmerald,
              onRefresh: _loadTasks,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const ForestHeroCard(
                    assetPath: GardenScenes.clearing,
                    tag: '🌱 Günlük Hedefler',
                    title: 'Her Gün Bir Adım',
                    subtitle:
                        'Büyük başarılar, her gün atılan sabırlı adımların toplamıdır.',
                    height: 190,
                  ),
                  const SizedBox(height: 14),

                  // Date Navigator Bar
                  _buildDateNavigator(dateTitle),
                  const SizedBox(height: 14),

                  // Progress Summary Card
                  _buildSummaryCard(),
                  const SizedBox(height: 16),

                  // Tasks Section Header
                  BotanicalSectionHeader(
                    title: 'Planlanan Görevler',
                    subtitle: '${_tasks.length} adet görev listelendi',
                    icon: Icons.checklist,
                  ),
                  const SizedBox(height: 10),

                  // Task list or empty state
                  if (_tasks.isEmpty)
                    _buildEmptyState()
                  else
                    ..._tasks.map(_buildTaskItem),

                  const SizedBox(height: 70), // padding for FAB
                ],
              ),
            ),
    );
  }

  Widget _buildDateNavigator(String dateTitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GardenPalette.mossEmerald.withAlpha(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Önceki Gün',
            onPressed: () => _changeDate(-1),
          ),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 18,
                    color: GardenPalette.mossEmerald,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Sonraki Gün',
            onPressed: () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final pct = (_summary.taskProgress * 100).toInt();

    return GardenCard(
      child: Column(
        children: [
          Row(
            children: [
              OrganicProgressRing(
                progress: _summary.taskProgress,
                size: 78,
                strokeWidth: 8,
                centerText: '%$pct',
                subText: 'Tamamlandı',
                activeColor: GardenPalette.mossEmerald,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_summary.completedTasks} / ${_summary.totalTasks} Görev Bitti',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _summary.targetQuestions > 0
                          ? '${_summary.completedQuestions} / ${_summary.targetQuestions} Soru Hedefi'
                          : 'Soru hedefi belirlenmedi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LeafProgressBar(
                      progress: _summary.questionProgress > 0
                          ? _summary.questionProgress
                          : _summary.taskProgress,
                      label: 'Günün Tamamlanma Oranı',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return GardenCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.spa_outlined,
            size: 40,
            color: GardenPalette.mossEmerald.withAlpha(120),
          ),
          const SizedBox(height: 10),
          const Text(
            'Bu Gün İçin Görev Yok',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Aşağıdaki "Görev Ekle" butonuna basarak gününü planlamaya başla.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(DailyTask task) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GardenCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: task.isDone,
              activeColor: GardenPalette.mossEmerald,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              onChanged: (_) => _toggleTask(task),
            ),
            const SizedBox(width: 8),
            // Details
            Expanded(
              child: GestureDetector(
                onTap: () => _toggleTask(task),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration:
                            task.isDone ? TextDecoration.lineThrough : null,
                        color: task.isDone
                            ? Colors.grey
                            : (isDark
                                ? const Color(0xFFF8F2E8)
                                : GardenPalette.inkPlum),
                      ),
                    ),
                    if (task.targetQuestions > 0)
                      Text(
                        '${task.targetQuestions} Soru Hedefi',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: task.isDone
                              ? Colors.grey
                              : GardenPalette.mossEmerald,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Edit & Delete actions
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              tooltip: 'Düzenle',
              onPressed: () => _openEditTask(task),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: Colors.redAccent,
              tooltip: 'Sil',
              onPressed: () => _deleteTask(task),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}
