import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/palette.dart';
import '../models/vocabulary_word.dart';

/// Ekranın kullanılabilir alanı; masaüstünde fazla uzamaz.
class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Padding(
          padding: EdgeInsets.fromLTRB(width < 600 ? 18 : 38, width < 600 ? 25 : 42, width < 600 ? 18 : 38, 52),
          child: child,
        ),
      ),
    );
  }
}

/// Küçük, geometrik bir kitap mührü. Resim dosyası veya internet gerektirmez.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 42, this.light = false});
  final double size;
  final bool light;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: light ? Palette.parchment : Palette.terracotta,
      borderRadius: BorderRadius.circular(size * .28),
    ),
    child: CustomPaint(
      painter: _BookSealPainter(ink: light ? Palette.forest : Palette.paper),
    ),
  );
}

class _BookSealPainter extends CustomPainter {
  const _BookSealPainter({required this.ink});
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = ink..style = PaintingStyle.stroke..strokeWidth = size.width * .055..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final w = size.width;
    final h = size.height;
    final book = Path()
      ..moveTo(w * .19, h * .32)
      ..quadraticBezierTo(w * .34, h * .25, w * .5, h * .37)
      ..quadraticBezierTo(w * .66, h * .25, w * .81, h * .32)
      ..lineTo(w * .81, h * .73)
      ..quadraticBezierTo(w * .65, h * .65, w * .5, h * .76)
      ..quadraticBezierTo(w * .34, h * .65, w * .19, h * .73)
      ..close();
    canvas.drawPath(book, p);
    canvas.drawLine(Offset(w * .5, h * .37), Offset(w * .5, h * .76), p);
    canvas.drawCircle(Offset(w * .5, h * .20), w * .045, Paint()..color = ink);
  }

  @override
  bool shouldRepaint(_BookSealPainter oldDelegate) => oldDelegate.ink != ink;
}

class Kicker extends StatelessWidget {
  const Kicker(this.text, {super.key, this.dark = false});
  final String text;
  final bool dark;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      fontSize: 11,
      letterSpacing: 2.0,
      fontWeight: FontWeight.w800,
      color: dark ? Palette.olive : Palette.terracotta,
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title, this.subtitle, this.trailing});
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: const TextStyle(color: Palette.muted, fontSize: 13)),
        ],
      ])),
      if (trailing != null) ...[const SizedBox(width: 8), trailing!],
    ],
  );
}

class SurfacePanel extends StatelessWidget {
  const SurfacePanel({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.color = Palette.paper});
  final Widget child;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: Palette.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(padding: padding, child: child),
  );
}

class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.icon, required this.label, required this.value, required this.tint, required this.accent});
  final IconData icon;
  final String label;
  final String value;
  final Color tint;
  final Color accent;

  @override
  Widget build(BuildContext context) => SurfacePanel(
    padding: const EdgeInsets.all(19),
    child: Row(children: [
      Container(
        width: 47, height: 47,
        decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(13)),
        child: Icon(icon, color: accent, size: 22),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontFamily: 'serif', fontSize: 28, fontWeight: FontWeight.bold, color: Palette.ink, height: 1.1)),
        const SizedBox(height: 3),
        Text(label, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Palette.muted)),
      ])),
    ]),
  );
}

class LanguageBadge extends StatelessWidget {
  const LanguageBadge({super.key, required this.language});
  final StudyLanguage language;

