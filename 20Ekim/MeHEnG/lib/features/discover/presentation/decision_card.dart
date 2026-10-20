import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/decision.dart';
import '../../domain/evidence.dart';
import '../discover_providers.dart';

class DecisionCard extends ConsumerWidget {
  const DecisionCard({
    required this.decision,
    required this.ventureId,
    super.key,
  });

  final Decision decision;
  final String ventureId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (badgeColor, badgeBg, icon) = switch (decision.outcome) {
      DecisionOutcome.continueRun => (
          Colors.green.shade700,
          Colors.green.shade50,
          Icons.arrow_forward_rounded,
        ),
      DecisionOutcome.pivot => (
          Colors.orange.shade800,
          Colors.orange.shade50,
          Icons.change_circle_outlined,
        ),
      DecisionOutcome.stop => (
          Colors.red.shade700,
          Colors.red.shade50,
          Icons.cancel_outlined,
        ),
    };

    // Trace linked evidence records
    final hypotheses = ref.watch(hypothesesProvider(ventureId));
    final linkedEvidence = <Evidence>[];
    for (final h in hypotheses) {
      final experiments = ref.watch(experimentsProvider(h.id));
      for (final exp in experiments) {
        final evList = ref.watch(evidenceProvider(exp.id));
        for (final ev in evList) {
          if (decision.evidenceIds.contains(ev.id)) {
            linkedEvidence.add(ev);
          }
        }
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 16, color: badgeColor),
                      const SizedBox(width: 6),
                      Text(
                        decision.outcome.label,
                        style: TextStyle(
                          color: badgeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(decision.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              decision.rationale,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (linkedEvidence.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                'Dayanak Kanıtlar (${linkedEvidence.length}):',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 6),
              for (final ev in linkedEvidence)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        ev.direction == EvidenceDirection.supports
                            ? Icons.check_circle_outline
                            : ev.direction == EvidenceDirection.contradicts
                                ? Icons.highlight_off
                                : Icons.help_outline,
                        size: 16,
                        color: ev.direction == EvidenceDirection.supports
                            ? Colors.green
                            : ev.direction == EvidenceDirection.contradicts
                                ? Colors.redAccent
                                : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${ev.note}${ev.source != null ? " [${ev.source}]" : ""}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}
