import 'package:flutter/material.dart';

class WaterTrackerCard extends StatelessWidget {
  const WaterTrackerCard({
    super.key,
    required this.currentWater,
    required this.dailyGoal,
  });

  final int currentWater;
  final int dailyGoal;

  @override
  Widget build(BuildContext context) {
    final TextTheme texts = Theme.of(context).textTheme;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final double progress = (currentWater / dailyGoal).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop_rounded, size: 48, color: colors.primary),
            const SizedBox(height: 12),
            Text(
              '$currentWater / $dailyGoal ml',
              style: texts.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: colors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              '%${(progress * 100).round()} tamamlandı',
              style: texts.labelLarge?.copyWith(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
