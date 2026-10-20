import 'package:flutter/foundation.dart';

/// Kurgusal (demo) hasta. Gerçek kimlik bilgisi içermez.
@immutable
class DemoPatient {
  const DemoPatient({
    required this.id,
    required this.displayName,
    required this.code,
    required this.department,
  });

  final String id;

  /// Kurgusal görünen ad.
  final String displayName;

  /// Demo hasta kodu (ör. `DEMO-1042`). TC kimlik no DEĞİLDİR.
  final String code;

  /// Hizmet / birim bilgisi.
  final String department;

  /// Liste ve avatarlarda kullanılan baş harfler.
  String get initials {
    final List<String> parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
