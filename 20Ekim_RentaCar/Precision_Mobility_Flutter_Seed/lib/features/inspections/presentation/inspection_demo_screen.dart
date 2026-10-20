import 'package:flutter/material.dart';
import '../domain/evidence_draft.dart';
import '../domain/evidence_template.dart';

class InspectionDemoScreen extends StatefulWidget {
  const InspectionDemoScreen(
      {super.key, required this.draft, required this.onSave});
  final EvidenceDraft draft;
  final ValueChanged<EvidenceDraft> onSave;
  @override
  State<InspectionDemoScreen> createState() => _InspectionDemoScreenState();
}

class _InspectionDemoScreenState extends State<InspectionDemoScreen> {
  bool _failNext = false;
  EvidenceDraft get _draft => widget.draft;

  void _change(VoidCallback action) => setState(() {
        action();
        widget.onSave(_draft);
      });

  void _upload(int index) => _change(() {
        _draft.startUpload(index);
        if (_failNext) {
          _draft.fail(index);
          _failNext = false;
        } else {
          _draft.receive(index, DateTime.now());
        }
      });

  String _status(EvidenceSlot slot) => switch (slot.status) {
        EvidenceStatus.missing => 'Eksik örnek',
        EvidenceStatus.uploading => 'Örnek yükleme sürüyor',
        EvidenceStatus.failed => 'Örnek yükleme başarısız • Yeniden deneyin',
        EvidenceStatus.received => switch (slot.review) {
            EvidenceReview.pending =>
              'Örnek alındı • İnsan inceleme demosu bekleniyor',
            EvidenceReview.accepted => 'İnsan inceleme demosu kabul etti',
            EvidenceReview.retake => 'Yeniden örnek yükleme gerekli',
          },
      };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('20 açılı inceleme • DEMO')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          const Text(
              'Gerçek fotoğraf çekilmez veya yüklenmez. Her düğme sentetik '
              'bir kaydı simüle eder. AI, hasar sorumluluğu veya ceza kararı yok.'),
          Text('Şablon: $inspectionTemplateVersion • ${_draft.bookingId}'),
          const Text('Taslak bu oturumda korunur. Uygulama kapanınca silinir. '
              'Alındı numarası ve zaman cihazda üretilen demo değerleridir.'),
          Semantics(
              liveRegion: true,
              child: Text('${_draft.acceptedCount}/20 örnek kabul edildi')),
          SwitchListTile(
              title: const Text('Sonraki örnek yükleme başarısız olsun'),
              value: _failNext,
              onChanged: (value) => setState(() => _failNext = value)),
          for (var i = 0; i < evidenceAngles.length; i++) _slot(i),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: _draft.isComplete
                  ? () {
                      widget.onSave(_draft);
                      Navigator.of(context).pop(true);
                    }
                  : null,
              child: const Text('20/20 inceleme demosunu tamamla')),
        ]),
      );

  Widget _slot(int index) {
    final slot = _draft.slots[index];
    return Card(
        key: ValueKey('evidence-$index'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${index + 1}. ${evidenceAngles[index]}',
                style: Theme.of(context).textTheme.titleMedium),
            Text(_status(slot)),
            if (slot.demoReceipt != null)
              Text('Temsili alındı: ${slot.demoReceipt}'),
            Wrap(spacing: 8, runSpacing: 8, children: [
              OutlinedButton(
                  key: ValueKey('upload-$index'),
                  onPressed: () => _upload(index),
                  child: const Text('Örnek yükle')),
              if (slot.status == EvidenceStatus.received) ...[
                OutlinedButton(
                    key: ValueKey('accept-$index'),
                    onPressed: slot.review == EvidenceReview.retake
                        ? null
                        : () =>
                            _change(() => _draft.review(index, accepted: true)),
                    child: const Text('İnceleme demosu: kabul')),
                TextButton(
                    onPressed: () =>
                        _change(() => _draft.review(index, accepted: false)),
                    child: const Text('Yeniden örnek iste')),
              ],
            ]),
          ]),
        ));
  }
}
