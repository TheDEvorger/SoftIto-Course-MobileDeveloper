// ============================================================================
// ÖRNEK EKRAN — flutter-feature-scaffold (SKILL.md Adım 4 & 5)
//
// Gerçek projedeki konumu:
//   lib/features/water_tracker/view/water_tracker_view.dart
//
// Uyulan kurallar:
//   - project.md §3.1 : Sayfa düzeyinde setState YOK, state ValueNotifier'da.
//   - project.md §3.2 : Statik widgetlarda const, build metotları < 40 satır,
//                       renk/yazı stilleri sadece temadan (Theme.of(context)).
//   - project.md §3.3 : Harici paket YOK, sadece Flutter çekirdek API'leri.
//   - project.md §6   : Karanlık / aydınlık mod için ThemeToggleButton.
//   - references/state_flow.md §3 : Controller ömrü State.dispose ile yönetilir.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../core/theme/theme_toggle_button.dart';
import '../controllers/water_tracker_controller.dart';
import '../widgets/water_tracker_card.dart';

/// Günlük su takibi ana ekranı.
class WaterTrackerView extends StatefulWidget {
  const WaterTrackerView({super.key});

  @override
  State<WaterTrackerView> createState() => _WaterTrackerViewState();
}

/// setState ÇAĞRILMAZ. Bu State sınıfı yalnızca controller'ın
/// oluşturulmasını ve dispose edilmesini (yaşam döngüsünü) yönetir.
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

/// Ekran başlığı — tamamen statik olduğu için const.
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

/// Ekle / sıfırla butonları. Sadece controller metotlarını tetikler,
/// kendi içinde hiçbir state tutmaz.
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

// ============================================================================
// BAĞIMLI DOSYALAR (bu örneğin derlenmesi için gereken dosyalar)
// ============================================================================
//
// --- lib/features/water_tracker/controllers/water_tracker_controller.dart ---
//
// import 'package:flutter/foundation.dart';
//
// class WaterTrackerController {
//   final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
//   final int dailyGoalWater = 2000; // 2 litre
//
//   void addWater() {
//     currentWater.value += 250;
//   }
//
//   void resetWater() {
//     currentWater.value = 0;
//   }
//
//   void dispose() {
//     currentWater.dispose();
//   }
// }
//
// --- lib/features/water_tracker/widgets/water_tracker_card.dart ---
//
// import 'package:flutter/material.dart';
//
// class WaterTrackerCard extends StatelessWidget {
//   const WaterTrackerCard({
//     super.key,
//     required this.currentWater,
//     required this.dailyGoal,
//   });
//
//   final int currentWater;
//   final int dailyGoal;
//
//   @override
//   Widget build(BuildContext context) {
//     final TextTheme texts = Theme.of(context).textTheme;
//     final double progress = (currentWater / dailyGoal).clamp(0.0, 1.0);
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('$currentWater / $dailyGoal ml', style: texts.headlineMedium),
//             const SizedBox(height: 16),
//             LinearProgressIndicator(
//               value: progress,
//               minHeight: 12,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             const SizedBox(height: 8),
//             Text('%${(progress * 100).round()} tamamlandı', style: texts.labelLarge),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// --- lib/core/theme/theme_toggle_button.dart ---
//   Tam içerik: project.md §6 Tema Yönetimi
// ============================================================================
