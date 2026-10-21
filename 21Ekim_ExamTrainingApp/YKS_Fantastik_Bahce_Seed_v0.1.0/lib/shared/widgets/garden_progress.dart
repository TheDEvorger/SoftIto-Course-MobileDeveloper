import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/theme/garden_palette.dart';

/// Yaprak ayrıntılı ilerleme çubuğu.
/// İlerleme ucunda organik filiz/yaprak ikonu ve yumuşak geçiş.
class LeafProgressBar extends StatelessWidget {
  const LeafProgressBar({
    required this.progress,
    this.height = 14,
    this.showLeafTip = true,
    this.activeColor,
    this.backgroundColor,
    this.label,
    super.key,
  });

  /// 0.0 ile 1.0 arasında değer
  final double progress;
  final double height;
  final bool showLeafTip;
  final Color? activeColor;
  final Color? backgroundColor;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = activeColor ??
        (isDark ? const Color(0xFFA4D49B) : GardenPalette.mossEmerald);
    final bg = backgroundColor ??
        (isDark
            ? GardenPalette.nightBackdrop
            : GardenPalette.lightSage.withAlpha(120));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      isDark ? const Color(0xFFF8F2E8) : GardenPalette.inkPlum,
                ),
              ),
              Text(
                '%${(clamped * 100).toInt()}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final fillWidth = totalWidth * clamped;

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // Arka plan izi
                Container(
                  width: totalWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
                // Dolu çubuk
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  width: fillWidth,
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withAlpha(200),
                        color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
                // Uçtaki yaprak süsü
                if (showLeafTip && clamped > 0.05)
                  Positioned(
                    left: math.max(0, fillWidth - (height + 2)),
                    child: Container(
                      width: height + 4,
                      height: height + 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withAlpha(90),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.eco,
                          size: height - 2,
                          color: color,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Organik ama net okunabilen dairesel ilerleme halkası.
class OrganicProgressRing extends StatelessWidget {
  const OrganicProgressRing({
    required this.progress,
    this.size = 90,
    this.strokeWidth = 9,
    this.activeColor,
    this.centerText,
    this.subText,
    super.key,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Color? activeColor;
  final String? centerText;
  final String? subText;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = activeColor ??
        (isDark ? const Color(0xFFA4D49B) : GardenPalette.mossEmerald);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arka plan halkası
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              color: isDark
                  ? Colors.white10
                  : GardenPalette.lightSage.withAlpha(120),
            ),
          ),
          // Aktif ilerleme halkası
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: clamped),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  color: color,
                );
              },
            ),
          ),
          // Merkez metni
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerText ?? '%${(clamped * 100).toInt()}',
                style: TextStyle(
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? const Color(0xFFF8F2E8) : GardenPalette.inkPlum,
                ),
              ),
              if (subText != null)
                Text(
                  subText!,
                  style: TextStyle(
                    fontSize: size * 0.12,
                    color:
                        isDark ? const Color(0xFFC7BDC8) : Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Derslere göre renkli ilerleme rozeti.
class SubjectProgressBadge extends StatelessWidget {
  const SubjectProgressBadge({
    required this.subjectName,
    required this.completedTopics,
    required this.totalTopics,
    this.color = GardenPalette.mossEmerald,
    this.onTap,
    super.key,
  });

  final String subjectName;
  final int completedTopics;
  final int totalTopics;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ratio = totalTopics > 0 ? completedTopics / totalTopics : 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? GardenPalette.nightCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(60), width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subjectName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFF8F2E8)
                        : GardenPalette.inkPlum,
                  ),
                ),
                Text(
                  '$completedTopics / $totalTopics',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LeafProgressBar(
              progress: ratio,
              height: 8,
              showLeafTip: false,
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }
}
