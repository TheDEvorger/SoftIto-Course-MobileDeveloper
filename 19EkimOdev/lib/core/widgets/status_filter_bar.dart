import 'package:flutter/material.dart';

/// Yatay kaydırılabilir, sayaçlı filtre çipleri.
///
/// Hem sıra (CollectionStatus) hem numune (SpecimenStatus) ekranında
/// kullanılabilmesi için generic yazıldı. `null` değeri "Tümü" demektir.
class FilterOption<T> {
  const FilterOption({
    required this.value,
    required this.label,
    required this.count,
    this.icon,
  });

  final T? value;
  final String label;
  final int count;
  final IconData? icon;
}

class StatusFilterBar<T> extends StatelessWidget {
  const StatusFilterBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<FilterOption<T>> options;
  final T? selected;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          for (final FilterOption<T> option in options)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                avatar: option.icon == null
                    ? null
                    : Icon(option.icon, size: 18),
                label: Text('${option.label}  ${option.count}'),
                selected: option.value == selected,
                showCheckmark: false,
                onSelected: (_) => onSelected(option.value),
              ),
            ),
        ],
      ),
    );
  }
}
