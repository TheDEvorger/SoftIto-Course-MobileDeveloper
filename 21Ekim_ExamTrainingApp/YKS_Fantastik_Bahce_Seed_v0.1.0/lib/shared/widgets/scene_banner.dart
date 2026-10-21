import 'package:flutter/material.dart';

class SceneBanner extends StatelessWidget {
  const SceneBanner({
    required this.assetPath,
    required this.heading,
    required this.subtitle,
    super.key,
    this.height = 224,
  });

  final String assetPath;
  final String heading;
  final String subtitle;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$heading. $subtitle',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                assetPath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                excludeFromSemantics: true,
                errorBuilder: (context, error, stackTrace) =>
                    ColoredBox(color: Theme.of(context).colorScheme.primary),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x990B2319),
                      Color(0x110B2319),
                      Color(0xD9001810)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(heading,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                )),
                    const SizedBox(height: 8),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
