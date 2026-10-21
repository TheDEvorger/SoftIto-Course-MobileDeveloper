import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget {
  const PageHeading(
      {super.key,
      required this.eyebrow,
      required this.title,
      required this.description,
      this.action});
  final String eyebrow, title, description;
  final Widget? action;
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final text =
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(eyebrow.toUpperCase(),
              style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 12),
          Semantics(
              header: true,
              child: Text(title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: constraints.maxWidth < 600 ? 30 : 40))),
          const SizedBox(height: 12),
          Text(description,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]);
        if (constraints.maxWidth < 700 || action == null) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text,
                if (action != null) ...[const SizedBox(height: 20), action!]
              ]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(child: text),
          const SizedBox(width: 24),
          action!
        ]);
      });
}
