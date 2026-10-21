import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/theme/garden_palette.dart';
import '../../domain/countdown/countdown_calculator.dart';
import 'garden_buttons.dart';
import 'garden_cards.dart';

class YksCountdownCard extends StatefulWidget {
  const YksCountdownCard({
    required this.targetDate,
    required this.onEditDate,
    super.key,
  });

  final DateTime? targetDate;
  final VoidCallback onEditDate;

  @override
  State<YksCountdownCard> createState() => _YksCountdownCardState();
}

class _YksCountdownCardState extends State<YksCountdownCard> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _startTickerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant YksCountdownCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetDate != widget.targetDate) {
      _ticker?.cancel();
      _startTickerIfNeeded();
    }
  }

  void _startTickerIfNeeded() {
    if (widget.targetDate != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Widget _buildTimeBox({
    required String value,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? GardenPalette.nightBackdrop : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(isDark ? 90 : 60)),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(isDark ? 20 : 15),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFC7BDC8) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result = CountdownCalculator.calculate(
      targetDate: widget.targetDate,
      now: DateTime.now(),
    );

    if (result.isNotSet) {
      return GardenCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GardenPalette.peachCoral.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.event_available_outlined,
                    color: GardenPalette.peachCoral,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sınav Tarihi Henüz Belirlenmedi',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Resmî YKS tarihini veya hedef tarihini belirle.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            GardenPrimaryButton(
              label: 'Sınav Tarihini Belirle',
              icon: Icons.calendar_month,
              onPressed: widget.onEditDate,
              height: 44,
            ),
          ],
        ),
      );
    }

    if (result.isCompleted) {
      return GardenCard(
        borderColor: GardenPalette.harvestGold,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: GardenPalette.harvestGold,
              ),
              child:
                  const Icon(Icons.celebration, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sınav Günü Geldi! 🌱',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Ektiğin tüm tohumlar filizlendi. Başarılar dileriz!',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: widget.onEditDate,
                    child: const Text(
                      'Tarihi Güncelle',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: GardenPalette.mossEmerald,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final d = widget.targetDate!;
    final dateString =
        '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return GardenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.hourglass_top,
                    size: 18,
                    color: GardenPalette.peachCoral,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'YKS Geri Sayımı',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFFF8F2E8)
                          : GardenPalette.inkPlum,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: widget.onEditDate,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.edit_calendar,
                          size: 15,
                          color: isDark
                              ? const Color(0xFFA4D49B)
                              : GardenPalette.mossEmerald),
                      const SizedBox(width: 4),
                      Text(
                        'Değiştir',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? const Color(0xFFA4D49B)
                              : GardenPalette.mossEmerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTimeBox(
                value: '${result.days}',
                label: 'GÜN',
                color: GardenPalette.peachCoral,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildTimeBox(
                value: '${result.hours}',
                label: 'SAAT',
                color: GardenPalette.harvestGold,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildTimeBox(
                value: '${result.minutes}',
                label: 'DAKİKA',
                color: GardenPalette.mossEmerald,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildTimeBox(
                value: '${result.seconds}',
                label: 'SANİYE',
                color: GardenPalette.streamTurquoise,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Hedef: $dateString',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
