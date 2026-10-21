import 'package:flutter/material.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/curriculum.dart';
import '../../../domain/repositories/curriculum_repository.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/garden_inputs.dart';
import '../../../shared/widgets/garden_progress.dart';

class SubjectDetailScreen extends StatefulWidget {
  const SubjectDetailScreen({
    required this.subject,
    required this.repository,
    super.key,
  });

  final Subject subject;
  final CurriculumRepository repository;

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  List<Topic> _topics = [];
  Map<String, TopicProgress> _progressMap = {};
  bool _loading = true;
  String _searchQuery = '';
  TopicStatus? _statusFilter;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTopics() async {
    final topics = await widget.repository.getTopics(widget.subject.id);
    final progress =
        await widget.repository.getAllProgressForSubject(widget.subject.id);
    if (mounted) {
      setState(() {
        _topics = topics;
        _progressMap = progress;
        _loading = false;
      });
    }
  }

  Future<void> _toggleStatus(Topic topic) async {
    final current = _progressMap[topic.id] ?? TopicProgress(topicId: topic.id);

    TopicStatus nextStatus;
    switch (current.status) {
      case TopicStatus.notStarted:
        nextStatus = TopicStatus.inProgress;
        break;
      case TopicStatus.inProgress:
        nextStatus = TopicStatus.completed;
        break;
      case TopicStatus.completed:
        nextStatus = TopicStatus.notStarted;
        break;
    }

    final updated = current.copyWith(
      status: nextStatus,
      lastStudiedAt: DateTime.now(),
    );

    await widget.repository.updateTopicProgress(updated);
    if (mounted) {
      setState(() {
        _progressMap[topic.id] = updated;
      });
    }
  }

  Future<void> _addQuestions(Topic topic) async {
    final current = _progressMap[topic.id] ?? TopicProgress(topicId: topic.id);

    final controller = TextEditingController(text: '20');
    final count = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${topic.name} Soru Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bu konuda çözdüğün soru sayısını ekle:'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Çözülen Soru Sayısı',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              Navigator.of(ctx).pop(val);
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );

    if (count != null && count > 0) {
      final updated = current.copyWith(
        answeredCount: current.answeredCount + count,
        lastStudiedAt: DateTime.now(),
        status: current.status == TopicStatus.notStarted
            ? TopicStatus.inProgress
            : current.status,
      );
      await widget.repository.updateTopicProgress(updated);
      if (mounted) {
        setState(() {
          _progressMap[topic.id] = updated;
        });
      }
    }
  }

  Color _getStatusColor(TopicStatus status) {
    switch (status) {
      case TopicStatus.completed:
        return GardenPalette.mossEmerald;
      case TopicStatus.inProgress:
        return GardenPalette.peachCoral;
      case TopicStatus.notStarted:
        return Colors.grey.shade600;
    }
  }

  IconData _getStatusIcon(TopicStatus status) {
    switch (status) {
      case TopicStatus.completed:
        return Icons.check_circle;
      case TopicStatus.inProgress:
        return Icons.eco;
      case TopicStatus.notStarted:
        return Icons.radio_button_unchecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final completedCount = _progressMap.values
        .where((p) => p.status == TopicStatus.completed)
        .length;
    final inProgressCount = _progressMap.values
        .where((p) => p.status == TopicStatus.inProgress)
        .length;
    final total = _topics.length;
    final ratio = total > 0 ? completedCount / total : 0.0;

    final filteredTopics = _topics.where((t) {
      final matchesQuery = _searchQuery.isEmpty ||
          t.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final progress = _progressMap[t.id];
      final status = progress?.status ?? TopicStatus.notStarted;
      final matchesStatus = _statusFilter == null || status == _statusFilter;
      return matchesQuery && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject.stage} • ${widget.subject.name}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GardenCard(
                  child: Row(
                    children: [
                      OrganicProgressRing(
                        progress: ratio,
                        size: 80,
                        strokeWidth: 8,
                        centerText: '%${(ratio * 100).toInt()}',
                        subText: 'Bitti',
                        activeColor: GardenPalette.mossEmerald,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.subject.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sınavda ~${widget.subject.questionCount} Soru • Toplam $total Konu',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.white60
                                    : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                _buildMiniBadge(
                                  label: '$completedCount Tamam',
                                  color: GardenPalette.mossEmerald,
                                ),
                                _buildMiniBadge(
                                  label: '$inProgressCount Çalışılıyor',
                                  color: GardenPalette.peachCoral,
                                ),
                                _buildMiniBadge(
                                  label:
                                      '${total - completedCount - inProgressCount} Eksik',
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                NatureSearchField(
                  controller: _searchController,
                  hintText: '${widget.subject.name} konusu ara...',
                  onChanged: (val) => setState(() => _searchQuery = val),
                  onClear: () => setState(() => _searchQuery = ''),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      NatureFilterChip(
                        label: 'Tümü ($total)',
                        selected: _statusFilter == null,
                        onSelected: (_) => setState(() => _statusFilter = null),
                      ),
                      const SizedBox(width: 8),
                      NatureFilterChip(
                        label: 'Tamamlandı ($completedCount)',
                        icon: Icons.check_circle_outline,
                        selected: _statusFilter == TopicStatus.completed,
                        onSelected: (val) => setState(() =>
                            _statusFilter = val ? TopicStatus.completed : null),
                      ),
                      const SizedBox(width: 8),
                      NatureFilterChip(
                        label: 'Çalışılıyor ($inProgressCount)',
                        icon: Icons.eco,
                        selected: _statusFilter == TopicStatus.inProgress,
                        onSelected: (val) => setState(() => _statusFilter =
                            val ? TopicStatus.inProgress : null),
                      ),
                      const SizedBox(width: 8),
                      NatureFilterChip(
                        label:
                            'Eksik (${total - completedCount - inProgressCount})',
                        icon: Icons.pending_actions,
                        selected: _statusFilter == TopicStatus.notStarted,
                        onSelected: (val) => setState(() => _statusFilter =
                            val ? TopicStatus.notStarted : null),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                BotanicalSectionHeader(
                  title: 'Konu Listesi (${filteredTopics.length})',
                  subtitle: 'Tıkla: durumu değiştir • Soru ekle',
                  icon: Icons.library_books,
                ),
                if (filteredTopics.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'Bu filtrede konu bulunamadı.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                else
                  ...filteredTopics.map((topic) {
                    final progress = _progressMap[topic.id] ??
                        TopicProgress(topicId: topic.id);
                    final color = _getStatusColor(progress.status);
                    final icon = _getStatusIcon(progress.status);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GardenCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        onTap: () => _toggleStatus(topic),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleStatus(topic),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.withAlpha(isDark ? 50 : 25),
                                  border: Border.all(color: color, width: 1.5),
                                ),
                                child: Icon(icon, color: color, size: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      decoration: progress.status ==
                                              TopicStatus.completed
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isDark
                                          ? const Color(0xFFF8F2E8)
                                          : GardenPalette.inkPlum,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        progress.status.label,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: color,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '•  ${progress.answeredCount} soru',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      if (progress.lastStudiedAt != null) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          '•  ${progress.lastStudiedAt!.day}.${progress.lastStudiedAt!.month}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_task),
                              tooltip: 'Soru Ekle',
                              color: GardenPalette.mossEmerald,
                              onPressed: () => _addQuestions(topic),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildMiniBadge({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
