import 'package:flutter/material.dart';
import '../theme/realm_theme.dart';
import 'ornate_widgets.dart';

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
  Widget build(BuildContext context) => OrnateCard(
        padding: padding,
        color: color,
        child: child,
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.label, {super.key, this.trailing, this.icon});
  final String label;
  final Widget? trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) =>
      OrnateSectionTitle(label, trailing: trailing, icon: icon);
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          border:
              Border.all(color: const Color(0xFFDDCFB0).withValues(alpha: .85)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF503F22).withValues(alpha: .05),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: RealmPalette.ink),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 11.3,
                    color: RealmPalette.ink),
              ),
            ),
          ],
        ),
      );
}
