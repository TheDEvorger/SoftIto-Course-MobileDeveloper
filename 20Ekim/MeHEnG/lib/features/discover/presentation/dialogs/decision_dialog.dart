import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/decision.dart';
import '../../domain/evidence.dart';
import '../discover_providers.dart';
import '../discover_view_model.dart';

class DecisionDialog extends ConsumerStatefulWidget {
  const DecisionDialog({required this.ventureId, super.key});
  final String ventureId;

  @override
  ConsumerState<DecisionDialog> createState() => _DecisionDialogState();
}

class _DecisionDialogState extends ConsumerState<DecisionDialog> {
  final rationaleController = TextEditingController();
  DecisionOutcome outcome = DecisionOutcome.continueRun;
  final Set<String> selectedEvidenceIds = {};
  String? error;

  @override
  void dispose() {
    rationaleController.dispose();
    super.dispose();
  }

  void _save() {
    try {
      ref.read(discoverViewModelProvider).addDecision(
            ventureId: widget.ventureId,
            outcome: outcome,
            rationale: rationaleController.text,
            evidenceIds: selectedEvidenceIds.toList(),
          );
      Navigator.pop(context);
    } catch (e) {
      setState(() => error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hypotheses = ref.watch(hypothesesProvider(widget.ventureId));
    final allEvidence = <Evidence>[];
    for (final h in hypotheses) {
      final experiments = ref.watch(experimentsProvider(h.id));
      for (final exp in experiments) {
        allEvidence.addAll(ref.watch(evidenceProvider(exp.id)));
      }
    }

    return AlertDialog(
      title: const Text('Stratejik Karar Kaydet'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<DecisionOutcome>(
                initialValue: outcome,
                decoration: const InputDecoration(labelText: 'Karar Yönü'),
                items: DecisionOutcome.values
                    .map(
                      (o) => DropdownMenuItem(
                        value: o,
                        child: Text(o.label),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => outcome = val);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: rationaleController,
                autofocus: true,
                maxLines: 3,
                maxLength: 1000,
                decoration: const InputDecoration(
                  labelText: 'Karar gerekçesi',
                  hintText: 'Neden bu sonuca vardınız? Hangi kanıtlar belirleyici oldu?',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Dayanak Kanıtlar (${selectedEvidenceIds.length} seçildi):',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              if (allEvidence.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Henüz kayıtlı kanıt bulunmuyor. Kararı genel gerekçeyle kaydedebilirsiniz.',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: allEvidence.length,
                    itemBuilder: (context, index) {
                      final ev = allEvidence[index];
                      final isSelected = selectedEvidenceIds.contains(ev.id);
                      final icon = switch (ev.direction) {
                        EvidenceDirection.supports => Icons.check_circle_outline,
                        EvidenceDirection.contradicts => Icons.highlight_off,
                        EvidenceDirection.neutral => Icons.help_outline,
                      };
                      final color = switch (ev.direction) {
                        EvidenceDirection.supports => Colors.green,
                        EvidenceDirection.contradicts => Colors.redAccent,
                        EvidenceDirection.neutral => Colors.grey,
                      };
                      return CheckboxListTile(
                        dense: true,
                        value: isSelected,
                        secondary: Icon(icon, color: color, size: 20),
                        title: Text(
                          ev.note,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          ev.source ?? 'Kaynak belirtilmedi',
                          style: const TextStyle(fontSize: 11),
                        ),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              selectedEvidenceIds.add(ev.id);
                            } else {
                              selectedEvidenceIds.remove(ev.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(error!, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Vazgeç'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Kararı kaydet'),
        ),
      ],
    );
  }
}
