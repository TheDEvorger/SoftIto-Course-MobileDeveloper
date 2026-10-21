import 'package:flutter/material.dart';

/// Generated concept photography is restricted to labelled fictional records.
class CollectionArtwork extends StatelessWidget {
  const CollectionArtwork({super.key, required this.tone, required this.name});
  final String tone, name;
  static const _assets = {
    'touring': 'assets/images/sample-touring.png',
    'electric': 'assets/images/sample-electric.png',
    'suv': 'assets/images/sample-suv.png',
  };
  @override
  Widget build(BuildContext context) => Semantics(
        label: '$name, yapay zekâ ile üretilmiş örnek araç görseli',
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(_assets[tone] ?? _assets['electric']!,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
              errorBuilder: (_, __, ___) => ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.directions_car_outlined, size: 40))),
          Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xFF17221E),
                          borderRadius: BorderRadius.circular(6)),
                      child: const Text('ÖRNEK GÖRSEL · YAPAY ZEKÂ',
                          style:
                              TextStyle(color: Colors.white, fontSize: 8))))),
        ]),
      );
}
