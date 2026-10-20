import 'package:flutter/material.dart';

import '../../../core/theme/theme_toggle_button.dart';
import '../controllers/water_tracker_controller.dart';
import '../widgets/water_tracker_card.dart';

class WaterTrackerView extends StatefulWidget {
  const WaterTrackerView({super.key});

  @override
  State<WaterTrackerView> createState() => _WaterTrackerViewState();
}

class _WaterTrackerViewState extends State<WaterTrackerView> {
  final WaterTrackerController _controller = WaterTrackerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Susadım'),
        actions: const [ThemeToggleButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              const SizedBox(height: 24),
              ValueListenableBuilder<int>(
                valueListenable: _controller.currentWater,
                builder: (context, currentWater, _) => WaterTrackerCard(
                  currentWater: currentWater,
                  dailyGoal: _controller.dailyGoalWater,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _WaterActions(controller: _controller),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final TextTheme texts = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bugünkü Su Tüketimi', style: texts.headlineSmall),
        const SizedBox(height: 4),
        Text('Her bardak 250 ml olarak eklenir.', style: texts.bodyMedium),
      ],
    );
  }
}

class _WaterActions extends StatelessWidget {
  const _WaterActions({required this.controller});

  final WaterTrackerController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: 'reset_water',
          tooltip: 'Sıfırla',
          onPressed: controller.resetWater,
          child: const Icon(Icons.refresh_rounded),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.extended(
          heroTag: 'add_water',
          onPressed: controller.addWater,
          icon: const Icon(Icons.water_drop_rounded),
          label: const Text('+250 ml'),
        ),
      ],
    );
  }
}
