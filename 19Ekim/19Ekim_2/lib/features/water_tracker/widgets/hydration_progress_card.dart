import 'package:flutter/material.dart';

import '../../../core/extensions/theme_extensions.dart';
import '../controllers/water_tracker_controller.dart';
import 'quick_add_button.dart';

class HydrationProgressCard extends StatelessWidget {
  const HydrationProgressCard({super.key, required this.controller});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CardHeading(),
            const SizedBox(height: 22),
            _ProgressSummary(controller: controller),
            const SizedBox(height: 22),
            QuickAddButton(onPressed: controller.addWater),
            const SizedBox(height: 12),
            const _ServingHint(),
          ],
        ),
      ),
    );
  }
}

class _CardHeading extends StatelessWidget {
  const _CardHeading();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.water_drop_outlined, color: context.colors.accent, size: 20),
        const SizedBox(width: 8),
        Text('Günlük su hedefi', style: context.textTheme.titleLarge),
      ],
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.controller});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.currentWater,
      builder: (context, amount, _) => Row(
        children: [
          _ProgressRing(amount: amount),
          const SizedBox(width: 22),
          Expanded(child: _AmountSummary(amount: amount)),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final progress = (amount / WaterTrackerController.dailyGoalMl)
        .clamp(0.0, 1.0)
        .toDouble();
    return SizedBox(
      width: 106,
      height: 106,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 9,
            strokeCap: StrokeCap.round,
            backgroundColor: context.colors.progressRingBackground,
            valueColor: AlwaysStoppedAnimation<Color>(context.colors.accent),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: context.textTheme.titleLarge,
              ),
              Text(
                'tamamlandı',
                style: TextStyle(
                  fontSize: 9,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountSummary extends StatelessWidget {
  const _AmountSummary({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final remaining = (WaterTrackerController.dailyGoalMl - amount).clamp(
      0,
      WaterTrackerController.dailyGoalMl,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$amount', style: context.textTheme.headlineMedium),
        Text(
          'ml içildi',
          style: TextStyle(color: context.colors.textSecondary),
        ),
        const SizedBox(height: 12),
        Text(
          remaining == 0
              ? 'Harika! Günlük hedefini tamamladın.'
              : 'Hedefine $remaining ml kaldı.',
          style: TextStyle(color: context.colors.accent, fontSize: 12),
        ),
      ],
    );
  }
}

class _ServingHint extends StatelessWidget {
  const _ServingHint();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bir bardak su ekle · 250 ml',
      textAlign: TextAlign.center,
      style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
    );
  }
}
