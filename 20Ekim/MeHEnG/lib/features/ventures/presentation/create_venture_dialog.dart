import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/venture.dart';
import 'venture_providers.dart';

class CreateVentureDialog extends ConsumerStatefulWidget {
  const CreateVentureDialog({super.key});
  @override
  ConsumerState<CreateVentureDialog> createState() =>
      _CreateVentureDialogState();
}

class _CreateVentureDialogState extends ConsumerState<CreateVentureDialog> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final problem = TextEditingController();
  final audience = TextEditingController();
  String? error;

  @override
  void dispose() {
    name.dispose();
    problem.dispose();
    audience.dispose();
    super.dispose();
  }

  void save() {
    if (!formKey.currentState!.validate()) return;
    try {
      ref
          .read(ventureViewModelProvider)
          .create(
            name: name.text,
            problem: problem.text,
            audience: audience.text,
          );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => error = 'Kayıt başarısız: $e');
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Yeni girişim'),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Girişimin adı'),
                maxLength: 80,
                validator: Venture.validateName,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: problem,
                decoration: const InputDecoration(labelText: 'Çözdüğü problem'),
                maxLines: 2,
                maxLength: 500,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: audience,
                decoration: const InputDecoration(labelText: 'Hedef kitle'),
                maxLength: 200,
              ),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Vazgeç'),
      ),
      FilledButton(onPressed: save, child: const Text('Oluştur')),
    ],
  );
}
