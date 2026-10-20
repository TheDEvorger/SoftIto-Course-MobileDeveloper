import 'package:flutter/material.dart';

import '../../../data/demo/demo_seed.dart';

/// Hizmet / birim seçimi için doğrulamalı çip grubu.
class DepartmentSelector extends StatelessWidget {
  const DepartmentSelector({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.validator,
  });

  final ValueNotifier<String?> selected;
  final ValueChanged<String> onSelected;
  final String? Function() validator;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FormField<String>(
      validator: (_) => validator(),
      builder: (FormFieldState<String> field) {
        return ValueListenableBuilder<String?>(
          valueListenable: selected,
          builder: (BuildContext context, String? value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    for (final String dep in demoDepartments)
                      ChoiceChip(
                        label: Text(dep),
                        selected: value == dep,
                        onSelected: (_) {
                          onSelected(dep);
                          field.didChange(dep);
                          // Hata gösteriliyorsa seçim sonrası temizle.
                          if (field.hasError) field.validate();
                        },
                      ),
                  ],
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      field.errorText!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.error),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
