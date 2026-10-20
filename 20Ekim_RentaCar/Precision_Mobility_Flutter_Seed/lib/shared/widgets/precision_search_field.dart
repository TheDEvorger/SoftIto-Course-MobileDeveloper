import 'package:flutter/material.dart';

class PrecisionSearchField extends StatelessWidget {
  const PrecisionSearchField({
    super.key,
    required this.label,
    required this.onChanged,
    this.controller,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          labelText: label,
        ),
      );
}
