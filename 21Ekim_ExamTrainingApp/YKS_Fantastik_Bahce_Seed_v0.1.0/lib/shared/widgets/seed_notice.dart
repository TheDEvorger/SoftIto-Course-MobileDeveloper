import 'package:flutter/material.dart';

import '../../core/content/app_copy.dart';

class SeedNotice extends StatelessWidget {
  const SeedNotice({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          AppCopy.demoNotice,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      );
}
