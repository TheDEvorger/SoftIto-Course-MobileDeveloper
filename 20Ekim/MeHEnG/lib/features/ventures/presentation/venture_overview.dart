import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/empty_state_card.dart';
import 'venture_providers.dart';
import 'venture_tile.dart';
import 'create_venture_dialog.dart';

class VentureOverview extends ConsumerWidget {
  const VentureOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventures = ref.watch(venturesProvider);
    final showArchived = ref.watch(showArchivedVenturesProvider);
    final width = MediaQuery.sizeOf(context).width;
    final padding = width < 600 ? 16.0 : 24.0;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 24),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fikirlerini geliştir, kanıtla, büyüt.',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Her girişim bir soruyla başlar. MeHEnG, cevabı '
                  'hipotezlerle ve gerçek deneylerle bulmana yardımcı olur.',
                ),
                const SizedBox(height: 22),
                Semantics(
                  button: true,
                  label: 'Yeni girişim oluşturma diyaloğunu aç',
                  child: FilledButton.icon(
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) => const CreateVentureDialog(),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Yeni girişim oluştur'),
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Text(
                      'Girişimlerin',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    FilterChip(
                      selected: showArchived,
                      label: const Text('Arşivlenenler'),
                      onSelected: (_) => ref
                          .read(showArchivedVenturesProvider.notifier)
                          .toggle(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (ventures.isEmpty)
                  EmptyStateCard(
                    icon: Icons.lightbulb_outline,
                    title: showArchived
                        ? 'Arşivlenmiş girişim yok'
                        : 'Henüz bir girişim yok',
                    description: showArchived
                        ? 'Daha önce arşivlediğin girişimler burada listelenir.'
                        : 'İlk fikrini oluşturarak ve hipotezlerini tanımlayarak başla.',
                    actionLabel: showArchived ? null : 'Yeni girişim oluştur',
                    onAction: showArchived
                        ? null
                        : () => showDialog<void>(
                            context: context,
                            builder: (_) => const CreateVentureDialog(),
                          ),
                  )
                else
                  for (final venture in ventures) VentureTile(venture: venture),
                const SizedBox(height: 28),
                Text(
                  'MeHEnG yolculuğu',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text('01 · Keşfet')),
                    Chip(label: Text('02 · Doğrula')),
                    Chip(label: Text('03 · İnşa et')),
                    Chip(label: Text('04 · Büyüt')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
