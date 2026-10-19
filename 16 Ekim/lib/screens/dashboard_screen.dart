import 'package:flutter/material.dart';

import '../core/palette.dart';
import '../models/vocabulary_word.dart';
import '../widgets/ui_parts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.words,
    required this.dailyGoal,
    required this.onAdd,
    required this.onLibrary,
    required this.onReview,
    required this.onChangeGoal,
  });

  final List<VocabularyWord> words;
  final int dailyGoal;
  final VoidCallback onAdd;
  final VoidCallback onLibrary;
  final ValueChanged<String> onReview;
  final ValueChanged<int> onChangeGoal;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayCount = words.where((w) => w.lastReviewedAt != null && DateUtils.isSameDay(w.lastReviewedAt, now)).length;
    final done = words.where((w) => w.stage == WordStage.mastered).length;
    final ongoing = words.where((w) => w.stage == WordStage.learning).length;
    final progress = (todayCount / dailyGoal).clamp(0.0, 1.0).toDouble();
    final pending = words.where((w) => w.stage != WordStage.mastered).toList();
    final featured = pending.isEmpty ? null : pending[now.day % pending.length];

    return SingleChildScrollView(
      child: PageFrame(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Kicker('GÜNLÜK ÇALIŞMA DEFTERİ   /   01'),
          const SizedBox(height: 11),
          Text('Bir kelime daha,\nbir adım daha.', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          const Text('Almanca ve İngilizce yolculuğunu kendi ritminle büyüt.', style: TextStyle(color: Palette.muted, fontSize: 14)),
          const SizedBox(height: 28),
          _StudyHero(
            dailyGoal: dailyGoal,
            todayCount: todayCount,
            progress: progress,
            onAdd: onAdd,
            onGoalTap: () => _pickGoal(context),
          ),
          const SizedBox(height: 19),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth >= 760 ? 3 : constraints.maxWidth >= 450 ? 2 : 1;
            const gap = 12.0;
            final tileWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(spacing: gap, runSpacing: gap, children: [
              SizedBox(width: tileWidth, child: StatTile(icon: Icons.auto_stories_outlined, label: 'Defterdeki kelimeler', value: '${words.length}', tint: Palette.sage, accent: Palette.forest)),
              SizedBox(width: tileWidth, child: StatTile(icon: Icons.workspace_premium_outlined, label: 'Öğrenilen', value: '$done', tint: Palette.coralLight, accent: Palette.terracotta)),
              SizedBox(width: tileWidth, child: StatTile(icon: Icons.edit_note_rounded, label: 'Çalışılmakta olan', value: '$ongoing', tint: Palette.amberSoft, accent: const Color(0xFF8A6230))),
            ]);
          }),
          const SizedBox(height: 34),
          const SectionHeading(title: 'İki dil, tek yolculuk', subtitle: 'Kendi kelime arşivinin ilerleme notları.'),
          const SizedBox(height: 15),
          LayoutBuilder(builder: (context, constraints) {
            final german = _LanguageNote(language: StudyLanguage.german, words: words, sequence: '01');
            final english = _LanguageNote(language: StudyLanguage.english, words: words, sequence: '02');
            if (constraints.maxWidth < 690) return Column(children: [german, const SizedBox(height: 12), english]);
            return Row(children: [Expanded(child: german), const SizedBox(width: 12), Expanded(child: english)]);
          }),
          const SizedBox(height: 34),
          SectionHeading(
            title: 'Bugünün kelimesi',
            subtitle: 'Bir kelime seç, ona bir kez daha uğra.',
            trailing: IconButton(
              tooltip: 'Kelime defterini aç',
              onPressed: onLibrary,
              icon: const Icon(Icons.arrow_forward_rounded),
            ),
          ),
          const SizedBox(height: 14),
          if (featured != null)
            WordTile(word: featured, compact: true, onReview: () => onReview(featured.id))
          else
            EmptyState(
              title: 'Defterinde bekleyen kelime yok',
              message: 'Yeni bir kelime ekleyerek bugünün sayfasını açabilirsin.',
              icon: Icons.bookmark_add_outlined,
              action: FilledButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Kelime ekle')),
            ),
          const SizedBox(height: 30),
          const Center(child: Text('DİL ROTASI     •     YAVAŞ VE SAĞLAM', style: TextStyle(letterSpacing: 1.7, fontSize: 10, fontWeight: FontWeight.w700, color: Palette.muted))),
        ]),
      ),
    );
  }

  Future<void> _pickGoal(BuildContext context) async {
    var value = dailyGoal.toDouble();
    final updated = await showDialog<int>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Günlük çalışma hedefi'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${value.round()} kelime / gün', style: const TextStyle(fontFamily: 'serif', fontSize: 25, color: Palette.forest, fontWeight: FontWeight.w700)),
            Slider(value: value, min: 1, max: 30, divisions: 29, onChanged: (v) => update(() => value = v)),
            const Text('Aynı kelimeyi günde birkaç kez çalışsan da hedefe bir kez sayılır.', style: TextStyle(color: Palette.muted, fontSize: 12)),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Vazgeç')),
            FilledButton(onPressed: () => Navigator.pop(dialogContext, value.round()), child: const Text('Kaydet')),
          ],
        ),
      ),
    );
    if (updated != null) onChangeGoal(updated);
  }
}

