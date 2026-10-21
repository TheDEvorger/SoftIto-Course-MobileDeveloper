import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/content/app_copy.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/student_preferences.dart';
import '../../../domain/repositories/preferences_repository.dart';
import '../../../shared/widgets/countdown_card.dart';
import '../../../shared/widgets/garden_buttons.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/garden_progress.dart';
import '../../../shared/widgets/preferences_dialog.dart';
import '../../../shared/widgets/seed_notice.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.onStartFocus, super.key});
  final VoidCallback onStartFocus;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StudentPreferences? _preferences;
  PreferencesRepository? _repo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final db = await GardenDatabaseProvider.instance.database;
      _repo = PreferencesRepository(db);
      final prefs = await _repo!.getPreferences();
      if (mounted) {
        setState(() {
          _preferences = prefs;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _preferences = const StudentPreferences();
          _loading = false;
        });
      }
    }
  }

  Future<void> _openPreferences() async {
    if (_repo == null) return;
    final updated = await PreferencesDialog.show(
      context,
      repository: _repo!,
      initialPreferences: _preferences,
    );
    if (updated != null && mounted) {
      setState(() => _preferences = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _preferences?.displayName;
    final welcomeTitle = name != null && name.isNotEmpty
        ? 'Merhaba, $name! 🌱'
        : 'Bugün senin günün! 🌱';
    final field = _preferences?.field ?? 'Sayısal';

    return ListView(
      key: const PageStorageKey<String>('home'),
      padding: const EdgeInsets.all(16),
      children: [
        ForestHeroCard(
          assetPath: GardenScenes.sunrise,
          tag: '🌿 $field Alanı',
          title: welcomeTitle,
          subtitle: AppCopy.welcome,
          actionLabel: 'Odak Odasına Gir ⏳',
          onAction: widget.onStartFocus,
          height: 220,
        ),
        const SizedBox(height: 12),
        const SeedNotice(),
        const SizedBox(height: 12),
        BotanicalSectionHeader(
          title: 'YKS Geri Sayım Sayacı',
          subtitle: 'Kişiselleştirilmiş hedef sınav tarihi',
          icon: Icons.hourglass_top,
          actionText: 'Tarihi Ayarla',
          onAction: _openPreferences,
        ),
        if (_loading)
          const GardenCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        else
          YksCountdownCard(
            targetDate: _preferences?.targetDate,
            onEditDate: _openPreferences,
          ),
        const SizedBox(height: 14),
        const BotanicalSectionHeader(
          title: 'Günün Hedefleri',
          subtitle: 'Her gün küçük bir filizlenme',
          icon: Icons.check_circle_outline,
        ),
        GardenCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bugünkü Plan',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  Text('0 / 120 Soru',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: GardenPalette.mossEmerald)),
                ],
              ),
              const SizedBox(height: 8),
              const LeafProgressBar(
                progress: 0.0,
                label: 'Soru hedefi ilerlemesi',
              ),
              const SizedBox(height: 8),
              Text(
                'Günlük görevlerin ve çalışma planın TASK-009 ile aktifleşecek.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GoldenAchievementCard(
          title:
              'Hedef Net: ${_preferences?.targetNet?.toStringAsFixed(1) ?? 'Belirlenmedi'}',
          subtitle:
              'İlk denemeni kaydettiğinde ve konu bitirdiğinde burada parlayacak.',
          badgeText: field,
          progressText: _preferences?.targetDate != null
              ? 'Hedef takvimi devrede'
              : 'Tarih ve net hedefini belirle',
          onTap: _openPreferences,
        ),
        const SizedBox(height: 20),
        GardenPrimaryButton(
          label: 'Odak Odasını Başlat (Pomodoro)',
          icon: Icons.timer_outlined,
          onPressed: widget.onStartFocus,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
