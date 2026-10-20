import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../discover_view_model.dart';

class ExperimentDialog extends ConsumerStatefulWidget {
  const ExperimentDialog({required this.hypothesisId, super.key});
  final String hypothesisId;
  @override
  ConsumerState<ExperimentDialog> createState() => _ExperimentDialogState();
}

class _ExperimentDialogState extends ConsumerState<ExperimentDialog> {
  final title = TextEditingController();
  final method = TextEditingController();
  String? error;
  @override
  void dispose() {
    title.dispose();
    method.dispose();
    super.dispose();
  }

  void save() {
    try {
      ref
          .read(discoverViewModelProvider)
          .addExperiment(widget.hypothesisId, title.text, method.text);
      Navigator.pop(context);
    } catch (e) {
      setState(() => error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Yeni deney'),
    content: SizedBox(
      width: 430,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: title,
            autofocus: true,
            maxLength: 140,
            decoration: const InputDecoration(labelText: 'Deney başlığı'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: method,
            maxLength: 500,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Uygulanacak yöntem'),
          ),
          if (error != null)
            Text(error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Vazgeç'),
      ),
      FilledButton(onPressed: save, child: const Text('Kaydet')),
    ],
  );
}
