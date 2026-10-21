import 'package:flutter/material.dart';

import '../../core/theme/garden_palette.dart';

/// Ana eylemler için mercan (`peachCoral`) veya zümrüt (`mossEmerald`)
/// renkli, basılma animasyonlu, ışık/gölge detaylarına sahip ana buton.
class GardenPrimaryButton extends StatefulWidget {
  const GardenPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isLoading = false,
    this.width,
    this.height = 50,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isLoading;
  final double? width;
  final double height;

  @override
  State<GardenPrimaryButton> createState() => _GardenPrimaryButtonState();
}

class _GardenPrimaryButtonState extends State<GardenPrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    final baseColor = widget.isSecondary
        ? GardenPalette.mossEmerald
        : GardenPalette.peachCoral;
    final gradientEnd =
        widget.isSecondary ? const Color(0xFF3B6B45) : const Color(0xFFD46D4E);

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isEnabled
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [baseColor, gradientEnd],
                )
              : null,
          color: isEnabled ? null : Colors.grey.shade400,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: baseColor.withAlpha(75),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isEnabled ? widget.onPressed : null,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Özel başarı ve hedef eylemleri için altın vurgulu buton.
class GoldenActionButton extends StatefulWidget {
  const GoldenActionButton({
    required this.label,
    required this.onPressed,
    this.icon = Icons.auto_awesome,
    this.badgeText,
    this.width,
    this.height = 48,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final String? badgeText;
  final double? width;
  final double height;

  @override
  State<GoldenActionButton> createState() => _GoldenActionButtonState();
}

class _GoldenActionButtonState extends State<GoldenActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [
                    GardenPalette.honeyLight,
                    GardenPalette.harvestGold,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : Colors.grey.shade400,
          border: Border.all(
            color: isEnabled ? const Color(0xFFDFB356) : Colors.transparent,
            width: 1.2,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: GardenPalette.harvestGold.withAlpha(80),
                    offset: const Offset(0, 3),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onPressed,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: GardenPalette.inkPlum, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: GardenPalette.inkPlum,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (widget.badgeText != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: GardenPalette.inkPlum,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.badgeText!,
                        style: const TextStyle(
                          color: GardenPalette.honeyLight,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// İkon çevresinde hafif yaprak, tomurcuk veya doğal çerçeve ayrıntıları.
class BotanicalIconButton extends StatelessWidget {
  const BotanicalIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 44,
    this.iconSize = 22,
    this.backgroundColor,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ??
        (isDark ? GardenPalette.nightCard : GardenPalette.lightSage);
    final fg =
        iconColor ?? (isDark ? const Color(0xFFA4D49B) : GardenPalette.inkPlum);

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bg,
            border: Border.all(
              color: GardenPalette.mossEmerald.withAlpha(45),
              width: 1.5,
            ),
          ),
          child: Icon(icon, size: iconSize, color: fg),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

/// TYT/AYT, filtre ve görünüm seçimleri için özgün sekmeli kontrol.
class NatureSegmentedControl<T> extends StatelessWidget {
  const NatureSegmentedControl({
    required this.items,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Map<T, String> items;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? GardenPalette.nightCard : GardenPalette.gardenPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GardenPalette.mossEmerald.withAlpha(35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.entries.map((entry) {
          final isSelected = entry.key == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(entry.key),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? (isDark
                          ? GardenPalette.mossEmerald
                          : GardenPalette.mossEmerald)
                      : Colors.transparent,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? const Color(0xFFF8F2E8)
                              : GardenPalette.inkPlum),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
