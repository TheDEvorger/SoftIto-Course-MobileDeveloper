import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/collection_status.dart';
import '../../../data/models/collection_visit.dart';

/// İşlem akışını dikey zaman çizelgesi olarak gösterir.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.visit});

  final CollectionVisit visit;

  @override
  Widget build(BuildContext context) {
    final bool cancelled = visit.status == CollectionStatus.cancelled;
    final List<CollectionStatus> steps = <CollectionStatus>[
      ...CollectionStatusX.flow,
      if (cancelled) CollectionStatus.cancelled,
    ];

    return Column(
      children: <Widget>[
        for (int i = 0; i < steps.length; i++)
          _TimelineRow(
            step: steps[i],
            reachedAt: visit.statusHistory[steps[i]],
            isCurrent: visit.status == steps[i],
            isLast: i == steps.length - 1,
            hint: _hintFor(steps[i]),
          ),
      ],
    );
  }

  String _hintFor(CollectionStatus step) => switch (step) {
        CollectionStatus.waiting => 'Hasta kabul edildi, sıraya alındı',
        CollectionStatus.called => 'Hasta kan alma odasına çağrıldı',
        CollectionStatus.inProgress => 'Kan alma işlemi sürüyor',
        CollectionStatus.sampleCollected => 'Kurgusal numune kaydı oluşturuldu',
        CollectionStatus.delivered => 'Numune laboratuvara teslim edildi',
        CollectionStatus.cancelled => 'İşlem iptal edildi',
      };
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.step,
    required this.reachedAt,
    required this.isCurrent,
    required this.isLast,
    required this.hint,
  });

  final CollectionStatus step;
  final DateTime? reachedAt;
  final bool isCurrent;
  final bool isLast;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool reached = reachedAt != null;
    final bool isCancel = step == CollectionStatus.cancelled;
    final Color active =
        isCancel ? context.palette.coral : theme.colorScheme.primary;
    final Color idle = theme.colorScheme.outline;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 36,
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: reached
                        ? active.withValues(alpha: isCurrent ? 1 : 0.15)
                        : Colors.transparent,
                    border: Border.all(
                        color: reached ? active : idle, width: 2),
                  ),
                  child: Icon(
                    reached && !isCurrent ? Icons.check_rounded : step.icon,
                    size: 16,
                    color: reached
                        ? (isCurrent ? theme.colorScheme.surface : active)
                        : idle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: reached ? active.withValues(alpha: 0.4) : idle,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4, bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          step.label,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: reached
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        reached ? Formatters.time(reachedAt!) : '—',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFeatures: const <FontFeature>[
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(hint, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
