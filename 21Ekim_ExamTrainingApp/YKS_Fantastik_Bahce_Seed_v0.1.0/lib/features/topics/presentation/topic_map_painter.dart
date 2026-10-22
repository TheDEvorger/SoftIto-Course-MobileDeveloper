import 'package:flutter/material.dart';

import '../../../core/theme/garden_palette.dart';
import '../../../domain/models/curriculum.dart';
import '../../../domain/models/topic_relation.dart';

class TopicMapPainter extends CustomPainter {
  TopicMapPainter({
    required this.nodes,
    this.selectedTopicId,
    required this.isDark,
  });

  final List<TopicNodeInfo> nodes;
  final String? selectedTopicId;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final nodeMap = {for (final n in nodes) n.topicId: n};

    // 1. Bağlantı Çizgilerini (Edges) Çiz
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final node in nodes) {
      for (final prereqId in node.prerequisiteIds) {
        final parent = nodeMap[prereqId];
        if (parent == null) continue;

        final isCompleted = parent.status == TopicStatus.completed;
        edgePaint.color = isCompleted
            ? GardenPalette.mossEmerald.withAlpha(200)
            : (isDark ? Colors.white24 : Colors.black26);

        final p1 = Offset(parent.x + 30, parent.y);
        final p2 = Offset(node.x - 30, node.y);

        final path = Path()..moveTo(p1.dx, p1.dy);
        final dx = (p2.dx - p1.dx).abs();
        path.cubicTo(
          p1.dx + dx * 0.5,
          p1.dy,
          p2.dx - dx * 0.5,
          p2.dy,
          p2.dx,
          p2.dy,
        );

        canvas.drawPath(path, edgePaint);

        // Küçük yön oku veya filiz noktası
        final midX = (p1.dx + p2.dx) / 2;
        final midY = (p1.dy + p2.dy) / 2;
        final dotPaint = Paint()
          ..color = isCompleted
              ? GardenPalette.lightSage
              : (isDark ? Colors.white30 : Colors.black38)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(midX, midY), 3.0, dotPaint);
      }
    }

    // 2. Düğümleri (Nodes) Çiz
    for (final node in nodes) {
      final isSelected = node.topicId == selectedTopicId;
      final center = Offset(node.x, node.y);

      // Seçili halkası (glow)
      if (isSelected) {
        final glowPaint = Paint()
          ..color = GardenPalette.harvestGold.withAlpha(120)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0;
        canvas.drawCircle(center, 22.0, glowPaint);
      }

      // Düğüm gövdesi
      final nodePaint = Paint()..style = PaintingStyle.fill;
      Color borderColor;

      switch (node.status) {
        case TopicStatus.completed:
          nodePaint.color = GardenPalette.mossEmerald;
          borderColor = GardenPalette.lightSage;
          break;
        case TopicStatus.inProgress:
          nodePaint.color = GardenPalette.harvestGold;
          borderColor = GardenPalette.honeyLight;
          break;
        case TopicStatus.notStarted:
          nodePaint.color = node.isReady
              ? (isDark ? const Color(0xFF2C3E50) : const Color(0xFFE2E8F0))
              : (isDark ? const Color(0xFF1E272E) : const Color(0xFFCBD5E1));
          borderColor = node.isReady
              ? GardenPalette.streamTurquoise.withAlpha(180)
              : Colors.transparent;
          break;
      }

      // Ana daire
      canvas.drawCircle(center, 16.0, nodePaint);

      // Dış çerçeve
      if (borderColor != Colors.transparent) {
        final borderPaint = Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawCircle(center, 16.0, borderPaint);
      }

      // İkonik işaret
      final iconText = node.status == TopicStatus.completed
          ? '✓'
          : (node.status == TopicStatus.inProgress
              ? '🌱'
              : (node.isReady ? '🔓' : '🔒'));

      final textSpan = TextSpan(
        text: iconText,
        style: TextStyle(
          color: node.status == TopicStatus.completed
              ? Colors.white
              : (isDark ? Colors.white70 : Colors.black87),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      final tp = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2)),
      );

      // Başlık Etiketi (Node Title)
      final labelSpan = TextSpan(
        text: node.topicName,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      );
      final labelPainter = TextPainter(
        text: labelSpan,
        textDirection: TextDirection.ltr,
        maxLines: 2,
        ellipsis: '...',
      )..layout(maxWidth: 130);

      // Metni düğümün yanına yerleştir (sol veya sağ)
      final labelX =
          node.stage == 'TYT' ? node.x - labelPainter.width - 24 : node.x + 24;
      final labelY = node.y - (labelPainter.height / 2);

      labelPainter.paint(canvas, Offset(labelX, labelY));
    }
  }

  @override
  bool shouldRepaint(covariant TopicMapPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.selectedTopicId != selectedTopicId ||
        oldDelegate.isDark != isDark;
  }
}
