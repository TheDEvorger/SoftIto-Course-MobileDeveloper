import 'package:flutter/material.dart';

import '../../../core/widgets/status_chip.dart';

/// Dashboard sayaç kartı. Tıklanınca ilgili filtreyle sıra ekranını açar.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final int value;
  final String caption;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      button: true,
      label: '$label: $value. $caption',
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon,
                          size: 20,
                          color: StatusColors.readable(context, color)),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_outward_rounded,
                        size: 18, color: theme.colorScheme.onSurfaceVariant),
                  ],
                ),
                const SizedBox(height: 14),
                // Sayı değişince kısa bir geçiş animasyonu.
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: value.toDouble()),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutCubic,
                  builder: (BuildContext context, double v, _) => Text(
                    v.round().toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(label,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(caption,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
