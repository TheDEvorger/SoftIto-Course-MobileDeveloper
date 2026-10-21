import 'package:flutter/material.dart';
import '../../../core/theme/studio_colors.dart';

class EditorialHero extends StatelessWidget {
  const EditorialHero({super.key, required this.onExplore});
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 850 &&
            MediaQuery.textScalerOf(context).scale(1) < 1.3;
        final dark = Theme.of(context).brightness == Brightness.dark;
        final surface = Theme.of(context).colorScheme.surface;
        final copy = Padding(
            padding: EdgeInsets.all(wide ? 40 : 26),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SÜRÜŞÜN YENİ PERSPEKTİFİ',
                      style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2.2,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 20),
                  Text('Yola çıkmanın\ndaha iyi bir yolu.',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: wide ? 48 : 34, letterSpacing: -1.8)),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 330),
                      child: Text(
                          'Şehre, planlarınıza, size uyan araç.\nBir sonraki yolculuğunuzu birlikte şekillendirelim.',
                          style: TextStyle(
                              height: 1.7,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant))),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                      onPressed: onExplore,
                      label: const Text('Koleksiyonu keşfet'),
                      icon: const Icon(Icons.north_east, size: 17)),
                ]));
        final photo = Stack(fit: StackFit.expand, children: [
          Image.asset('assets/images/precision-editorial-hero.png',
              fit: BoxFit.cover,
              alignment: const Alignment(.55, .4),
              excludeFromSemantics: true),
          Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .68),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('YAPAY ZEKÂ İLE ÜRETİLMİŞ MARKA GÖRSELİ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          letterSpacing: .5)))),
        ]);
        return ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: ColoredBox(
                color: surface,
                child: wide
                    ? ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 380),
                        child: Stack(children: [
                          Positioned.fill(child: photo),
                          Positioned.fill(
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(stops: const [
                            0,
                            .32,
                            .62
                          ], colors: [
                            surface,
                            surface.withValues(alpha: .97),
                            surface.withValues(alpha: 0)
                          ])))),
                          SizedBox(
                              width: constraints.maxWidth * .52, child: copy),
                        ]))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            copy,
                            AspectRatio(aspectRatio: 1.85, child: photo),
                            Container(
                                height: 5,
                                color: dark
                                    ? StudioColors.forest
                                    : StudioColors.mint),
                          ])));
      });
}
