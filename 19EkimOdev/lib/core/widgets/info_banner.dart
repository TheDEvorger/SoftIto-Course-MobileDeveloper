import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Bilgilendirme / uyarı bandı (ör. "Eğitim demosudur" açıklaması).
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline_rounded,
    this.title,
    this.warning = false,
  });

  final String message;
  final String? title;
  final IconData icon;

  /// `true` ise amber (dikkat) rengi kullanılır.
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color =
        warning ? context.palette.amber : theme.colorScheme.primary;
    final Color fg = theme.brightness == Brightness.dark
        ? color
        : Color.lerp(color, theme.colorScheme.onSurface, 0.35)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (title != null) ...<Widget>[
                  Text(title!,
                      style: theme.textTheme.titleSmall?.copyWith(color: fg)),
                  const SizedBox(height: 2),
                ],
                Text(message,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
