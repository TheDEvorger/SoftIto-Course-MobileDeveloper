import 'package:flutter/material.dart';

import '../../core/models/pact.dart';
import '../../core/state/realm_controller.dart';
import '../../core/widgets/ornate_widgets.dart';
import '../../core/widgets/realm_card.dart';

class PactsScreen extends StatelessWidget {
  const PactsScreen({super.key, required this.controller});

  final RealmController controller;

  @override
  Widget build(BuildContext context) {
    final age = controller.era;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        FancyHeroHeader(
          title: 'Ahit Defteri',
          subtitle:
              'Bir söz, bir yol, biraz da mürekkep. “Küçük sözler büyük yolculuklar başlatır.”',
          assetPath: ArtAssets.pacts,
          badge: FramedIconBadge(
            icon: Icons.history_edu_outlined,
            label: 'Kayıt',
            value: '${controller.pacts.length}',
            color: age.primary,
          ),
        ),
        const SizedBox(height: 16),
        RealmCard(
          color: age.secondary.withValues(alpha: .42),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Yeni Ahit', icon: Icons.gavel_rounded),
              const SizedBox(height: 8),
              const Text(
                'Bir veya birkaç vazife seç. Hedefin kadar farklı günde hepsini aynı gün tamamla. Ardışık gün şartı yok.',
              ),
              const SizedBox(height: 14),
              OrnateButton(
                label: 'Yeni ahit yaz',
                icon: Icons.add_rounded,
                expanded: true,
                onPressed: controller.activeHabits.isEmpty
                    ? null
                    : () => showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          backgroundColor: const Color(0xFFF8F3E8),
                          builder: (_) => _PactEditor(controller: controller),
                        ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
                child: SectionTitle('Mühürlü Ahitler',
                    icon: Icons.shield_moon_outlined)),
            RealmPill(label: '${controller.pacts.length} kayıt'),
          ],
        ),
        const SizedBox(height: 10),
        if (controller.pacts.isEmpty)
          const RealmCard(
              child: Text(
                  'Ahit defteri henüz boş. İlk anlaşmanı yaz ve yolun taşlarını döşe.')),
        ...controller.pacts.reversed.map(
          (pact) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _PactCard(controller: controller, pact: pact),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Ahitler cihazında saklanır. Tamamlanan anlaşmalar bir defa XP kazandırır.',
          style: TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
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
    final completion = (progress / pact.goalDays).clamp(0.0, 1.0);

    return RealmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            pact.habitIds
                .map((id) => byId[id] ?? 'Arşivlenen vazife')
                .join(' • '),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          OrnateProgressBar(value: completion, color: color),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: Text(
                  pact.isCompleted
                      ? 'Ahit başarıyla tamamlandı!'
                      : '$progress / ${pact.goalDays} uyumlu gün',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
              Text('+${90 + pact.goalDays * 10} XP',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              RealmPill(
                  label: '${pact.goalDays} gün hedefi',
                  icon: Icons.calendar_month_outlined,
                  color: controller.era.secondary),
              const RealmPill(
                  label: '+8 İtibar',
                  icon: Icons.workspace_premium_outlined,
                  color: Color(0xFFFFEBC0)),
            ],
          ),
        ],
      ),
    );
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
  Widget build(BuildContext context) {
    return Padding(
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
                      hintText: 'Örn. Bilginin Seferi'),
                ),
                const SizedBox(height: 8),
                const Text('Ahde bağlı vazifeler',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                ...widget.controller.activeHabits.map(
                  (habit) => CheckboxListTile(
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
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Hedef gün sayısı',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [3, 7, 14, 30].map((value) {
                    return ChoiceChip(
                      label: Text('$value gün'),
                      selected: days == value,
                      onSelected: (_) => setState(() => days = value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                OrnateButton(
                  label: 'Ahdi mühürle',
                  icon: Icons.verified_outlined,
                  expanded: true,
                  onPressed: selected.isEmpty
                      ? null
                      : () {
                          if (title.text.trim().isEmpty) return;
                          widget.controller
                              .addPact(title.text, selected.toList(), days);
                          Navigator.pop(context);
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
