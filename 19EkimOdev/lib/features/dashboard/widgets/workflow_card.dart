import 'package:flutter/material.dart';

import '../../../core/widgets/page_parts.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/collection_status.dart';
import '../models/dashboard_summary.dart';

/// Günlük iş akışının durumlara göre dağılımı ve tamamlanma oranı.
class WorkflowCard extends StatelessWidget {
  const WorkflowCard({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int percent = (summary.completionRate * 100).round();

    return SectionCard(
      title: 'Günlük İş Akışı',
      icon: Icons.insights_rounded,
      trailing: Text(
        '%$percent tamamlandı',
        style: theme.textTheme.labelLarge
            ?.copyWith(color: theme.colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _DistributionBar(summary: summary),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: <Widget>[
              for (final CollectionStatus s in CollectionStatus.values)
                _LegendItem(status: s, count: summary.countOf(s)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DistributionBar extends StatelessWidget {
  const _DistributionBar({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (summary.total == 0) {
      return Container(
        height: 14,
        decoration: BoxDecoration(
          color: theme.colorScheme.outline,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
    return Semantics(
      label: 'Durum dağılımı çubuğu, toplam ${summary.total} kayıt',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 14,
          child: Row(
            children: <Widget>[
              for (final CollectionStatus s in CollectionStatus.values)
                if (summary.countOf(s) > 0)
                  Expanded(
                    flex: summary.countOf(s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 2),
                      color: StatusColors.forVisit(context, s),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.status, required this.count});

  final CollectionStatus status;
  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = StatusColors.forVisit(context, status);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(status.icon, size: 14, color: StatusColors.readable(context, color)),
        const SizedBox(width: 4),
        Text('${status.label}: $count', style: theme.textTheme.bodySmall),
      ],
    );
  }
}
