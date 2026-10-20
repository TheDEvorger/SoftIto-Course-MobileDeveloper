import 'package:flutter/material.dart';

import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/page_parts.dart';
import '../../../data/demo/clinic_state.dart';
import '../../../data/demo/demo_clinic_store.dart';

/// Ayarlar ekranı: Tema seçimi, kurgusal veriyi sıfırlama ve klinik uyarı.
class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
    required this.store,
    required this.themeController,
  });

  final DemoClinicStore store;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PageFrame(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
        children: <Widget>[
          const PageHeader(
            title: 'Ayarlar ve Sistem',
            subtitle: 'Görünüm, kurgusal demo yönetimi ve yasal bilgilendirme',
          ),
          const SizedBox(height: 12),
          _ThemeSection(themeController: themeController),
          const SizedBox(height: 16),
          _DemoDataSection(store: store),
          const SizedBox(height: 16),
          const _MedicalDisclaimerSection(),
          const SizedBox(height: 16),
          _AboutSection(theme: theme),
        ],
      ),
    );
  }
}

class _ThemeSection extends StatelessWidget {
  const _ThemeSection({required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.mode,
      builder: (BuildContext context, ThemeMode currentMode, _) {
        return SectionCard(
          title: 'Görünüm ve Tema',
          icon: Icons.palette_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Uygulama arayüzünün tema modunu belirleyin:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              SegmentedButton<ThemeMode>(
                segments: const <ButtonSegment<ThemeMode>>[
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    label: Text('Sistem'),
                    icon: Icon(Icons.brightness_auto_outlined),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text('Aydınlık'),
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text('Karanlık'),
                    icon: Icon(Icons.dark_mode_outlined),
                  ),
                ],
                selected: <ThemeMode>{currentMode},
                onSelectionChanged: (Set<ThemeMode> newSelection) {
                  themeController.setMode(newSelection.first);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DemoDataSection extends StatelessWidget {
  const _DemoDataSection({required this.store});

  final DemoClinicStore store;

  Future<void> _showResetDialog(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        icon: const Icon(Icons.restart_alt_rounded, size: 36),
        title: const Text('Demoyu Sıfırla'),
        content: const Text(
          'Tüm kurgusal hasta, sıra ve numune hareketleri ilk başlangıç durumuna '
          'döndürülecektir. Devam etmek istiyor musunuz?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Evet, Sıfırla'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      store.reset();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Demo verileri ilk durumuna başarıyla döndürüldü.'),
            duration: Duration(seconds: 3),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ClinicState>(
      valueListenable: store.state,
      builder: (BuildContext context, ClinicState state, _) {
        return SectionCard(
          title: 'Kurgusal Demo Verisi',
          icon: Icons.storage_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Aktif bellek veritabanında ${state.patients.length} kayıtlı kurgusal hasta, '
                '${state.visits.length} işlem kaydı ve ${state.specimens.length} numune bulunuyor.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                key: const Key('reset_demo_button'),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Tüm Demo Verilerini Sıfırla'),
                onPressed: () => _showResetDialog(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MedicalDisclaimerSection extends StatelessWidget {
  const _MedicalDisclaimerSection();

  @override
  Widget build(BuildContext context) {
    return const InfoBanner(
      icon: Icons.verified_user_outlined,
      title: 'Tıbbi Uyarı ve Eğitim Bildirimi',
      message:
          'VenaFlow, SoftIto Mobil Geliştirici Eğitimi kapsamında kurgusal olarak '
          'hazırlanmış bir arayüz ve akış prototipidir. Tıbbi karar desteği, gerçek tahlil '
          'sonucu veya tedavi tavsiyesi sunmaz. Gerçek klinik operasyonlar için '
          'kullanılamaz. Tüm kimlik ve işlem verileri yapaydır.',
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Uygulama Bilgisi',
      icon: Icons.info_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.bloodtype_rounded,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'VenaFlow',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'v1.0.0 Demo',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Kan Alma Birimi ve Numune Takip Sistemi Arayüz Demosu.\n'
            'Material 3 mimarisi ve reaktif durum yönetimi ile hazırlanmıştır.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
