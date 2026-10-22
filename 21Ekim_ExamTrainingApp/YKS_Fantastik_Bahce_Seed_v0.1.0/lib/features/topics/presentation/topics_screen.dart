import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/curriculum.dart';
import '../../../domain/repositories/curriculum_repository.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/garden_inputs.dart';
import '../../../shared/widgets/garden_progress.dart';
import '../../../shared/widgets/seed_notice.dart';
import 'subject_detail_screen.dart';
import 'topic_map_screen.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({this.repository, super.key});

  final CurriculumRepository? repository;

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  String stage = 'TYT';
  final searchController = TextEditingController();
  CurriculumRepository? _repo;
  List<Subject> _subjects = [];
  Map<String, Map<String, int>> _subjectStats = {};
  Map<String, int> _stageSummary = {
    'totalTopics': 0,
    'completedTopics': 0,
    'inProgressTopics': 0,
  };
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initCurriculum();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _initCurriculum() async {
    try {
      if (widget.repository != null) {
        _repo = widget.repository;
      } else {
        final db = await GardenDatabaseProvider.instance.database;
        _repo = CurriculumRepository(db);
      }
      await _repo!.seedInitialCurriculumIfEmpty();
      await _loadStageData();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadStageData() async {
    if (_repo == null) return;
    setState(() => _loading = true);

    final subjects = await _repo!.getSubjects(stage);
    final summary = await _repo!.getStageSummary(stage);
    final stats = await _repo!.getSubjectStatsForStage(stage);

    if (mounted) {
      setState(() {
        _subjects = subjects;
        _stageSummary = summary;
        _subjectStats = stats;
        _loading = false;
      });
    }
  }

  void _openSubject(Subject subject) async {
    if (_repo == null) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => SubjectDetailScreen(
          subject: subject,
          repository: _repo!,
        ),
      ),
    );
    if (mounted) {
      _loadStageData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = _subjects.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final totalTopics = _stageSummary['totalTopics'] ?? 0;
    final completedTopics = _stageSummary['completedTopics'] ?? 0;
    final overallRatio = totalTopics > 0 ? completedTopics / totalTopics : 0.0;

    return ListView(
      key: const PageStorageKey<String>('topics'),
      padding: const EdgeInsets.all(16),
      children: [
        ForestHeroCard(
          assetPath: GardenScenes.glasshouse,
          tag: '📚 Konu ve Ders Takibi',
          title: 'Botanik Bilgi Bahçesi',
          subtitle: 'Bitirdiğin her konu bahçende yeni bir yaprak açar.',
          height: 200,
          actionLabel: 'Konu Ağacı & Tekrar 🗺️',
          onAction: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => TopicMapScreen(repository: _repo),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        const SeedNotice(),
        const SizedBox(height: 12),
        NatureSegmentedControl<String>(
          items: const {
            'TYT': 'TYT Müfredatı',
            'AYT': 'AYT Müfredatı',
          },
          selected: stage,
          onChanged: (newStage) {
            setState(() => stage = newStage);
            _loadStageData();
          },
        ),
        const SizedBox(height: 14),
        NatureSearchField(
          controller: searchController,
          hintText: '$stage dersi ara...',
          onChanged: (val) => setState(() => _searchQuery = val),
          onClear: () => setState(() => _searchQuery = ''),
        ),
        const SizedBox(height: 14),
        // Genel İlerleme Özeti
        GardenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '$stage Genel Müfredat İlerlemesi',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$completedTopics / $totalTopics Konu',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: GardenPalette.mossEmerald,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LeafProgressBar(
                progress: overallRatio,
                height: 12,
                showLeafTip: true,
                activeColor: GardenPalette.mossEmerald,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        BotanicalSectionHeader(
          title: '$stage Dersleri ve Konu Detayları',
          subtitle: 'Ders seçerek alt konuları incele ve tamamla',
          icon: Icons.eco_outlined,
        ),
        if (_loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (filteredSubjects.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('Aradığın ders bulunamadı.')),
          )
        else
          ...filteredSubjects.map((s) {
            final stats = _subjectStats[s.id] ?? {'total': 0, 'completed': 0};
            final total = stats['total'] ?? 0;
            final completed = stats['completed'] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SubjectProgressBadge(
                subjectName: '${s.name} (~${s.questionCount} Soru)',
                completedTopics: completed,
                totalTopics: total,
                color: s.id.contains('mat')
                    ? GardenPalette.mossEmerald
                    : (s.id.contains('fen') || s.id.contains('fizik')
                        ? GardenPalette.streamTurquoise
                        : (s.id.contains('turkce') || s.id.contains('edebiyat')
                            ? GardenPalette.peachCoral
                            : GardenPalette.harvestGold)),
                onTap: () => _openSubject(s),
              ),
            );
          }),
        const SizedBox(height: 32),
      ],
    );
  }
}
