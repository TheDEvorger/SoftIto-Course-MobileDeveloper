import 'package:flutter/material.dart';
import '../../core/theme/precision_tokens.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading(
      {super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
              header: true,
              child: Text(title,
                  style: Theme.of(context).textTheme.headlineMedium)),
          const SizedBox(height: PrecisionSpace.sm),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
}
