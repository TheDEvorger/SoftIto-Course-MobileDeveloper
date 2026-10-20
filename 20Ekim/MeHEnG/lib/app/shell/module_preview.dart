import 'package:flutter/material.dart';

class ModulePreview extends StatelessWidget {
  const ModulePreview({required this.index, super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    const items = [
      ('', '', Icons.home),
      (
        'MeHEnG Discover',
        'Doğrulama akışı için Girişimler bölümünden bir proje aç. '
            'Hipotez, deney ve kanıt zinciri artık kullanılabilir.',
        Icons.science,
      ),
      (
        'MeHEnG Network',
        'Ekip bulma, mentorluk ve işbirliği alanı. '
            'Kimlik, izinler ve moderasyon kurulduktan sonra açılacak.',
        Icons.groups,
      ),
      (
        'MeHEnG Growth',
        'Lansman, metrikler ve büyüme deneyleri. '
            'Kanıtlanan girişimler için adım adım eklenecek.',
        Icons.trending_up,
      ),
    ];
    final item = items[index];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 590),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.$3, size: 56),
              const SizedBox(height: 18),
              Text(
                item.$1,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(item.$2, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              const Chip(label: Text('Yol haritasında')),
            ],
          ),
        ),
      ),
    );
  }
}
