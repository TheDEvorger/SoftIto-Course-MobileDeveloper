import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/curriculum.dart';
import '../../../domain/models/topic_relation.dart';
import '../../../domain/repositories/curriculum_repository.dart';
import '../../../domain/services/topic_map_service.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/seed_notice.dart';
import 'topic_map_painter.dart';

class TopicMapScreen extends StatefulWidget {
  const TopicMapScreen({
    super.key,
    this.repository,
    this.mapService,
  });

  final CurriculumRepository? repository;
  final TopicMapService? mapService;

  @override
  State<TopicMapScreen> createState() => _TopicMapScreenState();
}

class _TopicMapScreenState extends State<TopicMapScreen> {
  CurriculumRepository? _repo;
  TopicMapService? _service;

  bool _loading = true;
  String _selectedBranch =
      'matematik'; // 'matematik', 'fizik', 'kimya', 'biyoloji'
  String _viewMode = 'map'; // 'map' or 'list'

  List<TopicNodeInfo> _currentNodes = [];
  List<TopicNodeInfo> _reviewRecommendations = [];
  TopicNodeInfo? _selectedNode;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    try {
      if (widget.repository != null) {
        _repo = widget.repository;
        _service = widget.mapService ?? TopicMapService(_repo!);
      } else {
        final db = await GardenDatabaseProvider.instance.database;
        _repo = CurriculumRepository(db);
        _service = TopicMapService(_repo!);
      }
      await _loadBranchData();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadBranchData() async {
    if (_service == null) return;
    setState(() => _loading = true);

    final nodes = await _service!.getTopicNodesForBranch(
      branchKey: _selectedBranch,
    );
    final reviews = await _service!.getReviewRecommendations();

    if (mounted) {
      setState(() {
        _currentNodes = nodes;
        _reviewRecommendations = reviews;
        _selectedNode = nodes.isNotEmpty ? nodes.first : null;
        _loading = false;
      });
    }
  }

  Future<void> _updateNodeStatus(
      TopicNodeInfo node, TopicStatus newStatus) async {
    if (_repo == null) return;

    final progress = TopicProgress(
      topicId: node.topicId,
      status: newStatus,
      answeredCount: node.answeredCount,
      lastStudiedAt: DateTime.now(),
    );

    await _repo!.updateTopicProgress(progress);
    await _loadBranchData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konu Ağacı & Tekrar Haritası'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(color: GardenPalette.mossEmerald),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                ForestHeroCard(
                  assetPath: GardenScenes.waterfall,
                  tag: '🌊 Doğrulanmış MEB Önkoşul Haritası',
                  title: 'Konu Bağlantıları ve Tekrar',
                  subtitle:
                      'Konuların pedagojik önkoşul zincirini izle, unutma eğrisine karşı zamanında tekrar et.',
                  height: 200,
                  actionLabel: _viewMode == 'map'
                      ? 'Liste Görünümü 📋'
                      : 'Ağ Haritası 🗺️',
                  onAction: () {
                    setState(() {
                      _viewMode = _viewMode == 'map' ? 'list' : 'map';
                    });
                  },
                ),
                const SizedBox(height: 12),
                const SeedNotice(),
                const SizedBox(height: 12),

                // Branş Seçici Segmented Control
                NatureSegmentedControl<String>(
                  items: const {
                    'matematik': 'Matematik',
                    'fizik': 'Fizik',
                    'kimya': 'Kimya',
                    'biyoloji': 'Biyoloji',
                  },
                  selected: _selectedBranch,
                  onChanged: (newBranch) {
                    setState(() => _selectedBranch = newBranch);
                    _loadBranchData();
                  },
                ),
                const SizedBox(height: 12),

                // Görünüm Modu Değiştirici
                NatureSegmentedControl<String>(
                  items: const {
                    'map': '🗺️ Botanik Ağ Haritası',
                    'list': '📋 Erişilebilir Liste Modu',
                  },
                  selected: _viewMode,
                  onChanged: (newMode) => setState(() => _viewMode = newMode),
                ),
                const SizedBox(height: 16),

                // Tekrar Önerileri Bölümü (Spaced Repetition Banners)
                if (_reviewRecommendations.isNotEmpty) ...[
                  const BotanicalSectionHeader(
                    title: 'Tekrar Önerileri (Aralıklı Tekrar)',
                    subtitle:
                        'Unutma eğrisini yenilemek için tazelemeye ihtiyaç duyan konular',
                    icon: Icons.history_edu_outlined,
                  ),
                  SizedBox(
                    height: 115,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _reviewRecommendations.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (ctx, i) {
                        final item = _reviewRecommendations[i];
                        return Container(
                          width: 250,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: GardenPalette.peachCoral.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: GardenPalette.peachCoral.withAlpha(80),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.alarm_on,
                                    size: 16,
                                    color: GardenPalette.peachCoral,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item.topicName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                item.reviewMessage ?? 'Tekrar zamanı',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () => _updateNodeStatus(
                                      item,
                                      TopicStatus.completed,
                                    ),
                                    child: const Text(
                                      'Tekrar Ettim ✓',
                                      style: TextStyle(
                                        color: GardenPalette.mossEmerald,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Ana İçerik: Harita Modu veya Liste Modu
                if (_viewMode == 'map')
                  _buildMapCanvasView(isDark)
                else
                  _buildAccessibleListView(isDark),

                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildMapCanvasView(bool isDark) {
    if (_currentNodes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('Bu branşta haritalanmış konu bulunmuyor.')),
      );
    }

    final maxY =
        _currentNodes.map((n) => n.y).reduce((a, b) => a > b ? a : b) + 80.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bilgilendirme Rozetleri
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            _buildLegendItem('✓ Tamamlandı', GardenPalette.mossEmerald),
            _buildLegendItem('🌱 Çalışılıyor', GardenPalette.harvestGold),
            _buildLegendItem(
                '🔓 Önkoşulu Hazır', GardenPalette.streamTurquoise),
            _buildLegendItem('🔒 Önkoşul Eksik', Colors.grey),
          ],
        ),
        const SizedBox(height: 12),

        // Zoom & Pan Destekli Interactive Canvas
        Container(
          height: 380,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E272E) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black12,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(50),
              minScale: 0.5,
              maxScale: 2.0,
              child: GestureDetector(
                onTapUp: (details) {
                  final tapPos = details.localPosition;
                  for (final node in _currentNodes) {
                    final dist = (Offset(node.x, node.y) - tapPos).distance;
                    if (dist <= 30) {
                      setState(() => _selectedNode = node);
                      break;
                    }
                  }
                },
                child: CustomPaint(
                  size: Size(380, maxY),
                  painter: TopicMapPainter(
                    nodes: _currentNodes,
                    selectedTopicId: _selectedNode?.topicId,
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Seçili Düğüm Alt Bilgi Kartı
        if (_selectedNode != null)
          _buildSelectedNodeCard(_selectedNode!, isDark),
      ],
    );
  }

  Widget _buildSelectedNodeCard(TopicNodeInfo node, bool isDark) {
    return GardenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: GardenPalette.mossEmerald.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  node.stage,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: GardenPalette.mossEmerald,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  node.topicName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                node.status.label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: node.status == TopicStatus.completed
                      ? GardenPalette.mossEmerald
                      : (node.status == TopicStatus.inProgress
                          ? GardenPalette.harvestGold
                          : Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (node.reviewMessage != null) ...[
            Text(
              node.reviewMessage!,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (node.prerequisiteIds.isNotEmpty) ...[
            Text(
              'Önkoşul Konuları: ${node.prerequisiteIds.map(_getTopicNameById).join(', ')}',
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
          ],
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 4,
            children: [
              TextButton(
                onPressed: () =>
                    _updateNodeStatus(node, TopicStatus.notStarted),
                child: const Text('Eksik'),
              ),
              TextButton(
                onPressed: () =>
                    _updateNodeStatus(node, TopicStatus.inProgress),
                child: const Text('Çalışılıyor'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GardenPalette.mossEmerald,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _updateNodeStatus(node, TopicStatus.completed),
                child: const Text('Tamamla ✓'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibleListView(bool isDark) {
    if (_currentNodes.isEmpty) {
      return const Center(child: Text('Konu bulunmuyor.'));
    }

    return Column(
      children: _currentNodes.map((node) {
        final prereqsText = node.prerequisiteIds.isEmpty
            ? 'Temel Başlangıç Konusu (Önkoşulsuz)'
            : 'Önkoşullar: ${node.prerequisiteIds.map(_getTopicNameById).join(', ')}';

        return Semantics(
          label:
              '${node.stage} ${node.topicName}, Durum: ${node.status.label}, $prereqsText',
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF242C35) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: node.status == TopicStatus.completed
                    ? GardenPalette.mossEmerald.withAlpha(120)
                    : (isDark ? Colors.white10 : Colors.black12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  node.status == TopicStatus.completed
                      ? Icons.check_circle
                      : (node.status == TopicStatus.inProgress
                          ? Icons.play_circle_fill
                          : (node.isReady
                              ? Icons.lock_open
                              : Icons.lock_outline)),
                  color: node.status == TopicStatus.completed
                      ? GardenPalette.mossEmerald
                      : (node.status == TopicStatus.inProgress
                          ? GardenPalette.harvestGold
                          : Colors.grey),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${node.stage} • ${node.topicName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        prereqsText,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      if (node.reviewMessage != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          node.reviewMessage!,
                          style: TextStyle(
                            fontSize: 11,
                            color: node.needsReview
                                ? GardenPalette.peachCoral
                                : GardenPalette.mossEmerald,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  tooltip: 'Tamamlandı Olarak İşaretle',
                  onPressed: () =>
                      _updateNodeStatus(node, TopicStatus.completed),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getTopicNameById(String id) {
    final found = _currentNodes.where((n) => n.topicId == id);
    if (found.isNotEmpty) return found.first.topicName;
    return id;
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
