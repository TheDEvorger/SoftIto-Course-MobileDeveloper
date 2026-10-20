import 'package:flutter/material.dart';

import '../../../core/extensions/theme_extensions.dart';

class ActivityPreviewCard extends StatelessWidget {
  const ActivityPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            _ActivityIcon(),
            SizedBox(width: 14),
            Expanded(child: _ActivityDescription()),
            _ComingSoonBadge(),
          ],
        ),
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: context.colors.workoutSurface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(Icons.bolt_rounded, color: context.colors.workoutAccent),
    );
  }
}

class _ActivityDescription extends StatelessWidget {
  const _ActivityDescription();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Antrenman takibi',
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Egzersiz ve kalori takibi',
          style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.elevatedSurface,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          'Yakında',
          style: TextStyle(color: context.colors.textSecondary, fontSize: 11),
        ),
      ),
    );
  }
}
