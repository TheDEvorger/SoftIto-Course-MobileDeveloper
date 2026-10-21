import 'package:flutter/material.dart';
import 'studio_page.dart';

class ActionState extends StatelessWidget {
  const ActionState(
      {super.key,
      required this.title,
      required this.message,
      required this.icon,
      this.action,
      this.label});
  final String title, message;
  final IconData icon;
  final VoidCallback? action;
  final String? label;
  @override
  Widget build(BuildContext context) => StudioPanel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20)),
            child: Icon(icon,
                size: 30,
                color: Theme.of(context).colorScheme.onPrimaryContainer)),
        const SizedBox(height: 22),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Text(message,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        if (action != null && label != null) ...[
          const SizedBox(height: 22),
          FilledButton.icon(
              onPressed: action,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: Text(label!)),
        ],
      ]));
}
