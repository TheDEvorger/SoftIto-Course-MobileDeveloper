import 'package:flutter/material.dart';
import '../domain/demo_handover.dart';

/// Araç teslim alma (Handover) simülasyon ekranı.
/// Ön koşulların işaretlenmesi, 20 açılı araç incelemesinin açılması,
/// dijital kilit simülasyonu ve karşılıklı kabul onayını yönetir.
class HandoverDemoScreen extends StatefulWidget {
  const HandoverDemoScreen(
      {super.key,
      required this.bookingId,
      required this.isBookingConfirmed,
      this.openInspection});

  /// Teslim alınacak rezervasyon kimliği
  final String bookingId;

  /// Rezervasyonun hala onaylı olup olmadığını kontrol eden fonksiyon
  final bool Function() isBookingConfirmed;

  /// 20 açılı inceleme ekranını açan fonksiyon
  final Future<bool> Function(BuildContext)? openInspection;

  @override
  State<HandoverDemoScreen> createState() => _HandoverDemoScreenState();
}

class _HandoverDemoScreenState extends State<HandoverDemoScreen> {
  // Aktif teslim oturumu modeli
  DemoHandover _session = DemoHandover(HandoverMode.physical);

  // Ön kontrol koşul bayrakları
  bool _window = false, _driver = false, _ready = false, _compatible = false;

  // Tamamlama gereksinimleri bayrakları
  bool _inspection = false,
      _readings = false,
      _parties = false,
      _accept = false;

  // Durum ve geri bildirim mesajı
  String _message = 'Ön koşulları temsili olarak işaretleyin.';

  void _run(VoidCallback action, String success) {
    try {
      action();
      setState(() => _message = success);
    } on StateError catch (e) {
      setState(() => _message = e.message);
    }
  }

  Widget _check(String label, bool value, ValueChanged<bool> update) =>
      SwitchListTile(
          title: Text(label),
          value: value,
          onChanged: (next) => setState(() {
                update(next);
                _session.invalidate();
                _message = 'Koşul değişti; ön kontrolü yeniden çalıştırın.';
              }));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Teslim simülasyonu • DEMO')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Text('Örnek rezervasyon: ${widget.bookingId}'),
          const Text('Gerçek anahtar, kilit komutu veya sürüş başlatma yok. '
              'Tüm onaylar ve koşullar simülasyondur.'),
          const SizedBox(height: 16),
          DropdownButtonFormField<HandoverMode>(
            initialValue: _session.mode,
            decoration:
                const InputDecoration(labelText: 'Örnek teslim yöntemi'),
            items: const [
              DropdownMenuItem(
                  value: HandoverMode.physical, child: Text('Fiziksel teslim')),
              DropdownMenuItem(
                  value: HandoverMode.digital, child: Text('Dijital teslim')),
            ],
            onChanged: (mode) => setState(() {
              _session = DemoHandover(mode!);
              _inspection = _readings = _parties = _accept = false;
              _message = 'Teslim yöntemi değişti; onayları yeniden tamamlayın.';
            }),
          ),
          _check('Örnek teslim zamanı uygun', _window, (v) => _window = v),
          _check('Örnek sürücü yetkili', _driver, (v) => _driver = v),
          _check('Örnek araç koşulları uygun', _ready, (v) => _ready = v),
          if (_session.mode == HandoverMode.digital)
            _check('Örnek donanım uyumlu', _compatible, (v) => _compatible = v),
          FilledButton(
              onPressed: () => _run(
                  () => _session.preflight(HandoverPrerequisites(
                      bookingConfirmed: widget.isBookingConfirmed(),
                      pickupWindow: _window,
                      driverAuthorized: _driver,
                      vehicleReady: _ready,
                      compatible: _compatible)),
                  'Örnek ön kontrol geçti.'),
              child: const Text('Demo ön kontrolü çalıştır')),
          if (_session.mode == HandoverMode.digital) ...[
            Text('Temsili kilit durumu: ${_session.lock.name}'),
            OutlinedButton(
                onPressed: () => _run(
                    () => _session.acknowledgeDemoUnlock(accepted: true),
                    'Yalnızca temsili kilit onayı alındı.'),
                child: const Text('Olumlu kilit yanıtını simüle et')),
            OutlinedButton(
                onPressed: () => _run(
                    () => _session.acknowledgeDemoUnlock(accepted: false),
                    'Temsili kilit yanıtı olumsuz; devam edilemez.'),
                child: const Text('Olumsuz kilit yanıtını simüle et')),
            OutlinedButton(
                onPressed: () => _run(_session.connectionLost,
                    'Bağlantı belirsiz; yeniden ön kontrol ve temsili onay gerekli.'),
                child: const Text('Bağlantı kaybını simüle et')),
          ],
          OutlinedButton(
              onPressed: widget.openInspection == null
                  ? null
                  : () async {
                      setState(() {
                        _inspection = false;
                        _session.invalidateCompletion();
                      });
                      final complete = await widget.openInspection!(context);
                      if (!mounted) return;
                      setState(() {
                        _inspection = complete;
                        _message = complete
                            ? '20/20 örnek inceleme kabul edildi.'
                            : 'İnceleme tamamlanmadı; taslağa devam edebilirsiniz.';
                      });
                    },
              child: Text(_inspection
                  ? 'İnceleme 20/20 • Yeniden aç'
                  : '20 açılı inceleme demosunu aç')),
          SwitchListTile(
              title: const Text('Örnek sayaç ve enerji kaydedildi'),
              value: _readings,
              onChanged: (v) => setState(() {
                    _readings = v;
                    _session.invalidateCompletion();
                    _message =
                        'Onay değişti; teslim demosunu yeniden kontrol edin.';
                  })),
          if (_session.mode == HandoverMode.physical)
            SwitchListTile(
                title: const Text('Örnek teslim tarafları doğrulandı'),
                value: _parties,
                onChanged: (v) => setState(() {
                      _parties = v;
                      _session.invalidateCompletion();
                      _message =
                          'Onay değişti; teslim demosunu yeniden kontrol edin.';
                    })),
          SwitchListTile(
              title: const Text('Örnek karşılıklı kabul verildi'),
              value: _accept,
              onChanged: (v) => setState(() {
                    _accept = v;
                    _session.invalidateCompletion();
                    _message =
                        'Onay değişti; teslim demosunu yeniden kontrol edin.';
                  })),
          FilledButton(
              onPressed: () => _run(
                  () => _session.finish(
                      bookingStillConfirmed: widget.isBookingConfirmed(),
                      inspectionComplete: _inspection,
                      readingsRecorded: _readings,
                      partiesVerified: _parties,
                      mutualAcceptance: _accept),
                  'Simülasyon tamamlandı. Gerçek sürüş başlatılmadı.'),
              child: const Text('Teslim demosunu tamamla')),
          const SizedBox(height: 16),
          Semantics(liveRegion: true, child: Text(_message)),
        ]),
      );
}
