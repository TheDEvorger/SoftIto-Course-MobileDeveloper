import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/page_parts.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/demo/clinic_state.dart';
import '../../../data/models/activity_entry.dart';
import '../../../data/models/collection_status.dart';
import '../../../data/models/collection_visit.dart';
import '../../../data/models/demo_patient.dart';

/// Çağrılmış veya işlemdeki hastalar; tek dokunuşla sonraki adım.
class ActiveCallsCard extends StatelessWidget {
  const ActiveCallsCard({
    super.key,
    required this.state,
    required this.visits,
    required this.onAdvance,
    required this.onOpen,
  });

  final ClinicState state;
  final List<CollectionVisit> visits;
  final ValueChanged<CollectionVisit> onAdvance;
  final ValueChanged<CollectionVisit> onOpen;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SectionCard(
      title: 'Aktif Çağrılar',
      icon: Icons.campaign_outlined,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: visits.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Şu an çağrılmış veya işlemde hasta yok.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            )
          : Column(
              children: <Widget>[
                for (final CollectionVisit v in visits)
                  _ActiveRow(
                    visit: v,
                    patient: state.patientOf(v),
                    onAdvance: () => onAdvance(v),
                    onOpen: () => onOpen(v),
                  ),
              ],
            ),
    );
  }
}

class _ActiveRow extends StatelessWidget {
  const _ActiveRow({
    required this.visit,
    required this.patient,
    required this.onAdvance,
    required this.onOpen,
  });

  final CollectionVisit visit;
  final DemoPatient? patient;
  final VoidCallback onAdvance;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            QueueBadge(label: Formatters.queueNumber(visit.queueNumber)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Formatters.shortName(patient?.displayName ?? '-'),
                    style: theme.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  StatusChip.visit(visit.status),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: onAdvance,
              child: Text(visit.status.nextActionLabel ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}

/// Son hareketler akışı.
class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({
    super.key,
    required this.activities,
    required this.onOpenVisit,
  });

  final List<ActivityEntry> activities;
  final ValueChanged<String> onOpenVisit;

  static const int _visibleCount = 7;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<ActivityEntry> items =
        activities.take(_visibleCount).toList(growable: false);

    return SectionCard(
      title: 'Son Hareketler',
      icon: Icons.history_rounded,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: items.isEmpty
          ? Text('Henüz hareket yok.', style: theme.textTheme.bodyMedium)
          : Column(
              children: <Widget>[
                for (final ActivityEntry a in items)
                  _ActivityRow(
                    entry: a,
                    onTap: a.visitId == null
                        ? null
                        : () => onOpenVisit(a.visitId!),
                  ),
              ],
            ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry, required this.onTap});

  final ActivityEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = StatusColors.forVisit(context, entry.status);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(entry.status.icon,
                  size: 18, color: StatusColors.readable(context, color)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(entry.message,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            Text(Formatters.time(entry.timestamp),
                style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
