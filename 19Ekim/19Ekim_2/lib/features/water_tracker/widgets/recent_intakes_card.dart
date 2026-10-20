import 'package:flutter/material.dart';

import '../../../core/extensions/theme_extensions.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_intake.dart';

class RecentIntakesCard extends StatelessWidget {
  const RecentIntakesCard({super.key, required this.controller});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WaterIntake>>(
      valueListenable: controller.intakes,
      builder: (context, intakes, _) => Card(
        child: intakes.isEmpty
            ? const _EmptyIntakes()
            : Column(
                children: [
                  for (var i = 0; i < intakes.length && i < 3; i++)
                    _IntakeRow(
                      intake: intakes[i],
                      showDivider: i < intakes.length - 1 && i < 2,
                    ),
                ],
              ),
      ),
    );
  }
}

class _EmptyIntakes extends StatelessWidget {
  const _EmptyIntakes();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      child: Row(
        children: [
          Icon(Icons.local_drink_outlined, color: context.colors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Henüz kayıt yok. İlk bardağını ekleyerek başlayabilirsin.',
              style: TextStyle(color: context.colors.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntakeRow extends StatelessWidget {
  const _IntakeRow({required this.intake, required this.showDivider});

  final WaterIntake intake;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(intake.recordedAt).format(context);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: context.colors.accentMuted,
            child: Icon(
              Icons.water_drop_rounded,
              color: context.colors.accent,
              size: 20,
            ),
          ),
          title: Text(
            '${intake.amountMl} ml',
            style: context.textTheme.titleLarge,
          ),
          subtitle: Text(
            time,
            style: TextStyle(color: context.colors.textSecondary),
          ),
          trailing: Icon(
            Icons.check_circle,
            color: context.colors.success,
            size: 20,
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 72, endIndent: 18),
      ],
    );
  }
}
