import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/content/app_copy.dart';
import '../../../core/database/backup_service.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../domain/models/student_preferences.dart';
import '../../../domain/repositories/preferences_repository.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/preferences_dialog.dart';
import '../../../shared/widgets/seed_notice.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    this.preferencesRepository,
    this.backupService,
    super.key,
  });

  final PreferencesRepository? preferencesRepository;
  final BackupService? backupService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StudentPreferences? _preferences;
  PreferencesRepository? _prefRepo;
  BackupService? _backupService;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initRepos();
  }

  Future<void> _initRepos() async {
    try {
      if (widget.preferencesRepository != null &&
          widget.backupService != null) {
        _prefRepo = widget.preferencesRepository;
        _backupService = widget.backupService;
      } else {
        final db = await GardenDatabaseProvider.instance.database;
        _prefRepo = widget.preferencesRepository ?? PreferencesRepository(db);
        _backupService = widget.backupService ?? BackupService(db);
      }
      await _loadPreferences();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadPreferences() async {
    if (_prefRepo == null) return;
    setState(() => _loading = true);
    final prefs = await _prefRepo!.getPreferences();
    if (mounted) {
      setState(() {
        _preferences = prefs;
        _loading = false;
      });
      AppThemeController.instance.updateFromPreference(prefs.themeMode);
    }
  }

  Future<void> _openPreferences() async {
    if (_prefRepo == null) return;
    final updated = await PreferencesDialog.show(
      context,
      repository: _prefRepo!,
      initialPreferences: _preferences,
    );
    if (updated != null && mounted) {
      setState(() => _preferences = updated);
      AppThemeController.instance.updateFromPreference(updated.themeMode);
    }
  }

  Future<void> _selectThemeMode() async {
    if (_prefRepo == null || _preferences == null) return;

    final selected = await showDialog<ThemeModePreference>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Tema Modu Seç'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop(ThemeModePreference.system),
            child: const Text('📱 Sistem Teması'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop(ThemeModePreference.light),
            child: const Text('🌿 Açık Doğa Bahçesi'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(ctx).pop(ThemeModePreference.dark),
            child: const Text('🌙 Gece Bahçesi'),
          ),
        ],
      ),
    );

    if (selected != null) {
      final updated = _preferences!.copyWith(themeMode: selected);
      await _prefRepo!.savePreferences(updated);
      AppThemeController.instance.updateFromPreference(selected);
      if (mounted) {
        setState(() => _preferences = updated);
      }
    }
  }

  Future<void> _toggleHumorousExit(bool value) async {
    if (_prefRepo == null || _preferences == null) return;
    final updated = _preferences!.copyWith(humorousExitEnabled: value);
    await _prefRepo!.savePreferences(updated);
    if (mounted) {
      setState(() => _preferences = updated);
    }
  }

  Future<void> _exportData() async {
    if (_backupService == null) return;

    final jsonStr = await _backupService!.exportAllDataAsJson();

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('📦 Yerel Veri Yedeği (JSON)'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tüm profil, konu ilerlemeleri, deneme ve odak verilerin başarıyla dışa aktarıldı:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 10),
              Container(
                height: 160,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    jsonStr,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Panoya Kopyala'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonStr));
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Yedek panoya kopyalandı.'),
                  backgroundColor: GardenPalette.mossEmerald,
                ),
              );
            },
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearData() async {
    if (_backupService == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Tüm Verileri Sıfırla'),
        content: const Text(
          'Bu işlem geri alınamaz.\n\nTüm deneme kayıtların, konu tamamlama verilerin, günlük planların ve odak oturumların kalıcı olarak silinecektir.\n\nEmin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Evet, Tümünü Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _backupService!.clearAllUserData();
      await _loadPreferences();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🧹 Tüm yerel veriler sıfırlandı.'),
          ),
        );
      }
    }
  }

  String get _themeModeLabel {
    switch (_preferences?.themeMode) {
      case ThemeModePreference.light:
        return '🌿 Açık Doğa Bahçesi';
      case ThemeModePreference.dark:
        return '🌙 Gece Bahçesi';
      case ThemeModePreference.system:
      default:
        return '📱 Sistem Teması';
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

    return Material(
      color: Colors.transparent,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ForestHeroCard(
            assetPath: GardenScenes.terrace,
            tag: '🌻 Bahçıvan Profili',
            title: name,
            subtitle: 'Hedef: $field Alanı • Net Hedefi: $targetNet',
            height: 220,
            actionLabel: 'Profili Düzenle ✍️',
            onAction: _openPreferences,
          ),
          const SizedBox(height: 12),
          const SeedNotice(),
          const SizedBox(height: 12),

          // YKS Goal Header & Card
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

          // Preferences and App Settings Header
          const BotanicalSectionHeader(
            title: 'Bahçe Tercihleri ve Ayarlar',
            subtitle: 'Görünüm, mizah ve yerel veri yönetimi',
            icon: Icons.tune_outlined,
          ),
          GardenCard(
            child: Column(
              children: [
                // Theme Mode Selector
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: GardenPalette.mossEmerald.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.palette_outlined,
                      color: GardenPalette.mossEmerald,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Tema Modu',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(_themeModeLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _selectThemeMode,
                ),
                const Divider(height: 16),

                // Humorous Farewell Switch
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: GardenPalette.peachCoral.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.sentiment_satisfied_alt,
                      color: GardenPalette.peachCoral,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Mizahi Çıkış Sözü',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Kullanıcının tercihine bağlı mizahi söz',
                  ),
                  trailing: Switch(
                    value: _preferences?.humorousExitEnabled ?? false,
                    activeTrackColor: GardenPalette.mossEmerald,
                    onChanged: _toggleHumorousExit,
                  ),
                ),

                // Preview card if enabled
                if (_preferences?.humorousExitEnabled == true) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: GardenPalette.peachCoral.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: GardenPalette.peachCoral.withAlpha(60),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: GardenPalette.peachCoral,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppCopy.optionalFarewell,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Data Privacy & Management Section
          const BotanicalSectionHeader(
            title: 'Yerel Veri ve Gizlilik',
            subtitle: 'Kişisel verilerin yalnızca cihazında saklanır',
            icon: Icons.security_outlined,
          ),
          GardenCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: GardenPalette.streamTurquoise.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.file_download_outlined,
                      color: GardenPalette.streamTurquoise,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Yerel Verileri Dışa Aktar (JSON)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Tüm kayıtlarını kayıpsız JSON formatında yedekle',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _exportData,
                ),
                const Divider(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Tüm Verileri Sıfırla',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                  subtitle: const Text(
                    'Denemeleri, hedefleri ve konu kayıtlarını sil',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _confirmClearData,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Privacy Guarantee Card
          const WaterInfoCard(
            title: 'Gizlilik ve Sıfır Takip Taahhüdü',
            message:
                'Fantastik Bahçe YKS, verilerini üçüncü taraf sunuculara göndermez. Reklam SDK’sı, kullanıcı takip kodu veya gizli veri toplama içermez.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
