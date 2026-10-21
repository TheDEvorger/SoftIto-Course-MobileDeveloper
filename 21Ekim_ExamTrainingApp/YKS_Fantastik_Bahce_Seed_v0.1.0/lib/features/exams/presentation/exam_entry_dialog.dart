import 'package:flutter/material.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../domain/exam/net_calculator.dart';
import '../../../domain/models/exam_record.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_inputs.dart';

class SubjectEntryData {
  SubjectEntryData({
    required this.subjectId,
    required this.subjectName,
    required this.questionCount,
    int initialCorrect = 0,
    int initialWrong = 0,
  })  : correctController =
            TextEditingController(text: initialCorrect.toString()),
        wrongController = TextEditingController(text: initialWrong.toString());

  final String subjectId;
  final String subjectName;
  final int questionCount;
  final TextEditingController correctController;
  final TextEditingController wrongController;

  int get correct => int.tryParse(correctController.text) ?? 0;
  int get wrong => int.tryParse(wrongController.text) ?? 0;
  bool get isValid =>
      NetCalculator.fitsExam(
        correct: correct,
        wrong: wrong,
        questionCount: questionCount,
      ) &&
      correct >= 0 &&
      wrong >= 0;

  int get blank =>
      isValid ? (questionCount - correct - wrong).clamp(0, questionCount) : 0;
  double get net =>
      isValid ? NetCalculator.calculate(correct: correct, wrong: wrong) : 0.0;

  void dispose() {
    correctController.dispose();
    wrongController.dispose();
  }
}

class ExamEntryDialog extends StatefulWidget {
  const ExamEntryDialog({
    this.existingSession,
    this.initialStage = 'TYT',
    super.key,
  });

  final ExamSession? existingSession;
  final String initialStage;

  @override
  State<ExamEntryDialog> createState() => _ExamEntryDialogState();
}

class _ExamEntryDialogState extends State<ExamEntryDialog> {
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late String _stage;
  late String _scope; // 'general' or 'branch'
  late List<SubjectEntryData> _subjectEntries;

  @override
  void initState() {
    super.initState();
    final session = widget.existingSession;
    _titleController = TextEditingController(
      text: session?.title ?? '',
    );
    _selectedDate = session?.occurredAt ?? DateTime.now();
    _stage = session?.stage ?? widget.initialStage;
    _scope = session?.scope ?? 'general';

    _initSubjectEntries(session);
  }

