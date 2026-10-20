import 'package:flutter/material.dart';

enum PrecisionButtonStyle { primary, secondary }

class PrecisionButton extends StatelessWidget {
  const PrecisionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = PrecisionButtonStyle.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final PrecisionButtonStyle style;

  @override
  Widget build(BuildContext context) => switch (style) {
        PrecisionButtonStyle.primary => FilledButton(
            onPressed: onPressed,
            child: Text(label, textAlign: TextAlign.center),
          ),
        PrecisionButtonStyle.secondary => OutlinedButton(
            onPressed: onPressed,
            child: Text(label, textAlign: TextAlign.center),
          ),
      };
}
