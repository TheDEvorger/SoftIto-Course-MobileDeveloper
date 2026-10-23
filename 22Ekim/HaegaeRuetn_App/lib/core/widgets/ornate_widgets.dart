import 'package:flutter/material.dart';
import '../theme/realm_theme.dart';
import 'heraldic_decorations.dart';

export 'heraldic_decorations.dart';

class ArtAssets {
  static const habits = 'assets/art/vazifeler_concept.png';
  static const pacts = 'assets/art/ahitler_concept.png';
  static const chronicle = 'assets/art/kronik_concept.png';
  static const plaza = 'assets/art/meydan_concept.jpg';
  static const guide = 'assets/art/rehber_concept.jpg';
  static const wallpaper = 'assets/art/realm_wallpaper.jpg';
}

/// Ornate parchment card with gilded borders and illuminated corner filigrees.
class OrnateCard extends StatelessWidget {
  const OrnateCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
    this.borderColor,
    this.showCorners = true,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color? borderColor;
  final bool showCorners;

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? const Color(0xFFDCC898);
    return CustomPaint(
      foregroundPainter: showCorners
          ? OrnateCornerPainter(
              color: const Color(0xFFC79F45).withValues(alpha: 0.75),
              size: 15,
              inset: 5,
            )
          : null,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: border, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3E311A).withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFFDFC682).withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(color, Colors.white, 0.4)!,
              color,
              Color.lerp(color, const Color(0xFFFBF4E4), 0.18)!,
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Section title with heraldic icon frame and gilded accent.
class OrnateSectionTitle extends StatelessWidget {
  const OrnateSectionTitle(this.label, {super.key, this.trailing, this.icon});

  final String label;
  final Widget? trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2D3),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2C886), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC49A28).withValues(alpha: 0.2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF8B6415), size: 16),
          ),
          const SizedBox(width: 9),
        ],
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.2),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Royal proclamation banner styled like an illuminated parchment ferman.
class HeraldBanner extends StatelessWidget {
  const HeraldBanner({super.key, required this.message, required this.accent});

  final String message;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDFBF6C), width: 1.4),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF7E2), Color(0xFFF7E7BE)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7A5C1B).withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFFFFD166).withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF8B2628),
              border: Border.all(color: const Color(0xFFFFD166), width: 1.6),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B2628).withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.mark_email_unread_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'KRALİYET FERMANI',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF7A4A0A),
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    color: Color(0xFF282319),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.auto_awesome, color: Color(0xFFB8860B), size: 16),
        ],
      ),
    );
  }
}

/// Hero header with an ornate gilded frame and fantasy illuminated styling.
class FancyHeroHeader extends StatelessWidget {
  const FancyHeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    this.height = 220,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String assetPath;
  final double height;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFDFC47E), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF382910).withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            SizedBox(
              height: height,
              width: double.infinity,
              child: Image.asset(assetPath, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: .68),
                      Colors.black.withValues(alpha: .22),
                      Colors.black.withValues(alpha: .04),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Ornate Corner Painter over the image
            const Positioned.fill(
              child: CustomPaint(
                painter: OrnateCornerPainter(
                  color: Color(0xFFFFE082),
                  size: 20,
                  inset: 8,
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .92),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: const Color(0xFFDFC47E), width: 1.4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.14),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shield_moon_outlined,
                                  size: 14, color: Color(0xFFB8860B)),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: const Color(0xFF4C4538),
                                    height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 10),
                    badge!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ornate royal button with gilded rim and embossed enamel gradient.
class OrnateButton extends StatelessWidget {
  const OrnateButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final button = InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isEnabled ? const Color(0xFFE5C568) : const Color(0xFFC7BFB1),
            width: 1.4,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: !isEnabled
                ? [const Color(0xFFE4DDD2), const Color(0xFFD8D1C5)]
                : [const Color(0xFF2E5399), const Color(0xFF16325E)],
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E386B).withValues(alpha: .28),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: const Color(0xFFFFD56B).withValues(alpha: .2),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: const Color(0xFFFFDF7D), width: 1.0),
                ),
                child: Icon(icon, size: 15, color: const Color(0xFFFFECB3)),
              ),
              const SizedBox(width: 9),
            ],
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isEnabled ? Colors.white : const Color(0xFF7E776C),
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class MiniStatCard extends StatelessWidget {
  const MiniStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return OrnateCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: RealmPalette.ink),
              const Icon(Icons.diamond_outlined,
                  size: 10, color: Color(0xFFB8860B)),
            ],
          ),
          const SizedBox(height: 7),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: .3,
              color: Color(0xFF4C4538),
            ),
          ),
        ],
      ),
    );
  }
}

class OrnateProgressBar extends StatelessWidget {
  const OrnateProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.background = const Color(0xFFE9E0CC),
    this.height = 13,
  });

  final double value;
  final Color color;
  final Color background;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFD8C7A2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [
                  Color.lerp(color, Colors.white, .25)!,
                  color,
                  Color.lerp(color, const Color(0xFFFFD166), .2)!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FramedIconBadge extends StatelessWidget {
  const FramedIconBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDFC57C), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3816).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: .18),
              border:
                  Border.all(color: color.withValues(alpha: .4), width: 1.2),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B6559)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
