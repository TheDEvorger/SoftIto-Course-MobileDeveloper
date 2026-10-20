import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../domain/venture.dart';

class VentureTile extends StatelessWidget {
  const VentureTile({required this.venture, super.key});
  final Venture venture;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${venture.name} girişim çalışma alanını aç',
    child: Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/venture/${venture.id}'),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: venture.isArchived
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : null,
                child: Icon(
                  venture.isArchived
                      ? Icons.archive_outlined
                      : Icons.lightbulb_outline,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            venture.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (venture.isArchived)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Chip(
                              label: Text('Arşivlendi'),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      venture.problem.isEmpty
                          ? 'Problemi henüz tanımlanmadı.'
                          : venture.problem,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    ),
  );
}
