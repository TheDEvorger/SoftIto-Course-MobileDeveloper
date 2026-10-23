import 'package:flutter/material.dart';
import '../theme/realm_theme.dart';

/// Painter for drawing medieval illuminated manuscript corner filigrees.
class OrnateCornerPainter extends CustomPainter {
  const OrnateCornerPainter({
    this.color = RealmPalette.gold,
    this.strokeWidth = 1.3,
    this.size = 18.0,
    this.inset = 5.0,
  });

  final Color color;
  final double strokeWidth;
  final double size;
  final double inset;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = canvasSize.width;
    final h = canvasSize.height;
    final s = size;
    final i = inset;

    // Helper to draw a single ornate corner with L-bracket and inner leaf arc
    void drawCorner(double cx, double cy, double dirX, double dirY) {
      // Outer bracket lines
      canvas.drawLine(
        Offset(cx, cy + dirY * s),
        Offset(cx, cy),
        paint,
      );
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + dirX * s, cy),
        paint,
      );

      // Inner ornate curve
      final arcPath = Path()
        ..moveTo(cx + dirX * (s * 0.7), cy + dirY * 3)
        ..quadraticBezierTo(
          cx + dirX * 3,
          cy + dirY * 3,
          cx + dirX * 3,
          cy + dirY * (s * 0.7),
        );
      canvas.drawPath(arcPath, paint);

      // Corner jewel dot
      canvas.drawCircle(
          Offset(cx + dirX * 3.5, cy + dirY * 3.5), 1.6, dotPaint);

      // Outer accent dot
      canvas.drawCircle(Offset(cx + dirX * s, cy), 1.2, dotPaint);
      canvas.drawCircle(Offset(cx, cy + dirY * s), 1.2, dotPaint);
    }

    // Top-Left
    drawCorner(i, i, 1, 1);
    // Top-Right
    drawCorner(w - i, i, -1, 1);
    // Bottom-Left
    drawCorner(i, h - i, 1, -1);
    // Bottom-Right
    drawCorner(w - i, h - i, -1, -1);
  }

  @override
  bool shouldRepaint(covariant OrnateCornerPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      size != oldDelegate.size ||
      inset != oldDelegate.inset;
}

/// Ornate gilded divider with a central heraldic motif.
class HeraldicDivider extends StatelessWidget {
  const HeraldicDivider({
    super.key,
    this.color = const Color(0xFFDCC898),
    this.accentColor = RealmPalette.gold,
    this.icon = Icons.auto_awesome,
  });

  final Color color;
  final Color accentColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.1), color],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.diamond_outlined, size: 10, color: accentColor),
                const SizedBox(width: 4),
                Icon(icon, size: 14, color: accentColor),
                const SizedBox(width: 4),
                Icon(Icons.diamond_outlined, size: 10, color: accentColor),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.1)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Royal wax seal stamp for proclamations, completed habits, and achievements.
class HeraldicSeal extends StatelessWidget {
  const HeraldicSeal({
    super.key,
    required this.icon,
    this.size = 38,
    this.color = const Color(0xFF9E2A2B),
    this.borderColor = const Color(0xFFFFD166),
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final double size;
  final Color color;
  final Color borderColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: borderColor.withValues(alpha: 0.25),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
        gradient: RadialGradient(
          colors: [
            Color.lerp(color, Colors.white, 0.25)!,
            color,
            Color.lerp(color, Colors.black, 0.25)!,
          ],
        ),
      ),
      child: Center(
        child: Icon(icon, color: iconColor, size: size * 0.52),
      ),
    );
  }
}
