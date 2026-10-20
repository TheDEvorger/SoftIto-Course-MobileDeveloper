import 'package:flutter/material.dart';

import '../../data/models/collection_status.dart';
import '../../data/models/demo_specimen.dart';
import '../theme/app_theme.dart';

/// Durumların tema tabanlı renkleri. Renk TEK BAŞINA durum belirtmez;
/// her zaman ikon + metin etiketiyle birlikte kullanılır.
abstract final class StatusColors {
  static Color forVisit(BuildContext context, CollectionStatus status) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final VenaPalette palette = context.palette;
    return switch (status) {
      CollectionStatus.waiting => palette.secondaryText,
      CollectionStatus.called => palette.amber,
      CollectionStatus.inProgress => scheme.primary,
      CollectionStatus.sampleCollected => palette.primaryDark,
      CollectionStatus.delivered => palette.success,
      CollectionStatus.cancelled => palette.coral,
    };
  }

  static Color forSpecimen(BuildContext context, SpecimenStatus status) {
    final VenaPalette palette = context.palette;
    return switch (status) {
      SpecimenStatus.awaitingDelivery => palette.amber,
      SpecimenStatus.delivered => palette.success,
      SpecimenStatus.cancelled => palette.coral,
    };
  }

  /// Açık temada açık renklerin (ör. amber) metin kontrastını artırır.
  static Color readable(BuildContext context, Color color) {
    final ThemeData theme = Theme.of(context);
    if (theme.brightness == Brightness.dark) return color;
    return Color.lerp(color, theme.colorScheme.onSurface, 0.35)!;
  }
}

/// İkon + metin içeren, renkli durum etiketi.
class StatusChip extends StatelessWidget {
  const StatusChip.visit(CollectionStatus this.visitStatus, {super.key})
      : specimenStatus = null;

  const StatusChip.specimen(SpecimenStatus this.specimenStatus, {super.key})
      : visitStatus = null;

  final CollectionStatus? visitStatus;
  final SpecimenStatus? specimenStatus;

  @override
  Widget build(BuildContext context) {
    final CollectionStatus? visit = visitStatus;
    final SpecimenStatus? specimen = specimenStatus;

    final Color color = visit != null
        ? StatusColors.forVisit(context, visit)
        : StatusColors.forSpecimen(context, specimen!);
    final String label = visit?.label ?? specimen!.label;
    final IconData icon = visit?.icon ?? specimen!.icon;
    final Color fg = StatusColors.readable(context, color);

    return Semantics(
      label: 'Durum: $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.30)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: fg, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
