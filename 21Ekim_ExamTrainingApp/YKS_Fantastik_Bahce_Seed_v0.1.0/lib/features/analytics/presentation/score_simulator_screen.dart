import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/score_simulation.dart';
import '../../../domain/repositories/exam_repository.dart';
import '../../../domain/services/score_simulator.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/seed_notice.dart';

class ScoreSimulatorScreen extends StatefulWidget {
  const ScoreSimulatorScreen({
    super.key,
    this.examRepository,
    this.simulator = const ScoreSimulator(),
  });

  final ExamRepository? examRepository;
  final ScoreSimulator simulator;

  @override
  State<ScoreSimulatorScreen> createState() => _ScoreSimulatorScreenState();
}

class _ScoreSimulatorScreenState extends State<ScoreSimulatorScreen> {
  ExamRepository? _examRepo;
  SimulationInput _input = const SimulationInput(
    field: SimulationField.sayisal,
    tytTurkce: 28.0,
    tytMatematik: 25.0,
    tytSosyal: 13.0,
    tytFen: 12.0,
    aytMatematik: 22.0,
    aytFizik: 8.0,
    aytKimya: 7.0,
    aytBiyoloji: 8.0,
    diplomaGrade: 85.0,
  );

  @override
  void initState() {
    super.initState();
    _initRepo();
  }

  Future<void> _initRepo() async {
    try {
      if (widget.examRepository != null) {
        _examRepo = widget.examRepository;
      } else {
        final db = await GardenDatabaseProvider.instance.database;
        _examRepo = ExamRepository(db);
      }
    } catch (_) {}
  }

