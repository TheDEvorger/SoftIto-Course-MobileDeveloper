import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/collection_visit.dart';
import '../../../data/models/demo_patient.dart';

/// Dashboard'un üstündeki gradient karşılama ve hızlı aksiyon paneli.
class HeroPanel extends StatelessWidget {
  const HeroPanel({
    super.key,
    required this.today,
    required this.nextVisit,
    required this.nextPatient,
    required this.waitingCount,
    required this.onCallNext,
    required this.onNewPatient,
  });

  final DateTime today;
  final CollectionVisit? nextVisit;
  final DemoPatient? nextPatient;
  final int waitingCount;
  final VoidCallback onCallNext;
  final VoidCallback onNewPatient;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final VenaPalette palette = context.palette;
    const Color onHero = Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[palette.heroStart, palette.heroEnd],
        ),
      ),
      child: Stack(
        children: <Widget>[
          // Dekoratif yumuşak daireler (görsel derinlik için).
          Positioned(
            right: -40,
            top: -50,
            child: _Glow(size: 180, opacity: 0.10),
          ),
          Positioned(
            right: 60,
            bottom: -70,
            child: _Glow(size: 140, opacity: 0.07),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.water_drop_rounded, color: onHero, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        Formatters.longDate(today),
                        style: theme.textTheme.labelLarge?.copyWith(
                            color: onHero.withValues(alpha: 0.85)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const _DemoPill(),
                  ],
                ),
                const SizedBox(height: 14),
                Semantics(
                  header: true,
                  child: Text(
                    'Kan Alma Birimi',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(color: onHero),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  waitingCount == 0
                      ? 'Şu an sırada bekleyen hasta yok.'
                      : 'Sırada $waitingCount hasta bekliyor.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: onHero.withValues(alpha: 0.85)),
                ),
                const SizedBox(height: 16),
                _NextUpTile(visit: nextVisit, patient: nextPatient),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    FilledButton.icon(
                      key: const Key('dashboard_call_next'),
                      style: FilledButton.styleFrom(
                        backgroundColor: onHero,
                        foregroundColor: palette.heroEnd,
                        disabledBackgroundColor:
                            onHero.withValues(alpha: 0.25),
                        disabledForegroundColor:
                            onHero.withValues(alpha: 0.7),
                      ),
                      onPressed: nextVisit == null ? null : onCallNext,
                      icon: const Icon(Icons.campaign_rounded),
                      label: const Text('Sıradakini Çağır'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: onHero,
                        side: BorderSide(color: onHero.withValues(alpha: 0.5)),
                      ),
                      onPressed: onNewPatient,
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('Yeni Hasta'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextUpTile extends StatelessWidget {
  const _NextUpTile({required this.visit, required this.patient});

  final CollectionVisit? visit;
  final DemoPatient? patient;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const Color onHero = Colors.white;
    final CollectionVisit? v = visit;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey<String?>(v?.id),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: onHero.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: onHero.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: onHero.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                v == null ? '—' : Formatters.queueNumber(v.queueNumber),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: onHero,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'SIRADAKİ',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: onHero.withValues(alpha: 0.7),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    v == null
                        ? 'Bekleyen hasta yok'
                        : '${Formatters.shortName(patient?.displayName ?? '-')}'
                            ' · ${patient?.department ?? '-'}',
                    style: theme.textTheme.titleSmall?.copyWith(color: onHero),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoPill extends StatelessWidget {
  const _DemoPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Eğitim Demosu',
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
