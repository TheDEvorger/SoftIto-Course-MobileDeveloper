import 'package:flutter/material.dart';

class QuickAddButton extends StatelessWidget {
  const QuickAddButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Su ekle'),
      ),
    );
  }
}