  Future<void> _loadLatestExamNets() async {
    if (_examRepo == null) return;

    final tytExams = await _examRepo!.getExams(stage: 'TYT');
    final aytExams = await _examRepo!.getExams(stage: 'AYT');

    double tytTurkce = _input.tytTurkce;
    double tytMat = _input.tytMatematik;
    double tytSos = _input.tytSosyal;
    double tytFen = _input.tytFen;

    if (tytExams.isNotEmpty) {
      final latestTyt = tytExams.first;
      for (final sub in latestTyt.scores) {
        final net = sub.net;
        final name = sub.subjectName.toLowerCase();
        if (name.contains('türkçe')) tytTurkce = net;
        if (name.contains('matematik')) tytMat = net;
        if (name.contains('sosyal')) tytSos = net;
        if (name.contains('fen')) tytFen = net;
      }
    }

    double aytMat = _input.aytMatematik;
    double aytFiz = _input.aytFizik;
    double aytKim = _input.aytKimya;
    double aytBio = _input.aytBiyoloji;
    double aytEdb = _input.aytEdebiyat;
    double aytTar = _input.aytTarih1;
    double aytCog = _input.aytCografya1;

    if (aytExams.isNotEmpty) {
      final latestAyt = aytExams.first;
      for (final sub in latestAyt.scores) {
        final net = sub.net;
        final name = sub.subjectName.toLowerCase();
        if (name.contains('matematik')) aytMat = net;
        if (name.contains('fizik')) aytFiz = net;
        if (name.contains('kimya')) aytKim = net;
        if (name.contains('biyoloji')) aytBio = net;
        if (name.contains('edebiyat')) aytEdb = net;
        if (name.contains('tarih')) aytTar = net;
        if (name.contains('coğrafya')) aytCog = net;
      }
    }

    setState(() {
      _input = _input.copyWith(
        tytTurkce: tytTurkce,
        tytMatematik: tytMat,
        tytSosyal: tytSos,
        tytFen: tytFen,
        aytMatematik: aytMat,
        aytFizik: aytFiz,
        aytKimya: aytKim,
        aytBiyoloji: aytBio,
        aytEdebiyat: aytEdb,
        aytTarih1: aytTar,
        aytCografya1: aytCog,
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚡ Son denemelerindeki netler simülatöre yüklendi.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result = widget.simulator.simulate(_input);

    return Scaffold(
      appBar: AppBar(
        title: const Text('YKS Puan & Sıralama Simülatörü'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          ForestHeroCard(
            assetPath: GardenScenes.rainbow,
            tag: '🎯 YKS ${ScoreSimulator.curriculumYear} Puan Tahmini',
            title: 'Puan & OBP Simülatörü',
            subtitle:
                'ÖSYM kılavuz ağırlıklarına dayalı yerleştirme ve ham puan tahmini.',
            height: 200,
            actionLabel: 'Denemelerimden Yükle ⚡',
            onAction: _loadLatestExamNets,
          ),
          const SizedBox(height: 12),
          const SeedNotice(),
          const SizedBox(height: 12),

          // Yasal ve Metodoloji Sınırlılık Uyarısı
          WaterInfoCard(
            title: 'Resmî Sınav Bilgilendirmesi',
            message: result.disclaimer,
          ),
          const SizedBox(height: 16),

          // Canlı Sonuç Kartı
          GoldenAchievementCard(
            title:
                'Yerleştirme Puanı: ${result.placementScore.toStringAsFixed(2)}',
            subtitle:
                '${result.field.title} Ham: ${result.fieldRawScore.toStringAsFixed(2)} • TYT Ham: ${result.tytScore.toStringAsFixed(2)}',
            badgeText: '+${result.obpContribution.toStringAsFixed(1)} OBP',
            icon: Icons.auto_awesome,
          ),
          const SizedBox(height: 16),

          // Alan Seçici
          const BotanicalSectionHeader(
            title: 'Hedef Puan Türü',
            subtitle: 'Hesaplanacak YKS alanını seç',
            icon: Icons.category_outlined,
          ),
          NatureSegmentedControl<SimulationField>(
            items: const {
              SimulationField.sayisal: 'Sayısal',
              SimulationField.esitAgirlik: 'Eşit Ağırlık',
              SimulationField.sozel: 'Sözel',
              SimulationField.tytOnly: 'TYT',
            },
            selected: _input.field,
            onChanged: (field) =>
                setState(() => _input = _input.copyWith(field: field)),
          ),
          const SizedBox(height: 16),

          // OBP ve Diploma Notu Ayarları
          _buildObpCard(isDark, result),
          const SizedBox(height: 16),

          // TYT Netleri Bölümü
          BotanicalSectionHeader(
            title:
                'TYT Netleri (Toplam: ${_input.totalTytNet.toStringAsFixed(1)} Net)',
            subtitle: '120 Soru Üzerinden Net Dağılımı',
            icon: Icons.checklist_outlined,
          ),
          GardenCard(
            child: Column(
              children: [
                _buildNetSlider('Türkçe (40 Soru)', _input.tytTurkce, 40.0,
                    (v) {
                  setState(() => _input = _input.copyWith(tytTurkce: v));
                }),
                const Divider(),
                _buildNetSlider(
                    'Temel Matematik (40 Soru)', _input.tytMatematik, 40.0,
                    (v) {
                  setState(() => _input = _input.copyWith(tytMatematik: v));
                }),
                const Divider(),
                _buildNetSlider(
                    'Sosyal Bilimler (20 Soru)', _input.tytSosyal, 20.0, (v) {
                  setState(() => _input = _input.copyWith(tytSosyal: v));
                }),
                const Divider(),
                _buildNetSlider('Fen Bilimleri (20 Soru)', _input.tytFen, 20.0,
                    (v) {
                  setState(() => _input = _input.copyWith(tytFen: v));
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // AYT Netleri (Seçili Alana Göre)
          if (_input.field != SimulationField.tytOnly) ...[
            BotanicalSectionHeader(
              title: 'AYT Netleri (${_input.field.title})',
              subtitle: 'Alanına Özel Soru Grupları',
              icon: Icons.assignment_outlined,
            ),
            _buildAytInputsCard(),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildObpCard(bool isDark, SimulationResult result) {
    return GardenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🎓 Diploma Notu (OBP)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                '${_input.diplomaGrade.toStringAsFixed(1)} / 100',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: GardenPalette.mossEmerald,
                ),
              ),
            ],
          ),
          Slider(
            value: _input.diplomaGrade,
            min: 50.0,
            max: 100.0,
            divisions: 50,
            activeColor: GardenPalette.mossEmerald,
            onChanged: (val) =>
                setState(() => _input = _input.copyWith(diplomaGrade: val)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'OBP Puanı: ${result.obpScore.toStringAsFixed(1)} (Katkı: +${result.obpContribution.toStringAsFixed(1)})',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Önceki yıl yerleştim (Kırık OBP)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'OBP katsayısı 0.12 yerine 0.06 olarak yarıya iner.',
              style: TextStyle(fontSize: 11),
            ),
            value: _input.isPreviousYearPlaced,
            activeTrackColor: GardenPalette.mossEmerald,
            onChanged: (val) => setState(
                () => _input = _input.copyWith(isPreviousYearPlaced: val)),
          ),
        ],
      ),
    );
  }

  Widget _buildAytInputsCard() {
    switch (_input.field) {
      case SimulationField.sayisal:
        return GardenCard(
          child: Column(
            children: [
              _buildNetSlider(
                  'AYT Matematik (40 Soru)', _input.aytMatematik, 40.0, (v) {
                setState(() => _input = _input.copyWith(aytMatematik: v));
              }),
              const Divider(),
              _buildNetSlider('Fizik (14 Soru)', _input.aytFizik, 14.0, (v) {
                setState(() => _input = _input.copyWith(aytFizik: v));
              }),
              const Divider(),
              _buildNetSlider('Kimya (13 Soru)', _input.aytKimya, 13.0, (v) {
                setState(() => _input = _input.copyWith(aytKimya: v));
              }),
              const Divider(),
              _buildNetSlider('Biyoloji (13 Soru)', _input.aytBiyoloji, 13.0,
                  (v) {
                setState(() => _input = _input.copyWith(aytBiyoloji: v));
              }),
            ],
          ),
        );

      case SimulationField.esitAgirlik:
        return GardenCard(
          child: Column(
            children: [
              _buildNetSlider(
                  'AYT Matematik (40 Soru)', _input.aytMatematik, 40.0, (v) {
                setState(() => _input = _input.copyWith(aytMatematik: v));
              }),
              const Divider(),
              _buildNetSlider(
                  'Türk Dili ve Edb. (24 Soru)', _input.aytEdebiyat, 24.0, (v) {
                setState(() => _input = _input.copyWith(aytEdebiyat: v));
              }),
              const Divider(),
              _buildNetSlider('Tarih-1 (10 Soru)', _input.aytTarih1, 10.0, (v) {
                setState(() => _input = _input.copyWith(aytTarih1: v));
              }),
              const Divider(),
              _buildNetSlider('Coğrafya-1 (6 Soru)', _input.aytCografya1, 6.0,
                  (v) {
                setState(() => _input = _input.copyWith(aytCografya1: v));
              }),
            ],
          ),
        );

      case SimulationField.sozel:
        return GardenCard(
          child: Column(
            children: [
              _buildNetSlider(
                  'Türk Dili ve Edb. (24 Soru)', _input.aytEdebiyat, 24.0, (v) {
                setState(() => _input = _input.copyWith(aytEdebiyat: v));
              }),
              const Divider(),
              _buildNetSlider('Tarih-1 (10 Soru)', _input.aytTarih1, 10.0, (v) {
                setState(() => _input = _input.copyWith(aytTarih1: v));
              }),
              const Divider(),
              _buildNetSlider('Coğrafya-1 (6 Soru)', _input.aytCografya1, 6.0,
                  (v) {
                setState(() => _input = _input.copyWith(aytCografya1: v));
              }),
            ],
          ),
        );

      case SimulationField.tytOnly:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNetSlider(
    String label,
    double value,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(
              '${value.toStringAsFixed(1)} Net',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: GardenPalette.mossEmerald,
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(0.0, max),
          min: 0.0,
          max: max,
          divisions: (max * 4).toInt(), // 0.25'lik adımlar
          activeColor: GardenPalette.mossEmerald,
          onChanged: (v) => onChanged((v * 4).round() / 4),
        ),
      ],
    );
  }
}
