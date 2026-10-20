import 'package:flutter/material.dart';

/// Sayfa içeriğini güvenli alana yerleştirir ve geniş ekranda
/// okunabilir bir maksimum genişlikle ortalar.
class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.child, this.maxWidth = 1120});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

/// Sekme sayfalarının üst başlığı.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Semantics(
                  header: true,
                  child: Text(title, style: theme.textTheme.headlineSmall),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Başlıklı içerik kartı.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.all(16),
  });

  final String title;
  final IconData? icon;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Sıra numarası rozeti (ör. `S-007`).
class QueueBadge extends StatelessWidget {
  const QueueBadge({super.key, required this.label, this.large = false});

  final String label;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16 : 10,
        vertical: large ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(large ? 14 : 10),
      ),
      child: Text(
        label,
        style: (large
                ? theme.textTheme.headlineSmall
                : theme.textTheme.titleSmall)
            ?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w800,
          fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
