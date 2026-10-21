import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/design/studio_page.dart';

class WorkspaceAccessPanel extends StatefulWidget {
  const WorkspaceAccessPanel(
      {super.key,
      required this.api,
      required this.onChanged,
      required this.onExamples});
  final ApiClient api;
  final VoidCallback onChanged, onExamples;
  @override
  State<WorkspaceAccessPanel> createState() => _WorkspaceAccessPanelState();
}

class _WorkspaceAccessPanelState extends State<WorkspaceAccessPanel> {
  final _key = TextEditingController();
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (_key.text.trim().isEmpty) {
      setState(() => _error = 'Çalışma alanı anahtarını girin.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.api.connectWorkspace(_key.text.trim());
      _key.clear();
      if (mounted) widget.onChanged();
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => StudioPanel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Icon(widget.api.examples ? Icons.layers_outlined : Icons.key_outlined,
            size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 20),
        Text(widget.api.examples ? 'Örnek çalışma alanı' : 'Çalışma alanınız',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Text(widget.api.examples
            ? 'Koleksiyonu keşfedin, rezervasyon oluşturun ve araçları yönetin. '
                'Buradaki tüm kayıtlar kurgusaldır. Yaptığınız değişiklikler ayrı örnek veritabanında saklanır.'
            : widget.api.authenticated
                ? 'Özel çalışma alanınıza bağlısınız.'
                : 'Özel envanterinize erişin veya hazır örnek kayıtlarla başlayın.'),
        const SizedBox(height: 24),
        if (!widget.api.authenticated || widget.api.examples) ...[
          TextField(
              controller: _key,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              enabled: !_busy,
              decoration: const InputDecoration(
                  labelText: 'Çalışma alanı anahtarı',
                  prefixIcon: Icon(Icons.lock_outline)),
              onSubmitted: _busy ? null : (_) => _connect()),
          const SizedBox(height: 14),
          FilledButton.icon(
              onPressed: _busy ? null : _connect,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: Text(_busy ? 'Bağlanıyor…' : 'Çalışma alanına bağlan')),
        ],
        if (widget.api.authenticated) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
              onPressed: _busy
                  ? null
                  : () {
                      widget.api.workspaceKey = null;
                      _key.clear();
                      widget.onChanged();
                    },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Bağlantıyı kapat')),
        ],
        if (!widget.api.examples) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
              onPressed: _busy ? null : widget.onExamples,
              icon: const Icon(Icons.layers_outlined, size: 18),
              label: const Text('Örnek çalışma alanını aç')),
        ],
        if (_error != null)
          Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Semantics(
                  liveRegion: true,
                  child: Text(_error!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)))),
        const Divider(height: 40),
        const Text('Anahtar yalnızca bu oturumda kullanılır.',
            style: TextStyle(fontSize: 12)),
        const ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text('Özel çalışma alanına bağlantı'),
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                      'Proje dizinindeki .local/operator.key dosyasının içeriğini anahtar alanına girin. '
                      'Anahtar özel çalışma alanındaki tüm kayıtlara erişir; paylaşmayın. '
                      'Örnek alanın erişimi özel verilerinize ulaşamaz.')),
            ]),
      ]));
}
