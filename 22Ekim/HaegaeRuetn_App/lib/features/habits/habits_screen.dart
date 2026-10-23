import 'package:flutter/material.dart';

import '../../core/models/habit.dart';
import '../../core/state/realm_controller.dart';
import '../../core/theme/realm_theme.dart';
import '../../core/widgets/original_kingdom_art.dart';
import '../../core/widgets/ornate_widgets.dart';
import '../../core/widgets/realm_card.dart';
import 'habit_editor_sheet.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key, required this.controller});

  final RealmController controller;

  void openEditor(BuildContext context, [Habit? habit]) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: const Color(0xFFF8F3E8),
        builder: (context) =>
            HabitEditorSheet(controller: controller, habit: habit),
      );

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final era = c.era;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        FancyHeroHeader(
          title: 'Bugünkü Vazifeler',
          subtitle:
              '${era.name} Çağı • ${c.rank} • “Küçük adımlar büyük krallıklar kurar.”',
          assetPath: ArtAssets.habits,
          badge: FramedIconBadge(
            icon: Icons.workspace_premium_outlined,
            label: 'İtibar',
            value: '${c.reputation}/100',
            color: era.primary,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: MiniStatCard(
                label: 'TECRÜBE',
                value: '${c.xp} XP',
                icon: Icons.auto_awesome,
                color: era.secondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MiniStatCard(
                label: 'TAMAM',
                value: '${c.todayCompleted}/${c.activeHabits.length}',
                icon: Icons.task_alt,
                color: const Color(0xFFFFE6B9),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MiniStatCard(
                label: 'ROZET',
                value: '${c.badgeCount}/24',
                icon: Icons.emoji_events_outlined,
                color: const Color(0xFFE9DDFC),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RealmCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Bugünkü seferin',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  RealmPill(
                      label: '%${c.todayPercent} tamamlandı',
                      color: era.secondary),
                ],
              ),
              const SizedBox(height: 13),
              OrnateProgressBar(
                  value: c.todayPercent / 100, color: era.primary),
              const SizedBox(height: 8),
              Text(
                c.activeHabits.isEmpty
                    ? 'Önce vazifelerini belirle, sonra çentik atmaya başla.'
                    : '${c.todayCompleted} / ${c.activeHabits.length} vazife tamamlandı.',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
                child:
                    SectionTitle('Vazifelerim', icon: Icons.edit_note_rounded)),
            OrnateButton(
              label: 'Yeni vazife',
              icon: Icons.add_rounded,
              onPressed: () => openEditor(context),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (c.activeHabits.isEmpty)
          const RealmCard(
              child: Text(
                  'Henüz vazifen yok. Bir alışkanlık belirleyerek ilk fermanı yaz.')),
        ...c.activeHabits.map(
          (habit) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _HabitTile(
              habit: habit,
              controller: c,
              onEdit: () => openEditor(context, habit),
            ),
          ),
        ),
        const SizedBox(height: 12),
        RealmCard(
          color: const Color(0xFFFFF7E1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Planlı İstirahat',
                  icon: Icons.nightlight_round),
              const SizedBox(height: 8),
              const Text(
                  'İrade yalnızca yüklenmek değil, doğru vakitte nefes almaktır.'),
              const SizedBox(height: 12),
              OrnateButton(
                label: c.restDates.contains(c.today)
                    ? 'Bugünkü istirahat mührünü kaldır'
                    : 'Bugünü planlı istirahat olarak işaretle',
                icon: c.restDates.contains(c.today)
                    ? Icons.sunny
                    : Icons.bedtime_outlined,
                expanded: true,
                onPressed: c.toggleRestDay,
              ),
              const SizedBox(height: 8),
              const Text(
                'Planlı istirahat günlerinde itibar cezası uygulanmaz.',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OriginalKingdomArt(
            sky: era.secondary,
            land: era.primary,
            highlight: era.accent,
            height: 165),
      ],
    );
  }
}

class _HabitTile extends StatelessWidget {
  const _HabitTile({
    required this.habit,
    required this.controller,
    required this.onEdit,
  });

  final Habit habit;
  final RealmController controller;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final era = controller.era;
    final done = habit.completedOn(controller.today);
    return OrnateCard(
      color:
          done ? Color.lerp(era.secondary, Colors.white, 0.72)! : Colors.white,
      borderColor: done ? const Color(0xFFD4AF37) : const Color(0xFFDDD2BA),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => controller.toggleHabit(habit),
            borderRadius: BorderRadius.circular(22),
            child: done
                ? const HeraldicSeal(
                    icon: Icons.check_rounded,
                    size: 42,
                    color: Color(0xFF1C6B3F),
                    borderColor: Color(0xFFFFD166),
                  )
                : Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFCFAF4),
                      border: Border.all(
                          color: const Color(0xFFD5C399), width: 1.6),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF4A3816).withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: era.primary.withValues(alpha: 0.45),
                              width: 1.6),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => controller.toggleHabit(habit),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          habit.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.5,
                            decoration:
                                done ? TextDecoration.lineThrough : null,
                            color: done
                                ? const Color(0xFF5B6963)
                                : RealmPalette.ink,
                          ),
                        ),
                      ),
                      if (done)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.verified_rounded,
                              size: 16, color: Color(0xFFD4AF37)),
                        ),
                    ],
                  ),
                  if (habit.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        habit.description,
                        style: const TextStyle(
                            fontSize: 11.5, color: Color(0xFF6B6559)),
                      ),
                    ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 7,
                    runSpacing: 5,
                    children: [
                      RealmPill(
                        label: '+${12 + habit.difficulty * 6} XP',
                        icon: Icons.bolt_rounded,
                        color: era.secondary,
                      ),
                      RealmPill(
                        label: [
                          '?',
                          'Kolay',
                          'Orta',
                          'Zorlu'
                        ][habit.difficulty],
                        icon: Icons.flag_outlined,
                        color: const Color(0xFFFFE8C7),
                      ),
                      if (habit.completedDates.isNotEmpty)
                        RealmPill(
                          label: '${habit.completedDates.length} Mühür',
                          icon: Icons.history_edu_rounded,
                          color: const Color(0xFFE9F4EE),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Vazife seçenekleri',
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Düzenle')),
              PopupMenuItem(value: 'archive', child: Text('Arşivle')),
            ],
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'archive') controller.archiveHabit(habit);
            },
          ),
        ],
      ),
    );
  }
}
