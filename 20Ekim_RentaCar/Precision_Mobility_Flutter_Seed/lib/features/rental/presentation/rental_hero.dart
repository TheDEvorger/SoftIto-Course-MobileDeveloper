import 'package:flutter/material.dart';

class RentalHero extends StatelessWidget {
  const RentalHero({super.key});
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final compact = constraints.maxWidth < 600;
        return ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: compact ? 150 : 220),
                child: Stack(children: [
                  Positioned.fill(
                      child: Image.asset(
                          'assets/images/precision-editorial-hero.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.centerRight,
                          excludeFromSemantics: true)),
                  Positioned.fill(
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                    const Color(0xFF142A20),
                    const Color(0xFF142A20).withValues(alpha: .65),
                    Colors.transparent
                  ], stops: const [
                    0,
                    .5,
                    1
                  ])))),
                  Padding(
                      padding: EdgeInsets.all(compact ? 20 : 28),
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('PRECISION / ARAÇ KİRALAMA',
                                    style: TextStyle(
                                        color: Color(0xFFD8ECDE),
                                        letterSpacing: 1.8,
                                        fontSize: 10)),
                                SizedBox(height: compact ? 12 : 20),
                                Text('Rotanız hazır.\nAracınızı seçin.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize: compact ? 28 : 36)),
                                if (!compact) ...[
                                  const SizedBox(height: 18),
                                  const Text(
                                      'Şehir içinde, hafta sonunda, yeni bir yolda.',
                                      style: TextStyle(
                                          color: Color(0xFFE3EBE6),
                                          fontSize: 13)),
                                ],
                                const SizedBox(height: 16),
                                const Text('Temsili marka görseli · Yapay zekâ',
                                    style: TextStyle(
                                        color: Color(0xFFE3EBE6), fontSize: 9)),
                              ]))),
                ])));
      });
}