  @override
  Widget build(BuildContext context) {
    final german = language == StudyLanguage.german;
    return DecoratedBox(
      decoration: BoxDecoration(color: german ? Palette.coralLight : Palette.sage, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        child: Text('${language.flag}  ${language.label}', style: TextStyle(color: german ? Palette.terracotta : Palette.forest, fontSize: 11, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class StageBadge extends StatelessWidget {
  const StageBadge({super.key, required this.stage});
  final WordStage stage;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = switch (stage) {
      WordStage.newWord => (Palette.muted, Palette.fog),
      WordStage.learning => (const Color(0xFF8A6230), Palette.amberSoft),
      WordStage.mastered => (Palette.forest, Palette.sage),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(stage.label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message, required this.icon, this.action});
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) => SurfacePanel(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 9),
      child: Column(children: [
        Icon(icon, size: 44, color: Palette.terracotta),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Palette.muted)),
        if (action != null) ...[const SizedBox(height: 20), action!],
      ]),
    ),
  );
}

class WordTile extends StatelessWidget {
  const WordTile({
    super.key,
    required this.word,
    required this.onReview,
    this.onMastered,
    this.onReset,
    this.onDelete,
    this.compact = false,
  });
  final VocabularyWord word;
  final VoidCallback onReview;
  final VoidCallback? onMastered;
  final VoidCallback? onReset;
  final VoidCallback? onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) => SurfacePanel(
    padding: const EdgeInsets.fromLTRB(19, 17, 18, 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        LanguageBadge(language: word.language),
        const SizedBox(width: 7),
        Flexible(child: StageBadge(stage: word.stage)),
        const Spacer(),
        if (onDelete != null)
          PopupMenuButton<String>(
            tooltip: 'Kelime işlemleri',
            icon: const Icon(Icons.more_horiz, color: Palette.muted),
            onSelected: (value) {
              if (value == 'master') onMastered?.call();
              if (value == 'reset') onReset?.call();
              if (value == 'delete') onDelete?.call();
            },
            itemBuilder: (_) => [
              if (word.stage != WordStage.mastered) const PopupMenuItem(value: 'master', child: Text('Öğrenildi olarak işaretle')),
              const PopupMenuItem(value: 'reset', child: Text('Yeni olarak işaretle')),
              const PopupMenuItem(value: 'delete', child: Text('Kelimeyi sil')),
            ],
          ),
      ]),
      const SizedBox(height: 18),
      Text(word.word, style: TextStyle(fontFamily: 'serif', fontSize: compact ? 25 : 27, fontWeight: FontWeight.w700, color: Palette.ink)),
      const SizedBox(height: 5),
      Text(word.meaning, style: const TextStyle(fontSize: 14, color: Palette.muted)),
      if (word.example.trim().isNotEmpty) ...[
        const SizedBox(height: 17),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Palette.terracotta, width: 3)), color: Palette.parchment),
          child: Text(word.example, style: const TextStyle(fontFamily: 'serif', fontStyle: FontStyle.italic, fontSize: 14, color: Palette.ink, height: 1.4)),
        ),
      ],
      const SizedBox(height: 17),
      const Divider(height: 1),
      const SizedBox(height: 11),
      Row(children: [
        const Icon(Icons.autorenew_rounded, size: 17, color: Palette.muted),
        const SizedBox(width: 5),
        Expanded(child: Text('${word.reviewCount} tekrar', style: const TextStyle(color: Palette.muted, fontSize: 12))),
        TextButton.icon(
          onPressed: onReview,
          style: TextButton.styleFrom(foregroundColor: Palette.terracotta, padding: const EdgeInsets.symmetric(horizontal: 8)),
          icon: const Icon(Icons.arrow_forward_rounded, size: 17),
          label: Text(word.stage == WordStage.mastered ? 'Tekrar et' : 'Çalıştım'),
        ),
      ]),
    ]),
  );
}

/// Tarih/geometri detayları için dekoratif düz çizgi çizicisi.
class OrbitPattern extends StatelessWidget {
  const OrbitPattern({super.key, this.size = 240, this.color = Palette.olive});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _OrbitPainter(color),
  );
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .5, size.height * .5);
    final radius = size.width * .38;
    final pen = Paint()..color = color.withValues(alpha: .36)..style = PaintingStyle.stroke..strokeWidth = 1.25;
    for (final factor in [.56, .80, 1.04]) {
      canvas.drawCircle(center, radius * factor, pen);
    }
    for (var i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final a = Offset(center.dx + radius * .86 * math.cos(angle), center.dy + radius * .86 * math.sin(angle));
      final b = Offset(center.dx + radius * 1.04 * math.cos(angle), center.dy + radius * 1.04 * math.sin(angle));
      canvas.drawLine(a, b, pen);
    }
    final dot = Paint()..color = color;
    canvas.drawCircle(center, size.width * .028, dot);
  }
  @override
  bool shouldRepaint(_OrbitPainter oldDelegate) => oldDelegate.color != color;
}
