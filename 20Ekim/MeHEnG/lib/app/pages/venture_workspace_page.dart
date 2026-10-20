import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/discover/discover.dart';
import '../../features/ventures/presentation/edit_venture_dialog.dart';
import '../../features/ventures/ventures.dart';

class VentureWorkspacePage extends ConsumerWidget {
  const VentureWorkspacePage({required this.ventureId, super.key});
  final String ventureId;

  void _confirmArchive(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Girişimi arşivle'),
        content: const Text(
          'Bu girişim ana listeden gizlenecektir. Tüm hipotez, deney ve kanıt '
          'kayıtlarınız güvenle korunur ve dilediğiniz zaman geri yüklenebilir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(ventureViewModelProvider).archive(ventureId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Girişim arşivlendi.'),
                  action: SnackBarAction(
                    label: 'Geri al',
                    onPressed: () =>
                        ref.read(ventureViewModelProvider).restore(ventureId),
                  ),
                ),
              );
            },
            child: const Text('Arşivle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venture = ref.watch(ventureProvider(ventureId));
    if (venture == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Girişim bulunamadı.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Ana sayfa',
          onPressed: () => context.go('/'),
        ),
        title: const Text('MeHEnG · Discover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Girişimi düzenle',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => EditVentureDialog(venture: venture),
            ),
          ),
          IconButton(
            icon: Icon(
              venture.isArchived
                  ? Icons.unarchive_outlined
                  : Icons.archive_outlined,
            ),
            tooltip: venture.isArchived ? 'Geri yükle' : 'Arşivle',
            onPressed: () {
              if (venture.isArchived) {
                ref.read(ventureViewModelProvider).restore(ventureId);
              } else {
                _confirmArchive(context, ref);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (venture.isArchived) ...[
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 20),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Bu girişim arşivlendi. Verileriniz korunmaktadır.',
                          ),
                        ),
                        TextButton(
                          onPressed: () => ref
                              .read(ventureViewModelProvider)
                              .restore(ventureId),
                          child: const Text('Geri Yükle'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                venture.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Problem: ${venture.problem.isEmpty ? "Henüz tanımlanmadı" : venture.problem}',
              ),
              const SizedBox(height: 8),
              Text(
                'Hedef kitle: ${venture.audience.isEmpty ? "Henüz tanımlanmadı" : venture.audience}',
              ),
              const SizedBox(height: 24),
              HypothesesSection(ventureId: ventureId),
            ],
          ),
        ),
      ),
    );
  }
}
