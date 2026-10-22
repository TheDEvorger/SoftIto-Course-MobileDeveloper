import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/exam/net_calculator.dart';
import '../../../domain/models/exam_record.dart';
import '../../../domain/repositories/exam_repository.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/garden_inputs.dart';
import '../../../shared/widgets/seed_notice.dart';
import 'exam_entry_dialog.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({this.repository, super.key});

  final ExamRepository? repository;

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  final correctController = TextEditingController(text: '30');
  final wrongController = TextEditingController(text: '8');
  final quickQuestionCountController = TextEditingController(text: '40');
  final quickTitleController =
      TextEditingController(text: 'Hızlı Branş Denemesi');

  String stage = 'TYT';
  ExamRepository? _repo;
  List<ExamSession> _exams = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initRepo();
  }

  @override
  void dispose() {
    correctController.dispose();
    wrongController.dispose();
    quickQuestionCountController.dispose();
    quickTitleController.dispose();
    super.dispose();
  }

  Future<void> _initRepo() async {
    try {
      if (widget.repository != null) {
        _repo = widget.repository;
      } else {
        final db = await GardenDatabaseProvider.instance.database;
        _repo = ExamRepository(db);
      }
      await _loadExams();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadExams() async {
    if (_repo == null) return;
    setState(() => _loading = true);
    final exams = await _repo!.getExams(stage: stage);
    if (mounted) {
      setState(() {
        _exams = exams;
        _loading = false;
      });
    }
  }

  Future<void> _openAddExam() async {
    final result = await showDialog<ExamSession>(
      context: context,
      builder: (_) => ExamEntryDialog(initialStage: stage),
    );

    if (result != null && _repo != null) {
      await _repo!.saveExam(result);
      await _loadExams();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🌿 "${result.title}" denemesi kaydedildi!'),
            backgroundColor: GardenPalette.mossEmerald,
          ),
        );
      }
    }
  }

  Future<void> _openEditExam(ExamSession exam) async {
    final result = await showDialog<ExamSession>(
      context: context,
      builder: (_) => ExamEntryDialog(
        existingSession: exam,
        initialStage: exam.stage,
      ),
    );

    if (result != null && _repo != null) {
      await _repo!.saveExam(result);
      await _loadExams();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✨ "${result.title}" güncellendi.'),
            backgroundColor: GardenPalette.mossEmerald,
          ),
        );
      }
    }
  }

  Future<void> _confirmDeleteExam(ExamSession exam) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Denemeyi Sil'),
        content: Text(
          '"${exam.title}" denemesini silmek istediğine emin misin? Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && _repo != null) {
      await _repo!.deleteExam(exam.id);
      await _loadExams();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deneme silindi.')),
        );
      }
    }
  }

  Future<void> _saveQuickExam(double net, int correct, int wrong) async {
    if (_repo == null) return;
    final qCount = int.tryParse(quickQuestionCountController.text) ?? 40;
    final blank = (qCount - correct - wrong).clamp(0, qCount);
    final title = quickTitleController.text.trim().isNotEmpty
        ? quickTitleController.text.trim()
        : 'Hızlı $stage Denemesi';

    final examId = 'quick_${DateTime.now().millisecondsSinceEpoch}';
    final session = ExamSession(
      id: examId,
      stage: stage,
      title: title,
      occurredAt: DateTime.now(),
      scope: 'branch',
      totalCorrect: correct,
      totalWrong: wrong,
      totalBlank: blank,
      totalNet: double.parse(net.toStringAsFixed(2)),
      scores: [
        ExamScore(
          id: '${examId}_score',
          examId: examId,
          subjectId: stage == 'TYT' ? 'tyt_hizli' : 'ayt_hizli',
          subjectName: '$stage Hızlı Branş',
          correct: correct,
          wrong: wrong,
          blank: blank,
          net: net,
        ),
      ],
    );

    await _repo!.saveExam(session);
    await _loadExams();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🌸 "$title" başarıyla eklendi!'),
          backgroundColor: GardenPalette.mossEmerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final correct = int.tryParse(correctController.text);
    final wrong = int.tryParse(wrongController.text);
    final questionCount = int.tryParse(quickQuestionCountController.text) ?? 40;
    final isValid = correct != null &&
        wrong != null &&
        NetCalculator.fitsExam(
          correct: correct,
          wrong: wrong,
          questionCount: questionCount,
        );
    final net = isValid
        ? NetCalculator.calculate(correct: correct, wrong: wrong)
        : null;
    final blank = isValid ? questionCount - correct - wrong : null;

    // Exam statistics
    final examCount = _exams.length;
    final maxNet = _exams.isNotEmpty
        ? _exams.map((e) => e.totalNet).reduce((a, b) => a > b ? a : b)
        : 0.0;
    final avgNet = _exams.isNotEmpty
        ? _exams.map((e) => e.totalNet).reduce((a, b) => a + b) / examCount
        : 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ForestHeroCard(
          assetPath: GardenScenes.river,
          tag: '📝 Deneme ve Netler',
          title: 'Deneme Takip Masası',
          subtitle: 'Her net, hedefine doğru akan berrak bir su gibi.',
          height: 190,
        ),
        const SizedBox(height: 12),
        const SeedNotice(),
        const SizedBox(height: 12),

        // Stage selector
        NatureSegmentedControl<String>(
          items: const {
            'TYT': 'TYT Denemeleri',
            'AYT': 'AYT Denemeleri',
          },
          selected: stage,
          onChanged: (newStage) {
            setState(() => stage = newStage);
            _loadExams();
          },
        ),
        const SizedBox(height: 16),

        // Add exam primary button
        GoldenActionButton(
          label: 'Yeni $stage Denemesi Ekle',
          icon: Icons.add_circle_outline,
          onPressed: _openAddExam,
        ),
        const SizedBox(height: 16),

        // Statistics overview card
        if (examCount > 0)
          GardenCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Kayıtlı Deneme', '$examCount Adet',
                    GardenPalette.mossEmerald),
                _buildStat('Ortalama Net', avgNet.toStringAsFixed(2),
                    GardenPalette.streamTurquoise),
                _buildStat('En Yüksek Net', maxNet.toStringAsFixed(2),
                    GardenPalette.harvestGold),
              ],
            ),
          ),
        if (examCount > 0) const SizedBox(height: 16),

        // Section header
        BotanicalSectionHeader(
          title: '$stage Deneme Geçmişi',
          subtitle: '$examCount deneme kaydı listeleniyor',
          icon: Icons.history_edu_outlined,
        ),
        const SizedBox(height: 8),

        // Exam list or empty state
        if (_loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_exams.isEmpty)
          GardenCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  Icon(
                    Icons.park_outlined,
                    size: 48,
                    color: GardenPalette.mossEmerald.withAlpha(150),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Henüz Kayıtlı $stage Denemen Yok',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'İlk denemeni ekle; netlerinin berrak sular gibi adım adım yükselişini izle.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  GardenPrimaryButton(
                    label: 'İlk Denemeni Ekle',
                    icon: Icons.add,
                    onPressed: _openAddExam,
                  ),
                ],
              ),
            ),
          )
        else
          ..._exams.map((exam) => _buildExamCard(exam, isDark)),

        const SizedBox(height: 20),

        // Quick calculator header & card
        const BotanicalSectionHeader(
          title: 'Hızlı Net Hesaplayıcı',
          subtitle: 'Tek bir test veya branş netini anında hesapla ve kaydet',
          icon: Icons.calculate_outlined,
        ),
        const SizedBox(height: 8),
        GardenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: quickTitleController,
                decoration: InputDecoration(
                  labelText: 'Branş / Deneme Başlığı',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quickQuestionCountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Soru Sayısı',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GardenExamScoreField(
                      controller: correctController,
                      type: ScoreFieldType.correct,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GardenExamScoreField(
                      controller: wrongController,
                      type: ScoreFieldType.wrong,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (net == null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '0 veya pozitif sayı gir; doğru + yanlış en fazla $questionCount olabilir.',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: GardenPalette.mossEmerald.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: GardenPalette.mossEmerald.withAlpha(60),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Net: ${net.toStringAsFixed(2)}  •  Boş: $blank',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: GardenPalette.inkPlum,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: GardenPalette.mossEmerald,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Doğru Formül',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              GardenPrimaryButton(
                label: 'Bu Neti Denemelerime Ekle',
                icon: Icons.save_outlined,
                onPressed: net != null
                    ? () => _saveQuickExam(net, correct!, wrong!)
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const WaterInfoCard(
          title: 'Resmî YKS Net Formülü',
          message:
              'Net = Doğru - (Yanlış / 4). Her 4 yanlış 1 doğruyu götürür. Denemelerin yerel SQLite veri tabanında güvenle saklanır.',
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildExamCard(ExamSession exam, bool isDark) {
    final dateStr =
        '${exam.occurredAt.day}.${exam.occurredAt.month}.${exam.occurredAt.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GardenCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: exam.scope == 'branch'
                                  ? GardenPalette.peachCoral.withAlpha(35)
                                  : GardenPalette.mossEmerald.withAlpha(35),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              exam.scope == 'branch' ? 'Branş' : 'Genel',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: exam.scope == 'branch'
                                    ? GardenPalette.peachCoral
                                    : GardenPalette.mossEmerald,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateStr,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        exam.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Toplam Net Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        GardenPalette.mossEmerald,
                        GardenPalette.streamTurquoise,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: GardenPalette.mossEmerald.withAlpha(60),
                        offset: const Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        exam.totalNet.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Net',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Scores overview
            Row(
              children: [
                Text(
                  '${exam.totalCorrect} Doğru • ${exam.totalWrong} Yanlış • ${exam.totalBlank} Boş',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Düzenle',
                  color: GardenPalette.mossEmerald,
                  onPressed: () => _openEditExam(exam),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  tooltip: 'Sil',
                  color: Colors.redAccent,
                  onPressed: () => _confirmDeleteExam(exam),
                ),
              ],
            ),

            // Ders bazlı skor dökümü
            if (exam.scores.isNotEmpty) ...[
              const Divider(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: exam.scores.map((s) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white10
                          : GardenPalette.sandyPorcelain,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withAlpha(40)),
                    ),
                    child: Text(
                      '${s.subjectName}: ${s.net.toStringAsFixed(1)}N (${s.correct}D ${s.wrong}Y)',
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
