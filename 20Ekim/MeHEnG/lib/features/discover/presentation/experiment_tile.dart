import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/experiment.dart';
import '../domain/evidence.dart';
import 'discover_providers.dart';
import 'dialogs/evidence_dialog.dart';

class ExperimentTile extends ConsumerWidget {
  const ExperimentTile({required this.experiment, super.key});
  final Experiment experiment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(evidenceProvider(experiment.id));
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              experiment.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text('Yöntem: ${experiment.method}'),
            const SizedBox(height: 12),
            for (final record in records)
              ListTile(
                dense: true,
                leading: Icon(_icon(record.direction)),
                title: Text(record.note),
                subtitle: Text(
                  record.source != null && record.source!.isNotEmpty
                      ? '${_label(record.direction)} · Kaynak: ${record.source}'
                      : _label(record.direction),
                ),
              ),
            if (records.isEmpty) const Text('Henüz kaydedilmiş kanıt yok.'),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => EvidenceDialog(experimentId: experiment.id),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Kanıt ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _label(EvidenceDirection d) => switch (d) {
    EvidenceDirection.supports => 'Destekliyor',
    EvidenceDirection.contradicts => 'Çelişiyor',
    EvidenceDirection.neutral => 'Nötr',
  };
  IconData _icon(EvidenceDirection d) => switch (d) {
    EvidenceDirection.supports => Icons.check_circle_outline,
    EvidenceDirection.contradicts => Icons.report_outlined,
    EvidenceDirection.neutral => Icons.remove_circle_outline,
  };
}
