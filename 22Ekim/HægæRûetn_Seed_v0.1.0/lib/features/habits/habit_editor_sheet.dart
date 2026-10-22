import 'package:flutter/material.dart';
import '../../core/models/habit.dart';
import '../../core/state/realm_controller.dart';

class HabitEditorSheet extends StatefulWidget {
  const HabitEditorSheet({super.key, required this.controller, this.habit});
  final RealmController controller;
  final Habit? habit;
  @override
  State<HabitEditorSheet> createState() => _HabitEditorSheetState();
}

class _HabitEditorSheetState extends State<HabitEditorSheet> {
  late final TextEditingController title;
  late final TextEditingController description;
  late int difficulty;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.habit?.name ?? '');
    description = TextEditingController(text: widget.habit?.description ?? '');
    difficulty = widget.habit?.difficulty ?? 1;
  }

  @override
  void dispose() {
    title.dispose(); description.dispose(); super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SafeArea(top: false, child: SingleChildScrollView(child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        Text(widget.habit == null ? 'Yeni vazife yaz' : 'Vazifeyi düzenle', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(controller: title, maxLength: 70, autofocus: true, decoration: const InputDecoration(labelText: 'Vazifenin adı', hintText: 'Örn. 20 dakika çalış')),
        const SizedBox(height: 8),
        TextField(controller: description, maxLength: 120, decoration: const InputDecoration(labelText: 'Kısa açıklama (isteğe bağlı)')),
        const SizedBox(height: 12),
        const Text('Zorluk derecesi', style: TextStyle(fontWeight: FontWeight.w800)),
        SegmentedButton<int>(
          segments: const [ButtonSegment(value: 1, label: Text('Kolay')), ButtonSegment(value: 2, label: Text('Orta')), ButtonSegment(value: 3, label: Text('Zorlu'))],
          selected: {difficulty}, onSelectionChanged: (s) => setState(() => difficulty = s.first),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(onPressed: () {
          if (title.text.trim().isEmpty) return;
          if (widget.habit == null) {
            widget.controller.addHabit(title.text, description.text, difficulty);
          } else {
            widget.controller.editHabit(widget.habit!, title.text, description.text, difficulty);
          }
          Navigator.pop(context);
        }, icon: const Icon(Icons.verified_outlined), label: const Text('Mühürle ve kaydet')),
      ]),
    ))),
  );
}
