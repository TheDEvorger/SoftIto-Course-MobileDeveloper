import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/content/app_copy.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/student_preferences.dart';
import '../../../domain/repositories/preferences_repository.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/preferences_dialog.dart';
import '../../../shared/widgets/seed_notice.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  Future<void> _toggleHumorousExit(bool value) async {
    if (_repo == null || _preferences == null) return;
    final updated = _preferences!.copyWith(humorousExitEnabled: value);
    await _repo!.savePreferences(updated);
    if (mounted) {
      setState(() => _preferences = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: GardenPalette.mossEmerald),
      );
    }

    final name = _preferences?.displayName ?? 'Bahçıvan Öğrenci';
    final field = _preferences?.field ?? 'Sayısal';
    final targetNet =
        _preferences?.targetNet?.toStringAsFixed(1) ?? 'Belirlenmedi';
    final targetDate = _preferences?.targetDate;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ForestHeroCard(
          assetPath: GardenScenes.terrace,
          tag: '🌻 Bahçıvan Profili',
          title: name,
          subtitle: 'Hedef: $field Alanı • Net Hedefi: $targetNet',
          height: 190,
          actionLabel: 'Profili Düzenle ✍️',
          onAction: _openPreferences,
        ),
        const SizedBox(height: 12),
        const SeedNotice(),
        const SizedBox(height: 12),
        BotanicalSectionHeader(
          title: 'YKS Hedefin',
          subtitle: 'Hedeflenen alan ve puan/net eşikleri',
          icon: Icons.flag_outlined,
          actionText: 'Hedefi Değiştir',
          onAction: _openPreferences,
        ),
        GoldenAchievementCard(
          title: 'Hedef Alan: $field',
          subtitle: targetDate != null
              ? 'Sınav Tarihi: ${targetDate.day}.${targetDate.month}.${targetDate.year}'
              : 'Sınav tarihi henüz ayarlanmadı.',
          badgeText: '$targetNet Net',
          icon: Icons.military_tech_outlined,
          onTap: _openPreferences,
        ),
        const SizedBox(height: 14),
        const BotanicalSectionHeader(
          title: 'Bahçe Tercihleri ve Ayarlar',
          subtitle: 'Görünüm, mizah ve yerel veri yönetimi',
          icon: Icons.tune_outlined,
        ),
        GardenCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GardenPalette.mossEmerald.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.palette_outlined,
                      color: GardenPalette.mossEmerald, size: 22),
                ),
                title: const Text('Tema Modu',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Sistem / Açık Doğa / Gece Bahçesi'),
                trailing: const Icon(Icons.chevron_right),
              ),
              const Divider(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GardenPalette.peachCoral.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.sentiment_satisfied_alt,
                      color: GardenPalette.peachCoral, size: 22),
                ),
                title: const Text('Mizahi Çıkış Sözü',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text(AppCopy.optionalFarewell),
                trailing: Switch(
                  value: _preferences?.humorousExitEnabled ?? false,
                  activeTrackColor: GardenPalette.mossEmerald,
                  onChanged: _toggleHumorousExit,
                ),
              ),
              const Divider(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GardenPalette.streamTurquoise.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.security_outlined,
                      color: GardenPalette.streamTurquoise, size: 22),
                ),
                title: const Text('Veri Gizliliği (Local-First)',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text(
                    'Tüm çalışma ve deneme kayıtların cihazında yerel SQLite tablosunda saklanır.'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
