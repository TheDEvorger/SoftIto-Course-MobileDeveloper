import 'package:flutter/material.dart';
import '../../core/models/habit.dart';
import '../../core/state/realm_controller.dart';
import '../../core/widgets/original_kingdom_art.dart';
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
        builder: (context) =>
            HabitEditorSheet(controller: controller, habit: habit),
      );

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final age = c.era;
    return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Stack(children: [
            OriginalKingdomArt(
                sky: age.secondary, land: age.primary, highlight: age.accent),
            Positioned(
                top: 16,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .83),
                      borderRadius: BorderRadius.circular(14)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ÇAĞ ${((c.level - 1) ~/ 4) + 1} / 6',
                            style: TextStyle(
                                color: age.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                        Text('${age.name} Çağı',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 19)),
                        Text(c.rank, style: const TextStyle(fontSize: 12)),
                      ]),
                )),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: _Metric(
                    label: 'TECRÜBE',
                    value: '${c.xp} XP',
                    icon: Icons.auto_awesome,
                    color: age.secondary)),
            const SizedBox(width: 8),
            Expanded(
                child: _Metric(
                    label: 'İTİBAR',
                    value: '${c.reputation}/100',
                    icon: Icons.workspace_premium,
                    color: const Color(0xFFFFE3BC))),
            const SizedBox(width: 8),
            Expanded(
                child: _Metric(
                    label: 'ROZET',
                    value: '${c.badgeCount}/24',
                    icon: Icons.emoji_events_outlined,
                    color: const Color(0xFFE1D8FF))),
          ]),
          const SizedBox(height: 18),
          RealmCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Expanded(
                      child: Text('Bugünkü seferin',
                          style: Theme.of(context).textTheme.titleLarge)),
                  RealmPill(
                      label: '%${c.todayPercent} tamamlandı',
                      color: age.secondary),
                ]),
                const SizedBox(height: 13),
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      minHeight: 11,
                      value: c.todayPercent / 100,
                      backgroundColor: const Color(0xFFECE9E0),
                      valueColor: AlwaysStoppedAnimation<Color>(age.primary),
                    )),
                const SizedBox(height: 8),
                Text('${c.todayCompleted} / ${c.activeHabits.length} vazife',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
              ])),
          const SizedBox(height: 20),
          SectionTitle('Vazifelerim',
              trailing: IconButton.filledTonal(
                tooltip: 'Yeni alışkanlık ekle',
                onPressed: () => openEditor(context),
                icon: const Icon(Icons.add),
              )),
          const SizedBox(height: 10),
          if (c.activeHabits.isEmpty)
            const RealmCard(
                child: Text(
                    'Henüz vazifen yok. Bir alışkanlık belirleyerek ilk fermanı yaz.')),
          ...c.activeHabits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: RealmCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 12),
                    child: Row(children: [
                      Checkbox(
                          value: habit.completedOn(c.today),
                          activeColor: age.primary,
                          onChanged: (_) => c.toggleHabit(habit)),
                      Expanded(
                          child: InkWell(
                              onTap: () => c.toggleHabit(habit),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(habit.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            decoration:
                                                habit.completedOn(c.today)
                                                    ? TextDecoration.lineThrough
                                                    : null)),
                                    if (habit.description.isNotEmpty)
                                      Text(habit.description,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black54)),
                                    Text(
                                        '+${12 + habit.difficulty * 6} XP • ${[
                                          '',
                                          'Kolay',
                                          'Orta',
                                          'Zorlu'
                                        ][habit.difficulty]}',
                                        style: TextStyle(
                                            color: age.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10)),
                                  ]))),
                      PopupMenuButton<String>(
                          tooltip: 'Vazife seçenekleri',
                          itemBuilder: (_) => const [
                                PopupMenuItem(
                                    value: 'edit', child: Text('Düzenle')),
                                PopupMenuItem(
                                    value: 'archive', child: Text('Arşivle')),
                              ],
                          onSelected: (value) {
                            if (value == 'edit') openEditor(context, habit);
                            if (value == 'archive') c.archiveHabit(habit);
                          }),
                    ])),
              )),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: c.toggleRestDay,
            icon: Icon(c.restDates.contains(c.today)
                ? Icons.sunny
                : Icons.bedtime_outlined),
            label: Text(c.restDates.contains(c.today)
                ? 'Bugün planlı istirahat • kaldır'
                : 'Bugünü planlı istirahat olarak işaretle'),
          ),
          const SizedBox(height: 6),
          const Text('Planlı istirahat günlerinde itibar cezası uygulanmaz.',
              style: TextStyle(fontSize: 11, color: Colors.black54)),
        ]);
  }
}

class _Metric extends StatelessWidget {
  const _Metric(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});
  final String label, value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(17)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 21, color: const Color(0xFF3D5851)),
          const SizedBox(height: 7),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900))),
          Text(label,
              style: const TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .5)),
        ]),
      );
}
