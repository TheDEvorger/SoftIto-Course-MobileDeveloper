import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/evidence.dart';
import '../discover_view_model.dart';

class EvidenceDialog extends ConsumerStatefulWidget {
  const EvidenceDialog({required this.experimentId, super.key});
  final String experimentId;
  @override
  ConsumerState<EvidenceDialog> createState() => _EvidenceDialogState();
}

class _EvidenceDialogState extends ConsumerState<EvidenceDialog> {
  final note = TextEditingController();
  final source = TextEditingController();
  EvidenceDirection direction = EvidenceDirection.neutral;
  bool hasConsent = true;
  String? error;

  @override
  void dispose() {
    note.dispose();
    source.dispose();
    super.dispose();
  }

  void save() {
    try {
      ref
          .read(discoverViewModelProvider)
          .addEvidence(
            widget.experimentId,
            note.text,
            direction,
            source: source.text,
            hasConsent: hasConsent,
          );
      Navigator.pop(context);
    } catch (e) {
      setState(() => error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Gözlem / kanıt ekle'),
    content: SizedBox(
      width: 440,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: note,
              autofocus: true,
              maxLines: 3,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'Gerçekte ne gözlemledin?',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<EvidenceDirection>(
              initialValue: direction,
              decoration: const InputDecoration(labelText: 'İlişki'),
              items: const [
                DropdownMenuItem(
                  value: EvidenceDirection.supports,
                  child: Text('Hipotezi destekliyor'),
                ),
                DropdownMenuItem(
                  value: EvidenceDirection.contradicts,
                  child: Text('Hipotezle çelişiyor'),
                ),
                DropdownMenuItem(
                  value: EvidenceDirection.neutral,
                  child: Text('Henüz belirsiz / nötr'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => direction = value);
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: source,
              decoration: const InputDecoration(
                labelText: 'Kaynak / kanıt kökeni (opsiyonel)',
                hintText: 'Örn: Mülakat #3, Analytics, Anket formu',
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: hasConsent,
              onChanged: (val) => setState(() => hasConsent = val ?? false),
              title: const Text(
                'Veri sahibi rızası alındı',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Gözlem etik ilkelere ve gizlilik kurallarına uygundur.',
              ),
            ),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Vazgeç'),
      ),
      FilledButton(onPressed: save, child: const Text('Kanıtı kaydet')),
    ],
  );
}
