import 'package:flutter/material.dart';

import '../../core/theme/precision_tokens.dart';

class PrecisionEmptyState extends StatelessWidget {
  const PrecisionEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off_outlined,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Semantics(
        container: true,
        liveRegion: true,
        child: Padding(
          padding: const EdgeInsets.all(PrecisionSpace.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(child: Icon(icon, size: 40)),
              const SizedBox(height: PrecisionSpace.md),
              Text(title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: PrecisionSpace.sm),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}
