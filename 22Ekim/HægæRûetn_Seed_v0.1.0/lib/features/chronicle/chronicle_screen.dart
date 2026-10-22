import 'package:flutter/material.dart';
import '../../core/models/badge_definition.dart';
import '../../core/models/era.dart';
import '../../core/services/progression_engine.dart';
import '../../core/state/realm_controller.dart';
import '../../core/widgets/realm_card.dart';

class ChronicleScreen extends StatelessWidget {
  const ChronicleScreen({super.key, required this.controller});
  final RealmController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final next = c.level < 24 ? ProgressionEngine.xpThreshold(c.level + 1) : 0;
    final current = ProgressionEngine.xpThreshold(c.level);
    final progress = c.level == 24
        ? 1.0
        : ((c.xp - current) / (next - current)).clamp(0.0, 1.0).toDouble();
    final dates = List.generate(
        14, (index) => DateTime.now().subtract(Duration(days: 13 - index)));
    return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Text('Krallık Kronikleri',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 5),
          const Text('Bugünün izini yarının tarihçisi okuyacak.',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          RealmCard(
              color: c.era.secondary.withValues(alpha: .55),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .65),
                              shape: BoxShape.circle),
                          child: Icon(Icons.castle_outlined,
                              size: 35, color: c.era.primary)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('Seviye ${c.level} / 24',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 19)),
                            Text(c.rank,
                                style: TextStyle(
                                    color: c.era.primary,
                                    fontWeight: FontWeight.w900)),
                            Text('${c.era.name} Çağı',
                                style: const TextStyle(fontSize: 12)),
                          ])),
                    ]),
                    const SizedBox(height: 15),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor:
                                Colors.white.withValues(alpha: .75),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(c.era.primary))),
                    const SizedBox(height: 7),
                    Text(
                        'XP: ${c.xp}${c.level == 24 ? ' • Zirve!' : ' / $next'}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                    if (c.level < c.earnedLevel)
                      const Padding(
                          padding: EdgeInsets.only(top: 7),
                          child: Text(
                              'İtibarın düştüğü için geçici mevki kaybın var. Emeğin ve XP korunuyor.',
                              style: TextStyle(
                                  color: Color(0xFF945A3B), fontSize: 11))),
                  ])),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
                child: _Stat(
                    value: '${c.totalCompletions}',
                    label: 'Toplam vazife',
                    icon: Icons.check_circle_outline)),
            const SizedBox(width: 9),
            Expanded(
                child: _Stat(
                    value: '${c.pacts.where((p) => p.isCompleted).length}',
                    label: 'Tam ahit',
                    icon: Icons.history_edu_outlined)),
            const SizedBox(width: 9),
            Expanded(
                child: _Stat(
                    value: '${c.reputation}',
                    label: 'İtibar',
                    icon: Icons.stars_outlined)),
          ]),
          const SizedBox(height: 20),
          const SectionTitle('14 günlük iz haritası'),
          const SizedBox(height: 11),
          RealmCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Wrap(
                    spacing: 7,
                    runSpacing: 8,
                    children: dates.map((d) {
                      final key = ProgressionEngine.dayKey(d);
                      final completed = c.habits
                          .where((habit) => habit.completedOn(key))
                          .length;
                      final color = completed == 0
                          ? const Color(0xFFE5E4D9)
                          : Color.lerp(c.era.secondary, c.era.primary,
                              (completed / 4).clamp(.1, 1).toDouble())!;
                      return Tooltip(
                          message: '$key • $completed tamamlanan',
                          child: Container(
                            width: 32,
                            height: 37,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(9)),
                            child: Text('${d.day}',
                                style: TextStyle(
                                    color: completed >= 3
                                        ? Colors.white
                                        : const Color(0xFF3E4843),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12)),
                          ));
                    }).toList()),
                const SizedBox(height: 11),
                const Text(
                    'Her kutu bir günü, renk yoğunluğu tamamlanan vazife sayısını gösterir.',
                    style: TextStyle(fontSize: 10, color: Colors.black54)),
              ])),
          const SizedBox(height: 20),
          SectionTitle('24 Şan Rozeti',
              trailing: RealmPill(label: '${c.badgeCount} / 24 açıldı')),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: .95),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              final unlocked = c.badgeIds.contains(badge.id);
              final era = eras[badge.era];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text(
                              '${badge.id.toString().padLeft(2, '0')} • ${badge.name}'),
                          content: Text(
                              '${badge.description}\n\n${unlocked ? 'Rozeti kazandın!' : badge.future ? 'Bu rozet sonraki sürümde açılacak.' : 'Henüz kazanılmadı.'}'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Kapat'))
                          ],
                        )),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                  decoration: BoxDecoration(
                      color: unlocked ? era.secondary : const Color(0xFFEEEDE6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color:
                              unlocked ? era.accent : const Color(0xFFDCDAD1))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(badge.icon,
                            color: unlocked
                                ? era.primary
                                : const Color(0xFF9A9990),
                            size: 28),
                        const SizedBox(height: 6),
                        Text(badge.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: unlocked
                                    ? const Color(0xFF272F2C)
                                    : const Color(0xFF7D8077),
                                fontSize: 10)),
                        const SizedBox(height: 3),
                        Text(
                            unlocked
                                ? 'KAZANILDI'
                                : badge.future
                                    ? 'YAKINDA'
                                    : 'KİLİTLİ',
                            style: const TextStyle(
                                fontSize: 8, letterSpacing: .5)),
                      ]),
                ),
              );
            },
          ),
          const SizedBox(height: 19),
          const SectionTitle('Altı çağın yolu'),
          const SizedBox(height: 9),
          ...eras.asMap().entries.map((entry) {
            final index = entry.key, era = entry.value;
            final first = index * 4 + 1;
            return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RealmCard(
                  color: era.secondary.withValues(alpha: .55),
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                            color: era.primary,
                            borderRadius: BorderRadius.circular(11)),
                        alignment: Alignment.center,
                        child: Text('${index + 1}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('${era.name} Çağı',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900)),
                          Text('$first-${first + 3} • ${era.ranks.join(', ')}',
                              style: const TextStyle(
                                  fontSize: 10.5, color: Color(0xFF555B54))),
                        ])),
                    Icon(
                        c.level >= first
                            ? Icons.lock_open_rounded
                            : Icons.lock_outline,
                        color: era.primary),
                  ]),
                ));
          }),
        ]);
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.icon});
  final String value, label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => RealmCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(children: [
        Icon(icon, size: 22, color: const Color(0xFF528175)),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700))),
      ]));
}
