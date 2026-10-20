import 'package:flutter/material.dart';
import '../../app/theme/meheng_theme.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    required this.title,
    required this.description,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAction = actionLabel != null && onAction != null;

    return Semantics(
      container: true,
      label: '$title. $description',
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: MehengSpacing.xs),
        child: Padding(
          padding: const EdgeInsets.all(MehengSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: theme.colorScheme.secondary),
              const SizedBox(height: MehengSpacing.sm),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MehengSpacing.xs),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              if (hasAction) ...[
                const SizedBox(height: MehengSpacing.md),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: FilledButton.tonalIcon(
                    onPressed: onAction,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(actionLabel!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
