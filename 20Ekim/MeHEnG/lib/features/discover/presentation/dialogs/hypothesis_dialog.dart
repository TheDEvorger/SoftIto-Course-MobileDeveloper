import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../discover_view_model.dart';

class HypothesisDialog extends ConsumerStatefulWidget {
  const HypothesisDialog({required this.ventureId, super.key});
  final String ventureId;
  @override
  ConsumerState<HypothesisDialog> createState() => _HypothesisDialogState();
}

class _HypothesisDialogState extends ConsumerState<HypothesisDialog> {
  final text = TextEditingController();
  String? error;
  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  void save() {
    try {
      ref
          .read(discoverViewModelProvider)
          .addHypothesis(widget.ventureId, text.text);
      Navigator.pop(context);
    } catch (e) {
      setState(() => error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Test edilebilir hipotez'),
    content: SizedBox(
      width: 430,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: text,
            autofocus: true,
            maxLines: 3,
            maxLength: 600,
            decoration: const InputDecoration(
              hintText: 'Örn: Çiftçiler aylık 200 TL ödemeye hazır.',
            ),
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
