import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/demo_specimen.dart';
import '../models/specimen_row.dart';

/// Numune listesindeki tek bir kart.
class SpecimenCard extends StatelessWidget {
  const SpecimenCard({
    super.key,
    required this.row,
    required this.onCopy,
    required this.onOpenDetail,
    required this.onDeliver,
  });

  final SpecimenRow row;
  final VoidCallback onCopy;
  final VoidCallback? onOpenDetail;
  final VoidCallback onDeliver;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DemoSpecimen s = row.specimen;
    final Color accent = StatusColors.forSpecimen(context, s.status);

    final String related = row.visit == null
        ? 'İlişkili işlem bulunamadı'
        : '${Formatters.queueNumber(row.visit!.queueNumber)} · '
            '${Formatters.shortName(row.patient?.displayName ?? '-')} · '
            '${row.patient?.department ?? '-'}';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Sol kenarda ince durum şeridi (renk + etiket birlikte).
            Container(width: 5, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.science_outlined,
                            size: 20, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            s.code,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontFamily: 'monospace',
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Numune kodunu kopyala',
                          onPressed: onCopy,
                          icon: const Icon(Icons.copy_rounded, size: 20),
                        ),
                      ],
                    ),
                    Text(related,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(_timeText(s), style: theme.textTheme.bodySmall),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        StatusChip.specimen(s.status),
                        if (onOpenDetail != null)
                          TextButton.icon(
                            onPressed: onOpenDetail,
                            icon: const Icon(Icons.open_in_new_rounded,
                                size: 18),
                            label: const Text('Detay'),
                          ),
                        if (s.status == SpecimenStatus.awaitingDelivery)
                          FilledButton.tonalIcon(
                            onPressed: onDeliver,
                            icon: const Icon(Icons.local_shipping_outlined,
                                size: 18),
                            label: const Text('Teslim Et'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeText(DemoSpecimen s) {
    final String created = 'Alındı ${Formatters.time(s.createdAt)}';
    if (s.deliveredAt == null) return created;
    return '$created · Teslim ${Formatters.time(s.deliveredAt!)}';
  }
}
