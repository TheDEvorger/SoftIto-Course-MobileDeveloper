import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/garden_palette.dart';
import '../../domain/analytics_models.dart';

class GardenLineChart extends StatefulWidget {
  const GardenLineChart({
    required this.points,
    this.height = 220,
    this.lineColor = GardenPalette.mossEmerald,
    this.unit = 'Net',
    super.key,
  });

  final List<AnalyticsDataPoint> points;
  final double height;
  final Color lineColor;
  final String unit;

  @override
  State<GardenLineChart> createState() => _GardenLineChartState();
}

class _GardenLineChartState extends State<GardenLineChart> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) {
      return Container(
        height: widget.height,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: GardenPalette.mossEmerald.withAlpha(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              size: 42,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            const Text(
              'Henüz Kayıtlı Deneme Verisi Yok',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Denemeler sekmesinden yeni denemeler ekledikçe gelişim grafiğin burada canlanacak.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    // Accessible description for screen readers
    final latest = widget.points.last;
    final semanticSummary = widget.points.length >= 2
        ? 'Net gelişim grafiği: Toplam ${widget.points.length} deneme. Son deneme "${latest.title}", ${latest.net.toStringAsFixed(2)} net.'
        : 'Tek deneme kaydı: "${latest.title}", ${latest.net.toStringAsFixed(2)} net. Trend için en az 2 deneme gerekir.';

    return Semantics(
      label: semanticSummary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Selected point banner (Tooltip detail)
          if (_selectedIndex != null &&
              _selectedIndex! < widget.points.length) ...[
            _buildSelectedTooltip(widget.points[_selectedIndex!]),
            const SizedBox(height: 8),
          ] else if (widget.points.length == 1) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: GardenPalette.mossEmerald.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GardenPalette.mossEmerald.withAlpha(60),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: GardenPalette.mossEmerald,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'İlk denemen kaydedildi (${latest.net.toStringAsFixed(2)} Net). Trend çizgisi 2. denemeden sonra oluşacak.',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: GardenPalette.inkPlum,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Chart Canvas
          Container(
            height: widget.height,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.lineColor.withAlpha(45),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.lineColor.withAlpha(15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) {
                    _handleTap(details.localPosition, constraints.maxWidth);
                  },
                  child: CustomPaint(
                    size: Size(constraints.maxWidth, widget.height - 32),
                    painter: _GardenChartPainter(
                      points: widget.points,
                      lineColor: widget.lineColor,
                      selectedIndex: _selectedIndex,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          // Legend / info footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'İlk: ${_formatDate(widget.points.first.date)}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                'Detay için noktalara dokunun',
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                'Son: ${_formatDate(widget.points.last.date)}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleTap(Offset localPosition, double width) {
    if (widget.points.isEmpty) return;
    if (widget.points.length == 1) {
      setState(() => _selectedIndex = 0);
      return;
    }

    const chartPadding = 24.0;
    final usableWidth = width - (chartPadding * 2);
    final step = usableWidth / (widget.points.length - 1);

    int closestIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < widget.points.length; i++) {
      final pointX = chartPadding + (i * step);
      final distance = (localPosition.dx - pointX).abs();
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    setState(() {
      _selectedIndex = closestIndex;
    });
  }

  Widget _buildSelectedTooltip(AnalyticsDataPoint point) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: GardenPalette.inkPlum,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: GardenPalette.harvestGold,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars,
              size: 14,
              color: GardenPalette.inkPlum,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatDate(point.date),
                  style: TextStyle(
                    color: Colors.white.withAlpha(180),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: GardenPalette.mossEmerald,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${point.net.toStringAsFixed(2)} ${widget.unit}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}

class _GardenChartPainter extends CustomPainter {
  _GardenChartPainter({
    required this.points,
    required this.lineColor,
    required this.selectedIndex,
    required this.isDark,
  });

  final List<AnalyticsDataPoint> points;
  final Color lineColor;
  final int? selectedIndex;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const chartPadding = 24.0;
    final usableWidth = size.width - (chartPadding * 2);
    const topPadding = 16.0;
    const bottomPadding = 18.0;
    final usableHeight = size.height - topPadding - bottomPadding;

    // Calculate Min and Max Net with nice buffer
    double minNet = points.map((p) => p.net).reduce(math.min);
    double maxNet = points.map((p) => p.net).reduce(math.max);

    if ((maxNet - minNet).abs() < 2.0) {
      minNet = math.max(0, minNet - 5);
      maxNet = maxNet + 5;
    } else {
      final range = maxNet - minNet;
      minNet = math.max(0, minNet - (range * 0.15));
      maxNet = maxNet + (range * 0.15);
    }

    final double range = maxNet - minNet == 0 ? 1.0 : (maxNet - minNet);

    // Grid lines (3 horizontal lines: min, mid, max)
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withAlpha(20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final textStyle = TextStyle(
      color: (isDark ? Colors.white : Colors.black).withAlpha(120),
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    // Draw reference horizontal grid lines & labels
    for (int i = 0; i <= 2; i++) {
      final yRatio = i / 2.0;
      final y = topPadding + (usableHeight * (1.0 - yRatio));
      final val = minNet + (range * yRatio);

      canvas.drawLine(
        Offset(chartPadding, y),
        Offset(size.width - chartPadding, y),
        gridPaint,
      );

      final span = TextSpan(text: val.toStringAsFixed(1), style: textStyle);
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Single point case
    if (points.length == 1) {
      final centerX = size.width / 2;
      final netRatio = ((points.first.net - minNet) / range).clamp(0.0, 1.0);
      final centerY = topPadding + (usableHeight * (1.0 - netRatio));

      // Outer glow ring
      canvas.drawCircle(
        Offset(centerX, centerY),
        10,
        Paint()..color = lineColor.withAlpha(60),
      );
      // Main dot
      canvas.drawCircle(
        Offset(centerX, centerY),
        6,
        Paint()..color = lineColor,
      );
      canvas.drawCircle(
        Offset(centerX, centerY),
        3,
        Paint()..color = Colors.white,
      );
      return;
    }

    // Multiple points: compute positions
    final stepX = usableWidth / (points.length - 1);
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = chartPadding + (i * stepX);
      final netRatio = ((points[i].net - minNet) / range).clamp(0.0, 1.0);
      final y = topPadding + (usableHeight * (1.0 - netRatio));
      offsets.add(Offset(x, y));
    }

    // Draw gradient fill under the line
    final fillPath = Path()
      ..moveTo(offsets.first.dx, size.height - bottomPadding);
    fillPath.lineTo(offsets.first.dx, offsets.first.dy);

    for (int i = 1; i < offsets.length; i++) {
      final p0 = offsets[i - 1];
      final p1 = offsets[i];
      final controlX = (p0.dx + p1.dx) / 2;
      fillPath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }
    fillPath.lineTo(offsets.last.dx, size.height - bottomPadding);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withAlpha(80),
          lineColor.withAlpha(10),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Draw smooth line
    final linePath = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 1; i < offsets.length; i++) {
      final p0 = offsets[i - 1];
      final p1 = offsets[i];
      final controlX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    // Draw dots
    for (int i = 0; i < offsets.length; i++) {
      final isSelected = selectedIndex == i;
      final point = offsets[i];

      if (isSelected) {
        // Highlight ring
        canvas.drawCircle(
          point,
          11,
          Paint()..color = GardenPalette.harvestGold.withAlpha(100),
        );
        canvas.drawCircle(
          point,
          6.5,
          Paint()..color = GardenPalette.harvestGold,
        );
        canvas.drawCircle(
          point,
          3.5,
          Paint()..color = Colors.white,
        );
      } else {
        canvas.drawCircle(
          point,
          4.5,
          Paint()..color = lineColor,
        );
        canvas.drawCircle(
          point,
          2.0,
          Paint()..color = Colors.white,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GardenChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.isDark != isDark;
  }
}
