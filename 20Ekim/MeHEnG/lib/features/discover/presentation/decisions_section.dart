import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/empty_state_card.dart';
import 'decision_card.dart';
import 'dialogs/decision_dialog.dart';
import 'discover_providers.dart';

class DecisionsSection extends ConsumerWidget {
  const DecisionsSection({required this.ventureId, super.key});
  final String ventureId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisions = ref.watch(decisionsProvider(ventureId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Karar Günlüğü',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Semantics(
              button: true,
              label: 'Yeni stratejik karar ekleme diyaloğunu aç',
              child: FilledButton.tonalIcon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => DecisionDialog(ventureId: ventureId),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Karar ekle'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (decisions.isEmpty)
          EmptyStateCard(
            icon: Icons.psychology_outlined,
            title: 'Henüz stratejik karar yok',
            description:
                'Toplanan kanıtlara dayanarak devam et, yön değiştir (pivot) veya sonlandır kararı kaydedin.',
            actionLabel: 'Karar ekle',
            onAction: () => showDialog<void>(
              context: context,
              builder: (_) => DecisionDialog(ventureId: ventureId),
            ),
          )
        else
          for (final decision in decisions)
            DecisionCard(decision: decision, ventureId: ventureId),
      ],
    );
  }
}
