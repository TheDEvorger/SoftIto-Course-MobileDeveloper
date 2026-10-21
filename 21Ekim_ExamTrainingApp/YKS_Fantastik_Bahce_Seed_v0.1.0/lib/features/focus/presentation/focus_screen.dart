import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_cards.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const initialSeconds = 25 * 60;
  int remainingSeconds = initialSeconds;
  Timer? timer;
  DateTime? deadline;

  bool get running => timer != null;

  void pause() {
    if (deadline != null) {
      remainingSeconds = deadline!
          .difference(DateTime.now())
          .inSeconds
          .clamp(0, initialSeconds)
          .toInt();
    }
    timer?.cancel();
    timer = null;
    deadline = null;
    setState(() {});
  }

  void start() {
    if (running || remainingSeconds == 0) return;
    deadline = DateTime.now().add(Duration(seconds: remainingSeconds));
    timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      final next = deadline!.difference(DateTime.now()).inMilliseconds;
      final seconds = (next / 1000).ceil().clamp(0, initialSeconds).toInt();
      if (!mounted) return;
      setState(() => remainingSeconds = seconds);
      if (seconds == 0) {
        timer?.cancel();
        timer = null;
        deadline = null;
      }
    });
    setState(() {});
  }

  void reset() {
    timer?.cancel();
    timer = null;
    deadline = null;
    setState(() => remainingSeconds = initialSeconds);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orman Çalışma Odası'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ForestHeroCard(
            assetPath: GardenScenes.cottage,
            tag: '⏳ Pomodoro & Odaklanma',
            title: 'Sessiz Çalışma Kulübesi',
            subtitle: 'Dış dünyayı unut; sadece öğrenmeye ve hedefine odaklan.',
            height: 200,
          ),
          const SizedBox(height: 20),
          GardenCard(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: running
                        ? GardenPalette.peachCoral.withAlpha(25)
                        : GardenPalette.mossEmerald.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    running ? '🌿 Odaklanma Başladı' : '🌱 Hazır mısın?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: running
                          ? GardenPalette.peachCoral
                          : GardenPalette.mossEmerald,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  liveRegion: false,
                  label: 'Kalan odak süresi $minutes dakika $seconds saniye',
                  child: Text(
                    '$minutes:$seconds',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: isDark
                          ? const Color(0xFFF8F2E8)
                          : GardenPalette.inkPlum,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GardenPrimaryButton(
                      label: running ? 'Duraklat' : 'Çalışmaya Başla',
                      icon: running ? Icons.pause : Icons.play_arrow,
                      onPressed: running ? pause : start,
                      width: 190,
                    ),
                    const SizedBox(width: 14),
                    BotanicalIconButton(
                      icon: Icons.refresh,
                      tooltip: 'Sıfırla',
                      onPressed: reset,
                      size: 50,
                      iconSize: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const WaterInfoCard(
            title: 'Pomodoro Metodu',
            message:
                '25 dakika derin odaklanma ve ardından 5 dakika dinlenme döngüsü zihnini taze tutar. Oturum kayıtları TASK-008 ile yerel geçmişe kaydedilecek.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
