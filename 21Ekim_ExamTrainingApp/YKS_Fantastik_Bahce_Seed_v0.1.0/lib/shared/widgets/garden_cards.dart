import 'package:flutter/material.dart';

import '../../core/theme/garden_palette.dart';

/// Genel içerik kartları. Zarif çift katmanlı hissi veren kenarlık,
/// yumuşak gölgeler ve sıcak yüzey renkleri.
class GardenCard extends StatelessWidget {
  const GardenCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.elevation = 0,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ??
        (isDark ? GardenPalette.nightCard : GardenPalette.sandyPorcelain);
    final border = borderColor ??
        (isDark
            ? GardenPalette.mossEmerald.withAlpha(40)
            : GardenPalette.mossEmerald.withAlpha(30));

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 35 : 12),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Manzaralı büyük karşılama ve vurgu kartları.
/// Görsel üzerine okunaklı koyu botanik degrade yerleştirilir.
class ForestHeroCard extends StatelessWidget {
  const ForestHeroCard({
    required this.assetPath,
    required this.title,
    required this.subtitle,
    this.tag,
    this.actionLabel,
    this.onAction,
    this.height = 210,
    super.key,
  });

  final String assetPath;
  final String title;
  final String subtitle;
  final String? tag;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. $subtitle',
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
                      Color(0x660B2319),
                      Color(0x330B2319),
                      Color(0xE6001810),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (tag != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: GardenPalette.mossEmerald.withAlpha(220),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Color(0xFFF2F8E8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (actionLabel != null && onAction != null) ...[
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: onAction,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: GardenPalette.peachCoral,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                actionLabel!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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

/// Hedef ve başarı alanları için altın vurgulu özel kart.
class GoldenAchievementCard extends StatelessWidget {
  const GoldenAchievementCard({
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.progressText,
    this.icon = Icons.workspace_premium,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? badgeText;
  final String? progressText;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? GardenPalette.nightCard : const Color(0xFFFCF8EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: GardenPalette.harvestGold.withAlpha(isDark ? 120 : 150),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: GardenPalette.harvestGold.withAlpha(isDark ? 40 : 35),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        GardenPalette.honeyLight,
                        GardenPalette.harvestGold,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: GardenPalette.harvestGold.withAlpha(90),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: GardenPalette.inkPlum, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? const Color(0xFFF8F2E8)
                                    : GardenPalette.inkPlum,
                              ),
                            ),
                          ),
                          if (badgeText != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: GardenPalette.harvestGold,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                badgeText!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFFC7BDC8)
                              : Colors.grey.shade700,
                        ),
                      ),
                      if (progressText != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          progressText!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: GardenPalette.harvestGold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Su tonlarından (`streamTurquoise`, `lilyWater`) yararlanan bilgi/ipucu kartı.
class WaterInfoCard extends StatelessWidget {
  const WaterInfoCard({
    required this.title,
    required this.message,
    this.icon = Icons.water_drop_outlined,
    this.onAction,
    this.actionLabel,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF24323A) : GardenPalette.lilyWater,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: GardenPalette.streamTurquoise.withAlpha(isDark ? 90 : 120),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: GardenPalette.streamTurquoise.withAlpha(35),
            ),
            child: Icon(icon, color: GardenPalette.streamTurquoise, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE8F6F4)
                        : GardenPalette.inkPlum,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: isDark
                        ? const Color(0xFFB5C9C6)
                        : const Color(0xFF3B5652),
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: GardenPalette.streamTurquoise,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// İnce doğal süslemelerle desteklenmiş bölüm başlığı.
class BotanicalSectionHeader extends StatelessWidget {
  const BotanicalSectionHeader({
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.icon = Icons.spa_outlined,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: GardenPalette.mossEmerald.withAlpha(isDark ? 50 : 25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color:
                  isDark ? const Color(0xFFA4D49B) : GardenPalette.mossEmerald,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFF8F2E8)
                        : GardenPalette.inkPlum,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFFB3A6B7)
                          : Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          if (actionText != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: isDark
                    ? const Color(0xFFA4D49B)
                    : GardenPalette.mossEmerald,
              ),
              child: Text(
                actionText!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}
