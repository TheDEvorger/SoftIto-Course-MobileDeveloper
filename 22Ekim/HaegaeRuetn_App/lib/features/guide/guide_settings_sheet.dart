import 'package:flutter/material.dart';

import '../../core/services/ai/ai_chat_controller.dart';
import '../../core/theme/realm_theme.dart';
import '../../core/widgets/ornate_widgets.dart';

/// Bottom sheet dialog for configuring AI connection, privacy, and custom instructions.
class GuideSettingsSheet extends StatefulWidget {
  const GuideSettingsSheet({super.key, required this.controller});

  final AiChatController controller;

  @override
  State<GuideSettingsSheet> createState() => _GuideSettingsSheetState();
}

class _GuideSettingsSheetState extends State<GuideSettingsSheet> {
  late final TextEditingController _urlController;
  late final TextEditingController _instructionsController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.controller.workerUrl);
    _instructionsController =
        TextEditingController(text: widget.controller.customInstructions ?? '');
  }

  @override
  void dispose() {
    _urlController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _save() {
    widget.controller.setWorkerUrl(_urlController.text.trim());
    widget.controller
        .setCustomInstructions(_instructionsController.text.trim());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    return Padding(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 10,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune_rounded,
                    color: RealmPalette.gold, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rehber & Yapay Zekâ Ayarları',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Cloudflare Worker URL field
            const Text(
              'Cloudflare Worker URL (Güvenli Geçit):',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                hintText: 'https://haegaruuetn-proxy.your-name.workers.dev',
                prefixIcon: Icon(Icons.cloud_outlined, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'GroqCloud API anahtarınız bu Worker üzerinde saklanır; mobil uygulamaya hiçbir secret gömülmez.',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            // Privacy: Habit context sharing
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              activeTrackColor: RealmPalette.gold,
              title: const Text(
                'Alışkanlık Bağlamını Paylaş',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              subtitle: const Text(
                'Yalnızca mevcut rütbe ve aktif vazife özetini rehbere iletir. Tam veritabanı asla gönderilmez.',
                style: TextStyle(fontSize: 11.5, color: Colors.black54),
              ),
              value: c.shareHabitContext,
              onChanged: (val) {
                setState(() => c.toggleShareHabitContext(val));
              },
            ),
            const Divider(height: 16),
            // Plain Turkish Mode
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              activeTrackColor: RealmPalette.gold,
              title: const Text(
                'Sade Türkçe Yanıtlar',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              subtitle: const Text(
                'Fantezi krallık lisanı yerine modern, doğrudan Türkçe ile yanıt verir.',
                style: TextStyle(fontSize: 11.5, color: Colors.black54),
              ),
              value: c.usePlainTurkish,
              onChanged: (val) {
                setState(() => c.togglePlainTurkish(val));
              },
            ),
            const Divider(height: 16),
            // Custom instructions
            const Text(
              'Özel Talimatlar (İsteğe bağlı):',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _instructionsController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText:
                    'Örn: Yanıtlarını hep 2 cümleden kısa tut, her seferinde beni adımla an...',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      side: const BorderSide(color: Color(0xFFC7BBA5)),
                    ),
                    icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                    label: const Text('Sohbeti Sil'),
                    onPressed: () {
                      c.clearChat();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OrnateButton(
                    label: 'Kaydet',
                    icon: Icons.check_rounded,
                    onPressed: _save,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