  void _initSubjectEntries(ExamSession? session) {
    if (_scope == 'branch') {
      final initialScore = session?.scores.isNotEmpty == true
          ? session!.scores.first
          : null;
      _subjectEntries = [
        SubjectEntryData(
          subjectId: initialScore?.subjectId ??
              (_stage == 'TYT' ? 'tyt_turkce' : 'ayt_mat'),
          subjectName: initialScore?.subjectName ??
              (_stage == 'TYT' ? 'Türkçe' : 'Matematik'),
          questionCount: 40,
          initialCorrect: initialScore?.correct ?? 0,
          initialWrong: initialScore?.wrong ?? 0,
        ),
      ];
    } else {
      // General Exam
      if (_stage == 'TYT') {
        final scoreMap = {
          for (final s in session?.scores ?? <ExamScore>[]) s.subjectId: s,
        };
        _subjectEntries = [
          SubjectEntryData(
            subjectId: 'tyt_turkce',
            subjectName: 'Türkçe',
            questionCount: 40,
            initialCorrect: scoreMap['tyt_turkce']?.correct ?? 0,
            initialWrong: scoreMap['tyt_turkce']?.wrong ?? 0,
          ),
          SubjectEntryData(
            subjectId: 'tyt_mat',
            subjectName: 'Temel Matematik',
            questionCount: 40,
            initialCorrect: scoreMap['tyt_mat']?.correct ?? 0,
            initialWrong: scoreMap['tyt_mat']?.wrong ?? 0,
          ),
          SubjectEntryData(
            subjectId: 'tyt_sosyal',
            subjectName: 'Sosyal Bilimler',
            questionCount: 20,
            initialCorrect: scoreMap['tyt_sosyal']?.correct ?? 0,
            initialWrong: scoreMap['tyt_sosyal']?.wrong ?? 0,
          ),
          SubjectEntryData(
            subjectId: 'tyt_fen',
            subjectName: 'Fen Bilimleri',
            questionCount: 20,
            initialCorrect: scoreMap['tyt_fen']?.correct ?? 0,
            initialWrong: scoreMap['tyt_fen']?.wrong ?? 0,
          ),
        ];
      } else {
        // AYT General (Sayısal + EA ortak ders havuzu)
        final scoreMap = {
          for (final s in session?.scores ?? <ExamScore>[]) s.subjectId: s,
        };
        _subjectEntries = [
          SubjectEntryData(
            subjectId: 'ayt_mat',
            subjectName: 'Matematik',
            questionCount: 40,
            initialCorrect: scoreMap['ayt_mat']?.correct ?? 0,
            initialWrong: scoreMap['ayt_mat']?.wrong ?? 0,
          ),
          SubjectEntryData(
            subjectId: 'ayt_fizik',
            subjectName: 'Fizik',
            questionCount: 14,
            initialCorrect: scoreMap['ayt_fizik']?.correct ?? 0,
            initialWrong: scoreMap['ayt_fizik']?.wrong ?? 0,
          ),
          SubjectEntryData(
            subjectId: 'ayt_kimya',
            subjectName: 'Kimya',
            questionCount: 13,
            initialCorrect: scoreMap['ayt_kimya']?.correct ?? 0,
            initialWrong: scoreMap['ayt_kimya']?.wrong ?? 0,
          ),
          SubjectEntryData(
            subjectId: 'ayt_biyo',
            subjectName: 'Biyoloji',
            questionCount: 13,
            initialCorrect: scoreMap['ayt_biyo']?.correct ?? 0,
            initialWrong: scoreMap['ayt_biyo']?.wrong ?? 0,
          ),
          SubjectEntryData(
            subjectId: 'ayt_edebiyat',
            subjectName: 'Edebiyat',
            questionCount: 24,
            initialCorrect: scoreMap['ayt_edebiyat']?.correct ?? 0,
            initialWrong: scoreMap['ayt_edebiyat']?.wrong ?? 0,
          ),
          SubjectEntryData(
            subjectId: 'ayt_tarih1',
            subjectName: 'Tarih-1',
            questionCount: 10,
            initialCorrect: scoreMap['ayt_tarih1']?.correct ?? 0,
            initialWrong: scoreMap['ayt_tarih1']?.wrong ?? 0,
          ),
          SubjectEntryData(
            subjectId: 'ayt_cografya1',
            subjectName: 'Coğrafya-1',
            questionCount: 6,
            initialCorrect: scoreMap['ayt_cografya1']?.correct ?? 0,
            initialWrong: scoreMap['ayt_cografya1']?.wrong ?? 0,
          ),
        ];
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final e in _subjectEntries) {
      e.dispose();
    }
    super.dispose();
  }

  void _onStageOrScopeChanged(String newStage, String newScope) {
    for (final e in _subjectEntries) {
      e.dispose();
    }
    setState(() {
      _stage = newStage;
      _scope = newScope;
      _initSubjectEntries(null);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  bool get _isAllValid {
    if (_titleController.text.trim().isEmpty) return false;
    for (final e in _subjectEntries) {
      if (!e.isValid) return false;
    }
    return true;
  }

  void _submit() {
    if (!_isAllValid) return;

    final examId = widget.existingSession?.id ??
        'exam_${DateTime.now().millisecondsSinceEpoch}';

    var totalCorrect = 0;
    var totalWrong = 0;
    var totalBlank = 0;
    var totalNet = 0.0;

    final scores = <ExamScore>[];
    for (final e in _subjectEntries) {
      totalCorrect += e.correct;
      totalWrong += e.wrong;
      totalBlank += e.blank;
      totalNet += e.net;

      scores.add(
        ExamScore(
          id: '${examId}_${e.subjectId}',
          examId: examId,
          subjectId: e.subjectId,
          subjectName: e.subjectName,
          correct: e.correct,
          wrong: e.wrong,
          blank: e.blank,
          net: e.net,
        ),
      );
    }

    final session = ExamSession(
      id: examId,
      stage: _stage,
      title: _titleController.text.trim(),
      occurredAt: _selectedDate,
      scope: _scope,
      totalCorrect: totalCorrect,
      totalWrong: totalWrong,
      totalBlank: totalBlank,
      totalNet: double.parse(totalNet.toStringAsFixed(2)),
      scores: scores,
    );

    Navigator.of(context).pop(session);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    var liveTotalCorrect = 0;
    var liveTotalWrong = 0;
    var liveTotalBlank = 0;
    var liveTotalNet = 0.0;
    for (final e in _subjectEntries) {
      if (e.isValid) {
        liveTotalCorrect += e.correct;
        liveTotalWrong += e.wrong;
        liveTotalBlank += e.blank;
        liveTotalNet += e.net;
      }
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor:
          isDark ? GardenPalette.nightCard : GardenPalette.gardenPaper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 680),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: GardenPalette.mossEmerald.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_note,
                        color: GardenPalette.mossEmerald, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.existingSession != null
                          ? 'Denemeyi Düzenle'
                          : 'Yeni Deneme Ekle',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Content List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Title input
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Deneme Adı / Yayın',
                      hintText: 'Örn: Özdebir TYT-1, 3D Türkiye Geneli',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      prefixIcon: const Icon(Icons.bookmark_outline),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),

                  // Stage & Scope Selector
                  Row(
                    children: [
                      Expanded(
                        child: NatureSegmentedControl<String>(
                          items: const {
                            'TYT': 'TYT',
                            'AYT': 'AYT',
                          },
                          selected: _stage,
                          onChanged: (newStage) =>
                              _onStageOrScopeChanged(newStage, _scope),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: NatureSegmentedControl<String>(
                          items: const {
                            'general': 'Genel',
                            'branch': 'Branş',
                          },
                          selected: _scope,
                          onChanged: (newScope) =>
                              _onStageOrScopeChanged(_stage, newScope),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Date button
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withAlpha(100)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_outlined,
                              size: 20, color: GardenPalette.mossEmerald),
                          const SizedBox(width: 10),
                          Text(
                            'Sınav Tarihi: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          const Text('Değiştir',
                              style: TextStyle(
                                  color: GardenPalette.mossEmerald,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Canlı Net Özeti Kartı
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GardenPalette.mossEmerald.withAlpha(30),
                          GardenPalette.streamTurquoise.withAlpha(20),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: GardenPalette.mossEmerald.withAlpha(60),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryColumn('Toplam Net',
                            liveTotalNet.toStringAsFixed(2), GardenPalette.mossEmerald),
                        _buildSummaryColumn('Doğru', '$liveTotalCorrect',
                            GardenPalette.mossEmerald),
                        _buildSummaryColumn('Yanlış', '$liveTotalWrong',
                            GardenPalette.peachCoral),
                        _buildSummaryColumn('Boş', '$liveTotalBlank',
                            Colors.grey.shade600),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Ders Bazlı Sonuçlar (Doğru / Yanlış):',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Subject score rows
                  ..._subjectEntries.map((e) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black12
                            : GardenPalette.sandyPorcelain.withAlpha(140),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: e.isValid
                              ? Colors.grey.withAlpha(40)
                              : Colors.red.withAlpha(120),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.subjectName} (${e.questionCount} Soru)',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                e.isValid
                                    ? 'Net: ${e.net.toStringAsFixed(2)} • Boş: ${e.blank}'
                                    : 'Geçersiz giriş!',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: e.isValid
                                      ? GardenPalette.mossEmerald
                                      : Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: GardenExamScoreField(
                                  controller: e.correctController,
                                  type: ScoreFieldType.correct,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GardenExamScoreField(
                                  controller: e.wrongController,
                                  type: ScoreFieldType.wrong,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Footer actions
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('İptal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GardenPrimaryButton(
                      label: widget.existingSession != null
                          ? 'Güncelle'
                          : 'Kaydet',
                      icon: Icons.check,
                      onPressed: _isAllValid ? _submit : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(String label, String value, Color color) {
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
}