class _StudyHero extends StatelessWidget {
  const _StudyHero({required this.dailyGoal, required this.todayCount, required this.progress, required this.onAdd, required this.onGoalTap});
  final int dailyGoal;
  final int todayCount;
  final double progress;
  final VoidCallback onAdd;
  final VoidCallback onGoalTap;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(color: Palette.forest, borderRadius: BorderRadius.circular(18)),
    child: LayoutBuilder(builder: (context, constraints) {
      final roomForSeal = constraints.maxWidth >= 620;
      return Stack(children: [
        if (roomForSeal)
          Positioned(right: 36, top: 5, bottom: 5, child: Center(child: OrbitPattern(size: 215, color: Palette.olive))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth < 450 ? 23 : 30, vertical: 26),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Kicker('BUGÜNÜN İZİ', dark: true)),
              TextButton.icon(
                onPressed: onGoalTap,
                style: TextButton.styleFrom(foregroundColor: Palette.paper, visualDensity: VisualDensity.compact),
                icon: const Icon(Icons.tune_rounded, size: 17),
                label: const Text('Hedef', style: TextStyle(fontSize: 12)),
              ),
            ]),
            const SizedBox(height: 10),
            Text('$todayCount / $dailyGoal', style: const TextStyle(fontFamily: 'serif', color: Palette.paper, fontSize: 47, fontWeight: FontWeight.bold, height: 1)),
            const SizedBox(height: 10),
            const Text('Bugün çalışılan farklı kelimeler', style: TextStyle(color: Color(0xFFE2E8DA), fontSize: 12)),
            const SizedBox(height: 20),
            SizedBox(
              width: roomForSeal ? constraints.maxWidth * .55 : double.infinity,
              child: ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFF536D5D),
                valueColor: const AlwaysStoppedAnimation(Palette.mustard),
                minHeight: 8,
              )),
            ),
            const SizedBox(height: 17),
            Text(progress >= 1 ? 'Bugünün sayfası tamamlandı. Tebrikler!' : 'Az ama düzenli: bir kelimeyle başla.', style: const TextStyle(fontSize: 13, color: Palette.paper)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAdd,
              style: FilledButton.styleFrom(backgroundColor: Palette.mustard, foregroundColor: Palette.forestDeep),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Yeni kelime yaz'),
            ),
          ]),
        ),
      ]);
    }),
  );
}

class _LanguageNote extends StatelessWidget {
  const _LanguageNote({required this.language, required this.words, required this.sequence});
  final StudyLanguage language;
  final List<VocabularyWord> words;
  final String sequence;

  @override
  Widget build(BuildContext context) {
    final total = words.where((w) => w.language == language).length;
    final mastered = words.where((w) => w.language == language && w.stage == WordStage.mastered).length;
    final percentage = total == 0 ? 0.0 : mastered / total;
    final isGerman = language == StudyLanguage.german;
    return SurfacePanel(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(sequence, style: const TextStyle(fontFamily: 'serif', fontSize: 27, fontStyle: FontStyle.italic, color: Palette.terracotta)),
          const Spacer(),
          LanguageBadge(language: language),
        ]),
        const SizedBox(height: 12),
        Text(isGerman ? 'Deutsch lernen' : 'Learn English', style: const TextStyle(fontFamily: 'serif', fontSize: 24, fontWeight: FontWeight.bold, color: Palette.ink)),
        const SizedBox(height: 6),
        Text('$mastered / $total kelime öğrenildi', style: const TextStyle(color: Palette.muted, fontSize: 12)),
        const SizedBox(height: 19),
        ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(
          value: percentage,
          minHeight: 6,
          backgroundColor: Palette.fog,
          valueColor: AlwaysStoppedAnimation(isGerman ? Palette.terracotta : Palette.moss),
        )),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerRight, child: Text('%${(percentage * 100).round()}', style: const TextStyle(color: Palette.ink, fontSize: 12, fontWeight: FontWeight.w800))),
      ]),
    );
  }
}
