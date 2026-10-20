import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/page_parts.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/models/collection_status.dart';
import '../../../data/models/collection_visit.dart';
import '../../../data/models/demo_patient.dart';

enum _VisitMenu { detail, cancel }

/// Sıra listesindeki tek bir ziyaret satırı.
class VisitCard extends StatelessWidget {
  const VisitCard({
    super.key,
    required this.visit,
    required this.patient,
    required this.onOpen,
    required this.onAdvance,
    required this.onCancel,
  });

  final CollectionVisit visit;
  final DemoPatient? patient;
  final VoidCallback onOpen;
  final VoidCallback onAdvance;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? actionLabel = visit.status.nextActionLabel;
    final bool muted = visit.status.isTerminal;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Opacity(
          opacity: muted ? 0.78 : 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    QueueBadge(label: Formatters.queueNumber(visit.queueNumber)),
                    const SizedBox(width: 12),
                    Expanded(child: _PatientInfo(visit: visit, patient: patient)),
                    _buildMenu(context),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      StatusChip.visit(visit.status),
                      if (actionLabel != null)
                        FilledButton.tonalIcon(
                          onPressed: onAdvance,
                          icon: Icon(visit.status.nextActionIcon, size: 18),
                          label: Text(actionLabel),
                        )
                      else
                        Text(
                          _finishedText(visit),
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return PopupMenuButton<_VisitMenu>(
      tooltip: 'Diğer işlemler',
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (_VisitMenu item) {
        switch (item) {
          case _VisitMenu.detail:
            onOpen();
          case _VisitMenu.cancel:
            onCancel();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_VisitMenu>>[
        const PopupMenuItem<_VisitMenu>(
          value: _VisitMenu.detail,
          child: ListTile(
            leading: Icon(Icons.open_in_new_rounded),
            title: Text('Detayı Aç'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem<_VisitMenu>(
          value: _VisitMenu.cancel,
          enabled: visit.status.canCancel,
          child: const ListTile(
            leading: Icon(Icons.cancel_outlined),
            title: Text('İptal Et'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  String _finishedText(CollectionVisit visit) {
    final DateTime? at = visit.statusHistory[visit.status];
    if (at == null) return '';
    return '${visit.status.label} · ${Formatters.time(at)}';
  }
}

class _PatientInfo extends StatelessWidget {
  const _PatientInfo({required this.visit, required this.patient});

  final CollectionVisit visit;
  final DemoPatient? patient;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime? appointment = visit.appointmentAt;
    final String timeText = appointment == null
        ? 'Kayıt ${Formatters.time(visit.createdAt)}'
        : 'Kayıt ${Formatters.time(visit.createdAt)} · '
            'Randevu ${Formatters.time(appointment)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          patient?.displayName ?? 'Bilinmeyen kayıt',
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${patient?.code ?? '-'} · ${patient?.department ?? '-'}',
          style: theme.textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(timeText, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
