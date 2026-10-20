import 'package:flutter/material.dart';

import '../../../core/extensions/theme_extensions.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/water_tracker_controller.dart';
import '../widgets/activity_preview_card.dart';
import '../widgets/hydration_progress_card.dart';
import '../widgets/recent_intakes_card.dart';
import '../widgets/section_title.dart';

class WaterTrackerView extends StatefulWidget {
  const WaterTrackerView({
    super.key,
    this.themeController,
  });

  final ThemeController? themeController;

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardHeader(
                onReset: _controller.resetDay,
                themeController: widget.themeController,
              ),
              const SizedBox(height: 26),
              HydrationProgressCard(controller: _controller),
              const SizedBox(height: 30),
              const SectionTitle(title: 'Bugünkü içimler'),
              const SizedBox(height: 14),
              RecentIntakesCard(controller: _controller),
              const SizedBox(height: 30),
              const SectionTitle(title: 'Hareket ve kalori'),
              const SizedBox(height: 14),
              const ActivityPreviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.onReset,
    this.themeController,
  });

  final VoidCallback onReset;
  final ThemeController? themeController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _BrandMark(),
        const SizedBox(width: 12),
        const Expanded(child: _Greeting()),
        if (themeController != null)
          _ThemeToggleButton(themeController: themeController!),
        IconButton(
          tooltip: 'Günlük takibi sıfırla',
          onPressed: () => _confirmReset(context, onReset),
          icon: const Icon(Icons.restart_alt_rounded),
        ),
      ],
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    VoidCallback onReset,
  ) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Günü sıfırla?'),
        content: const Text('Bugünkü su kayıtların silinecek.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
    if (shouldReset == true && context.mounted) {
      onReset();
    }
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton({required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.themeMode,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          tooltip: isDark ? 'Aydınlık moda geç' : 'Karanlık moda geç',
          onPressed: themeController.toggleTheme,
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? const Color(0xFFFFD54F) : const Color(0xFF5C6BC0),
          ),
        );
      },
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: context.colors.brandSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.water_drop_rounded, color: context.colors.accent),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SUSADIM', style: context.textTheme.labelSmall),
        const SizedBox(height: 3),
        Text('Bugün kendine iyi bak.', style: context.textTheme.bodyMedium),
      ],
    );
  }
}
