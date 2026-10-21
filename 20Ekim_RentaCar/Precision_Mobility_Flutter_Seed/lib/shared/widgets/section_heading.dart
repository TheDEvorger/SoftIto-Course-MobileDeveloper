import 'package:flutter/material.dart';
import '../../core/theme/precision_tokens.dart';

/// Sayfa ve bölüm başlıklarını standartlaştıran başlık bileşeni.
/// Başlık ve alt başlık içerir, erişilebilirlik için header semantiği sağlar.
class SectionHeading extends StatelessWidget {
  const SectionHeading(
      {super.key, required this.title, required this.subtitle});

  /// Bölüm ana başlığı
  final String title;

  /// Bölüm açıklayıcı alt başlığı
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
