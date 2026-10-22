import 'package:flutter/material.dart';
import '../../core/models/pact.dart';
import '../../core/state/realm_controller.dart';
import '../../core/widgets/realm_card.dart';

class PactsScreen extends StatelessWidget {
  const PactsScreen({super.key, required this.controller});
  final RealmController controller;

  @override
  Widget build(BuildContext context) {
    final age = controller.era;
    return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Ahit Defteri',
              style: Theme.of(context).textTheme.headlineMedium),
          const Text('Bir söz, bir yol, biraz da mürekkep.',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          RealmCard(
              color: age.secondary.withValues(alpha: .65),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.history_edu, color: age.primary, size: 37),
                    const SizedBox(height: 8),
                    const Text('Kendi ahdini mühürle',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    const Text(
                        'Bir veya birkaç vazife seç. Hedefin kadar farklı gün, hepsini aynı gün tamamla. Ardışık gün şartı yok.'),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                        onPressed: controller.activeHabits.isEmpty
                            ? null
                            : () => showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  showDragHandle: true,
                                  builder: (_) =>
                                      _PactEditor(controller: controller),
                                ),
                        icon: const Icon(Icons.add),
                        label: const Text('Yeni ahit yaz')),
                  ])),
          const SizedBox(height: 20),
          SectionTitle('Mühürlü ahitler',
              trailing: RealmPill(label: '${controller.pacts.length} kayıt')),
          const SizedBox(height: 10),
          if (controller.pacts.isEmpty)
            const RealmCard(
                child: Text(
                    'Ahit defteri henüz boş. İlk anlaşmanı yaz ve yolun taşlarını döşe.')),
          ...controller.pacts.reversed.map((pact) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PactCard(controller: controller, pact: pact),
              )),
          const SizedBox(height: 12),
          const Text(
              'Ahitler cihazında saklanır. Tamamlanan anlaşmalar bir defa XP kazandırır.',
              style: TextStyle(fontSize: 11, color: Colors.black54)),
        ]);
  }
}

class _PactCard extends StatelessWidget {
  const _PactCard({required this.controller, required this.pact});
  final RealmController controller;
  final Pact pact;
  @override
  Widget build(BuildContext context) {
    final progress = controller.pactProgress(pact);
    final color = controller.era.primary;
    final byId = {for (final habit in controller.habits) habit.id: habit.name};
    return RealmCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
            child: Text(pact.title,
                style: Theme.of(context).textTheme.titleLarge)),
        if (pact.isCompleted)
          const Icon(Icons.verified, color: Color(0xFF278258)),
        PopupMenuButton<String>(
            tooltip: 'Ahit seçenekleri',
            onSelected: (value) {
              if (value == 'remove') controller.removePact(pact);
            },
            itemBuilder: (_) => const [
                  PopupMenuItem(value: 'remove', child: Text('Ahdi kaldır'))
                ]),
      ]),
      Text(
          pact.habitIds
              .map((id) => byId[id] ?? 'Arşivlenen vazife')
              .join(' • '),
          style: const TextStyle(fontSize: 12, color: Colors.black54)),
      const SizedBox(height: 15),
      ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress / pact.goalDays,
            minHeight: 9,
            backgroundColor: const Color(0xFFE9E7E1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          )),
      const SizedBox(height: 9),
      Row(children: [
        Expanded(
            child: Text(
                pact.isCompleted
                    ? 'Ahit başarıyla tamamlandı!'
                    : '$progress / ${pact.goalDays} uyumlu gün',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w800, fontSize: 12))),
        Text('+${90 + pact.goalDays * 10} XP',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
    ]));
  }
}

class _PactEditor extends StatefulWidget {
  const _PactEditor({required this.controller});
  final RealmController controller;
  @override
  State<_PactEditor> createState() => _PactEditorState();
}

class _PactEditorState extends State<_PactEditor> {
  final title = TextEditingController();
  final selected = <String>{};
  int days = 7;

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SafeArea(
            top: false,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Yeni Ahit',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 15),
                    TextField(
                        controller: title,
                        maxLength: 60,
                        decoration: const InputDecoration(
                            labelText: 'Ahde bir isim ver',
                            hintText: 'Örn. Bilginin Seferi')),
                    const SizedBox(height: 8),
                    const Text('Ahde bağlı vazifeler',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    ...widget.controller.activeHabits
                        .map((habit) => CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(habit.name),
                              value: selected.contains(habit.id),
                              onChanged: (checked) => setState(() {
                                if (checked ?? false) {
                                  selected.add(habit.id);
                                } else {
                                  selected.remove(habit.id);
                                }
                              }),
                            )),
                    const SizedBox(height: 8),
                    const Text('Hedef gün sayısı',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    Wrap(
                        spacing: 6,
                        children: [3, 7, 14, 30]
                            .map((value) => ChoiceChip(
                                  label: Text('$value gün'),
                                  selected: days == value,
                                  onSelected: (_) =>
                                      setState(() => days = value),
                                ))
                            .toList()),
                    const SizedBox(height: 15),
                    FilledButton.icon(
                        onPressed: selected.isEmpty
                            ? null
                            : () {
                                if (title.text.trim().isEmpty) return;
                                widget.controller.addPact(
                                    title.text, selected.toList(), days);
                                Navigator.pop(context);
                              },
                        icon: const Icon(Icons.verified_outlined),
                        label: const Text('Ahdi mühürle')),
                  ]),
            ))),
      );
}
