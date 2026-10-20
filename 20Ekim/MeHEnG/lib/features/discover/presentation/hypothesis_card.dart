import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/hypothesis.dart';
import 'discover_providers.dart';
import 'experiment_tile.dart';
import 'dialogs/experiment_dialog.dart';

class HypothesisCard extends ConsumerWidget {
  const HypothesisCard({required this.hypothesis, super.key});
  final Hypothesis hypothesis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiments = ref.watch(experimentsProvider(hypothesis.id));
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(hypothesis.statement),
        subtitle: Text('${experiments.length} deney · doğrulanmayı bekliyor'),
        childrenPadding: const EdgeInsets.all(12),
        children: [
          for (final experiment in experiments)
            ExperimentTile(experiment: experiment),
          if (experiments.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Bu hipotezi test etmek için bir deney planla.'),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => ExperimentDialog(hypothesisId: hypothesis.id),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Deney oluştur'),
            ),
          ),
        ],
      ),
    );
  }
}
