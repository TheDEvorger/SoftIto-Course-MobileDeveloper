import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/garden_palette.dart';

enum ScoreFieldType { correct, wrong, blank }

/// Özgün doğru / yanlış / boş giriş hücresi.
/// Büyük, okunaklı, klavye uyumlu ve belirgin renkli kenarlıklar.
class GardenExamScoreField extends StatelessWidget {
  const GardenExamScoreField({
    required this.controller,
    required this.type,
    this.onChanged,
    this.maxValue = 40,
    super.key,
  });

  final TextEditingController controller;
  final ScoreFieldType type;
  final ValueChanged<String>? onChanged;
  final int maxValue;

  String get _label {
    switch (type) {
      case ScoreFieldType.correct:
        return 'Doğru';
      case ScoreFieldType.wrong:
        return 'Yanlış';
      case ScoreFieldType.blank:
        return 'Boş';
    }
  }

  Color get _accentColor {
    switch (type) {
      case ScoreFieldType.correct:
        return GardenPalette.mossEmerald;
      case ScoreFieldType.wrong:
        return GardenPalette.peachCoral;
      case ScoreFieldType.blank:
        return GardenPalette.streamTurquoise;
    }
  }

  IconData get _icon {
    switch (type) {
      case ScoreFieldType.correct:
        return Icons.check_circle_outline;
      case ScoreFieldType.wrong:
        return Icons.highlight_off;
      case ScoreFieldType.blank:
        return Icons.radio_button_unchecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? GardenPalette.nightCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accentColor.withAlpha(isDark ? 110 : 90),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withAlpha(isDark ? 25 : 15),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon, size: 16, color: _accentColor),
              const SizedBox(width: 6),
              Text(
                _label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFFF8F2E8) : GardenPalette.inkPlum,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              hintText: '0',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Doğa temasıyla uyumlu arama kutusu.
class NatureSearchField extends StatefulWidget {
  const NatureSearchField({
    required this.controller,
    this.hintText = 'Konu veya ders ara...',
    this.onChanged,
    this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  State<NatureSearchField> createState() => _NatureSearchFieldState();
}

class _NatureSearchFieldState extends State<NatureSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant NatureSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? GardenPalette.nightCard : GardenPalette.sandyPorcelain,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GardenPalette.mossEmerald.withAlpha(isDark ? 60 : 40),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: isDark ? const Color(0xFFA4D49B) : GardenPalette.mossEmerald,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFF8F2E8) : GardenPalette.inkPlum,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: widget.onChanged,
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                widget.controller.clear();
                if (widget.onClear != null) widget.onClear!();
                if (widget.onChanged != null) widget.onChanged!('');
              },
              child: Icon(
                Icons.cancel,
                size: 18,
                color: Colors.grey.shade500,
              ),
            ),
        ],
      ),
    );
  }
}

/// Filtre ve ders seçimleri için organik chip.
class NatureFilterChip extends StatelessWidget {
  const NatureFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? GardenPalette.mossEmerald : GardenPalette.mossEmerald)
              : (isDark ? GardenPalette.nightCard : GardenPalette.gardenPaper),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? GardenPalette.mossEmerald
                : GardenPalette.mossEmerald.withAlpha(40),
            width: 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: GardenPalette.mossEmerald.withAlpha(50),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected
                    ? Colors.white
                    : (isDark
                        ? const Color(0xFFA4D49B)
                        : GardenPalette.mossEmerald),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected
                    ? Colors.white
                    : (isDark
                        ? const Color(0xFFF8F2E8)
                        : GardenPalette.inkPlum),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
