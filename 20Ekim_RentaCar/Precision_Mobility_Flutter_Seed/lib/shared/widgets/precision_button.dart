import 'package:flutter/material.dart';

/// Precision buton stil çeşitleri (birincil dolu veya ikincil kenarlıklı)
enum PrecisionButtonStyle { primary, secondary }

/// Uygulama standardı düğme bileşeni.
/// Material 3 FilledButton ve OutlinedButton yapılarını tek bir arayüzde birleştirir.
class PrecisionButton extends StatelessWidget {
  const PrecisionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = PrecisionButtonStyle.primary,
  });

  /// Düğme üzerinde görüntülenecek metin
  final String label;

  /// Tıklama olayı geri çağırma fonksiyonu (null ise devre dışı kalır)
  final VoidCallback? onPressed;

  /// Düğme görsel stili
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
