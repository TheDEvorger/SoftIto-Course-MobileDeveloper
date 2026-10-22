import 'package:flutter/material.dart';

class RealmCard extends StatelessWidget {
  const RealmCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(18),
      this.color = Colors.white});
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(23),
          border:
              Border.all(color: const Color(0xFFDDD8C8).withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF3A4D3F).withValues(alpha: 0.055),
                blurRadius: 23,
                offset: const Offset(0, 8))
          ],
        ),
        child: child,
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.label, {super.key, this.trailing});
  final String label;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleLarge)),
        if (trailing != null) trailing!,
      ]);
}

class RealmPill extends StatelessWidget {
  const RealmPill(
      {super.key,
      required this.label,
      this.icon,
      this.color = const Color(0xFFE9F4EE)});
  final String label;
  final IconData? icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(30)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 14), const SizedBox(width: 5)],
          Flexible(
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 11))),
        ]),
      );
}
