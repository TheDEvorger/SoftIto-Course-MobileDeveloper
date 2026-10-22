import 'package:flutter/material.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/curriculum.dart';
import '../../../domain/models/daily_task.dart';
import '../../../domain/repositories/curriculum_repository.dart';
import '../../../shared/widgets/garden_buttons.dart';

class TaskEntryDialog extends StatefulWidget {
  const TaskEntryDialog({
    this.existingTask,
    this.initialDate,
    this.curriculumRepository,
    super.key,
  });

  final DailyTask? existingTask;
  final DateTime? initialDate;
  final CurriculumRepository? curriculumRepository;

  static Future<DailyTask?> show(
    BuildContext context, {
    DailyTask? existingTask,
    DateTime? initialDate,
    CurriculumRepository? curriculumRepository,
  }) {
    return showDialog<DailyTask>(
      context: context,
      builder: (_) => TaskEntryDialog(
        existingTask: existingTask,
        initialDate: initialDate,
        curriculumRepository: curriculumRepository,
      ),
    );
  }

  @override
  State<TaskEntryDialog> createState() => _TaskEntryDialogState();
}

class _TaskEntryDialogState extends State<TaskEntryDialog> {
  late TextEditingController _descController;
  late TextEditingController _questionsController;
  late DateTime _selectedDate;
  String? _selectedSubjectId;
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    _descController = TextEditingController(text: task?.description ?? '');
    _questionsController = TextEditingController(
      text: task != null && task.targetQuestions > 0
          ? task.targetQuestions.toString()
          : '30',
    );
    _selectedDate = task?.scheduledDate ?? widget.initialDate ?? DateTime.now();
    _selectedSubjectId = task?.subjectId;

    _loadSubjects();
  }

  @override
  void dispose() {
    _descController.dispose();
    _questionsController.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    if (widget.curriculumRepository != null) {
      final tyt = await widget.curriculumRepository!.getSubjects('TYT');
      final ayt = await widget.curriculumRepository!.getSubjects('AYT');
      if (mounted) {
        setState(() {
          _subjects = [...tyt, ...ayt];
        });
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  void _onSave() {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir görev açıklaması yazın.')),
      );
      return;
    }

    final questions = int.tryParse(_questionsController.text.trim()) ?? 0;
    final id = widget.existingTask?.id ??
        'task_${DateTime.now().millisecondsSinceEpoch}';

    final task = DailyTask(
      id: id,
      scheduledDate: _selectedDate,
      description: desc,
      subjectId: _selectedSubjectId,
      targetQuestions: questions,
      isDone: widget.existingTask?.isDone ?? false,
    );

    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.existingTask != null;

    final dateFormatted =
        '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(22),
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: GardenPalette.mossEmerald.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_calendar,
                      color: GardenPalette.mossEmerald,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Görevi Düzenle' : 'Yeni Günlük Hedef',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Adım adım hedefine yaklaş',
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
              const SizedBox(height: 18),

              // Description
              TextField(
                controller: _descController,
                autofocus: !isEdit,
                decoration: InputDecoration(
                  labelText: 'Görev Açıklaması',
                  hintText: 'Örn: Paragraf soru bankası 2 test',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? GardenPalette.nightCard
                      : GardenPalette.gardenPaper.withAlpha(50),
                ),
              ),
              const SizedBox(height: 14),

              // Target Questions & Date Row
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _questionsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Soru Hedefi',
                        hintText: '30',
                        suffixText: 'Soru',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? GardenPalette.nightCard
                            : GardenPalette.gardenPaper.withAlpha(50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text(
                        dateFormatted,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Subject Dropdown (if subjects loaded)
              if (_subjects.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  initialValue: _selectedSubjectId,
                  decoration: InputDecoration(
                    labelText: 'İlgili Ders (İsteğe Bağlı)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? GardenPalette.nightCard
                        : GardenPalette.gardenPaper.withAlpha(50),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Genel Çalışma'),
                    ),
                    ..._subjects.map(
                      (s) => DropdownMenuItem(
                        value: s.id,
                        child: Text('${s.stage} - ${s.name}'),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedSubjectId = val);
                  },
                ),
                const SizedBox(height: 20),
              ] else
                const SizedBox(height: 10),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Vazgeç'),
                  ),
                  const SizedBox(width: 8),
                  GardenPrimaryButton(
                    label: isEdit ? 'Güncelle' : 'Görevi Ekle',
                    icon: Icons.check,
                    width: 140,
                    onPressed: _onSave,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
