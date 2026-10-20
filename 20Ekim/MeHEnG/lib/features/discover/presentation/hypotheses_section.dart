import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/empty_state_card.dart';
import 'discover_providers.dart';
import 'hypothesis_card.dart';
import 'dialogs/hypothesis_dialog.dart';

class HypothesesSection extends ConsumerWidget {
  const HypothesesSection({required this.ventureId, super.key});
  final String ventureId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hypotheses = ref.watch(hypothesesProvider(ventureId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Hipotezler',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Semantics(
              button: true,
              label: 'Yeni hipotez ekleme diyaloğunu aç',
              child: FilledButton.tonalIcon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => HypothesisDialog(ventureId: ventureId),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Hipotez ekle'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (hypotheses.isEmpty)
          EmptyStateCard(
            icon: Icons.science_outlined,
            title: 'Henüz hipotez yok',
            description:
                'Test edilebilir ilk varsayımını ve riskli kabullerini yaz.',
            actionLabel: 'Hipotez ekle',
            onAction: () => showDialog<void>(
              context: context,
              builder: (_) => HypothesisDialog(ventureId: ventureId),
            ),
          )
        else
          for (final hypothesis in hypotheses)
            HypothesisCard(hypothesis: hypothesis),
      ],
    );
  }
}
