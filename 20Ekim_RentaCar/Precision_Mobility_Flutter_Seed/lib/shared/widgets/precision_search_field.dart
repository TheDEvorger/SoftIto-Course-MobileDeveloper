import 'package:flutter/material.dart';

/// Standart arama giriş alanı (Search Field) bileşeni.
/// Arama ikonu ve temizle/filtreleme olaylarını yönetir.
class PrecisionSearchField extends StatelessWidget {
  const PrecisionSearchField({
    super.key,
    required this.label,
    required this.onChanged,
    this.controller,
  });

  /// Giriş alanı etiket metni
  final String label;

  /// Metin değiştikçe tetiklenen geri çağırma
  final ValueChanged<String> onChanged;

  /// İsteğe bağlı metin denetleyicisi
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
