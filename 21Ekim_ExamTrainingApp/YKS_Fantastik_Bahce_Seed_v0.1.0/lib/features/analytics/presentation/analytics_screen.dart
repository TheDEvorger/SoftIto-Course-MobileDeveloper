import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/exam_record.dart';
import '../../../domain/models/student_preferences.dart';
import '../../../domain/repositories/exam_repository.dart';
import '../../../domain/repositories/preferences_repository.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/garden_inputs.dart';
import '../../../shared/widgets/garden_progress.dart';
import '../../../shared/widgets/seed_notice.dart';
import '../domain/analytics_models.dart';
import 'score_simulator_screen.dart';
import 'widgets/garden_line_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({
    this.examRepository,
    this.preferencesRepository,
    super.key,
  });

  final ExamRepository? examRepository;
  final PreferencesRepository? preferencesRepository;

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  ExamRepository? _examRepo;
  PreferencesRepository? _prefRepo;

  String _stage = 'TYT';
  String? _selectedSubjectId; // null = Genel Toplam
  List<ExamSession> _exams = [];
  StudentPreferences? _preferences;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initRepos();
  }

  Future<void> _initRepos() async {
    try {
      if (widget.examRepository != null &&
          widget.preferencesRepository != null) {
        _examRepo = widget.examRepository;
        _prefRepo = widget.preferencesRepository;
      } else {
        final db = await GardenDatabaseProvider.instance.database;
        _examRepo = widget.examRepository ?? ExamRepository(db);
        _prefRepo = widget.preferencesRepository ?? PreferencesRepository(db);
      }
      await _loadData();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadData() async {
    if (_examRepo == null || _prefRepo == null) return;
    setState(() => _loading = true);

    final exams = await _examRepo!.getExams(stage: _stage);
    final prefs = await _prefRepo!.getPreferences();

    if (mounted) {
      setState(() {
        _exams = exams;
        _preferences = prefs;
        _loading = false;
      });
    }
  }

  void _onStageChanged(String newStage) {
    if (_stage == newStage) return;
    setState(() {
      _stage = newStage;
      _selectedSubjectId = null; // Reset subject filter on stage switch
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: GardenPalette.mossEmerald),
      );
    }

    final chartPoints = AnalyticsCalculator.extractPoints(
      exams: _exams,
      subjectId: _selectedSubjectId,
    );

    final trend = AnalyticsCalculator.calculateTrend(chartPoints);
    final subjectStats = AnalyticsCalculator.extractSubjectStats(_exams);
    final targetNet = _preferences?.targetNet ?? 90.0;

    return RefreshIndicator(
      color: GardenPalette.mossEmerald,
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ForestHeroCard(
            assetPath: GardenScenes.valley,
            tag: '📊 Net ve Başarı Analizi',
            title: 'Gelişiminin Yolculuğu',
            subtitle: 'Grafiklerin, gerçek denemelerin geldikçe çiçek açacak.',
            height: 200,
            actionLabel: 'Puan Simülatörü 🎯',
            onAction: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      ScoreSimulatorScreen(examRepository: _examRepo),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const SeedNotice(),
          const SizedBox(height: 12),

          // Stage Selector (TYT / AYT)
          NatureSegmentedControl<String>(
            items: const {
              'TYT': 'TYT Net Analizi',
              'AYT': 'AYT Net Analizi',
            },
            selected: _stage,
            onChanged: _onStageChanged,
          ),
          const SizedBox(height: 14),

          // Subject filter chips
          _buildSubjectFilterBar(subjectStats),
          const SizedBox(height: 14),

          // Trend and Target Summary Card
          _buildSummaryCard(trend, targetNet),
          const SizedBox(height: 16),

          // Line Chart Header
          BotanicalSectionHeader(
            title: _selectedSubjectId == null
                ? '$_stage Toplam Net Eğrisi'
                : '${_getSubjectTitle(subjectStats)} Net Eğrisi',
            subtitle: '${chartPoints.length} deneme kaydı baz alınmıştır',
            icon: Icons.show_chart,
          ),
          const SizedBox(height: 10),

          // Garden Line Chart
          GardenLineChart(
            points: chartPoints,
            height: 220,
            lineColor: _selectedSubjectId == null
                ? GardenPalette.mossEmerald
                : GardenPalette.peachCoral,
          ),
          const SizedBox(height: 20),

          // Subject Breakdown Section
          if (_exams.isNotEmpty && subjectStats.isNotEmpty) ...[
            const BotanicalSectionHeader(
              title: 'Ders Bazında Başarı Dağılımı',
              subtitle: 'Son netler ve ders ortalamaları',
              icon: Icons.pie_chart_outline,
            ),
            const SizedBox(height: 10),
            _buildSubjectBreakdown(subjectStats),
            const SizedBox(height: 16),
          ],

          // Truth in measurement note
          const WaterInfoCard(
            title: 'Gerçekçi Ölçüm İlkesi',
            message:
                'Fantastik Bahçe’de uydurma veri ve sahte trend çizgisi bulunmaz. Trend eğrisi ve artış oranları yalnızca kaydettiğin gerçek denemelerle şekillenir.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSubjectFilterBar(List<SubjectNetStat> subjectStats) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          NatureFilterChip(
            label: 'Genel Net',
            selected: _selectedSubjectId == null,
            onSelected: (_) {
              setState(() => _selectedSubjectId = null);
            },
          ),
          const SizedBox(width: 8),
          ...subjectStats.map((stat) {
            final isSelected = _selectedSubjectId == stat.subjectId;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: NatureFilterChip(
                label: stat.subjectName,
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _selectedSubjectId = stat.subjectId);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(TrendSummary trend, double targetNet) {
    final hasData = trend.totalExams > 0;
    final progressToTarget = hasData && targetNet > 0
        ? (trend.averageNet / targetNet).clamp(0.0, 1.0)
        : 0.0;

    return GardenCard(
      child: Column(
        children: [
          Row(
            children: [
              OrganicProgressRing(
                progress: progressToTarget,
                size: 78,
                strokeWidth: 8,
                centerText:
                    hasData ? trend.averageNet.toStringAsFixed(1) : '0.0',
                subText: 'Ort. Net',
                activeColor: GardenPalette.mossEmerald,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '$_stage Hedefi',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: GardenPalette.harvestGold.withAlpha(40),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Hedef: ${targetNet.toStringAsFixed(0)} Net',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: GardenPalette.inkPlum,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      hasData
                          ? '${trend.totalExams} Deneme Bazında'
                          : 'Henüz Deneme Kaydedilmedi',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Trend status text
                    Text(
                      trend.changeText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: trend.netChange != null && trend.netChange! > 0
                            ? GardenPalette.mossEmerald
                            : (trend.netChange != null && trend.netChange! < 0
                                ? Colors.redAccent
                                : Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasData) ...[
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatMiniItem(
                  label: 'En Yüksek',
                  value: '${trend.highestNet.toStringAsFixed(2)} N',
                  color: GardenPalette.mossEmerald,
                ),
                _buildStatMiniItem(
                  label: 'Son Net',
                  value: trend.latestNet != null
                      ? '${trend.latestNet!.toStringAsFixed(2)} N'
                      : '-',
                  color: GardenPalette.streamTurquoise,
                ),
                _buildStatMiniItem(
                  label: 'En Düşük',
                  value: '${trend.lowestNet.toStringAsFixed(2)} N',
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatMiniItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectBreakdown(List<SubjectNetStat> subjectStats) {
    return Column(
      children: subjectStats.map((stat) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GardenCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: GardenPalette.mossEmerald.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_stories,
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
                        stat.subjectName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ortalama: ${stat.averageNet.toStringAsFixed(1)} Net (${stat.examCount} deneme)',
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
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: GardenPalette.mossEmerald.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: GardenPalette.mossEmerald.withAlpha(60),
                    ),
                  ),
                  child: Text(
                    '${stat.latestNet.toStringAsFixed(1)} Net',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: GardenPalette.inkPlum,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getSubjectTitle(List<SubjectNetStat> stats) {
    if (_selectedSubjectId == null) return 'Genel';
    final match = stats.where((s) => s.subjectId == _selectedSubjectId);
    if (match.isNotEmpty) return match.first.subjectName;
    return 'Ders';
  }
}
