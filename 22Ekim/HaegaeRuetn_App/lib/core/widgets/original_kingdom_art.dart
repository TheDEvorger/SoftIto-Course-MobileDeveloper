import 'package:flutter/material.dart';

/// Original, code-drawn scenery. No external image files or third-party art.
/// Each age supplies its own colors. This can later be replaced by commissioned art.
class OriginalKingdomArt extends StatelessWidget {
  const OriginalKingdomArt(
      {super.key,
      required this.sky,
      required this.land,
      required this.highlight,
      this.height = 220});
  final Color sky;
  final Color land;
  final Color highlight;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: CustomPaint(painter: _KingdomPainter(sky, land, highlight)),
        ),
      );
}

class _KingdomPainter extends CustomPainter {
  _KingdomPainter(this.sky, this.land, this.highlight);
  final Color sky;
  final Color land;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          sky,
          Color.lerp(sky, Colors.white, .58)!,
          Color.lerp(land, Colors.white, .55)!
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bg);
    final sun = Paint()..color = highlight.withValues(alpha: .85);
    canvas.drawCircle(Offset(w * .79, h * .22), h * .135, sun);
    canvas.drawCircle(Offset(w * .79, h * .22), h * .18,
        Paint()..color = highlight.withValues(alpha: .14));

    void mountain(double y, Color c, List<Offset> peaks) {
      final p = Path()..moveTo(0, h);
      p.lineTo(0, y);
      for (final peak in peaks) {
        p.lineTo(peak.dx * w, peak.dy * h);
      }
      p.lineTo(w, h);
      p.close();
      canvas.drawPath(p, Paint()..color = c);
    }

    mountain(h * .68, Color.lerp(sky, land, .30)!, [
      const Offset(.13, .47),
      const Offset(.23, .62),
      const Offset(.39, .35),
      const Offset(.56, .66),
      const Offset(.73, .45),
      const Offset(1, .67),
    ]);
    mountain(h * .74, Color.lerp(land, Colors.white, .45)!, [
      const Offset(.16, .66),
      const Offset(.30, .75),
      const Offset(.54, .55),
      const Offset(.76, .76),
      const Offset(.89, .60),
      const Offset(1, .69),
    ]);
    final hill = Path()
      ..moveTo(0, h * .79)
      ..quadraticBezierTo(w * .28, h * .60, w * .51, h * .81)
      ..quadraticBezierTo(w * .75, h * .95, w, h * .70)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(hill, Paint()..color = land);
    final road = Path()
      ..moveTo(w * .51, h)
      ..cubicTo(w * .47, h * .84, w * .55, h * .82, w * .54, h * .73)
      ..lineTo(w * .60, h * .73)
      ..cubicTo(w * .59, h * .85, w * .63, h * .92, w * .66, h)
      ..close();
    canvas.drawPath(road, Paint()..color = highlight.withValues(alpha: .43));

    // Original simple keep silhouette with warm highlights.
    final stone = Paint()..color = const Color(0xFFFFF5DC);
    final edge = Paint()..color = land.withValues(alpha: .47);
    final cx = w * .56, base = h * .75;
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(cx - 39, base - 58, 78, 62),
            const Radius.circular(3)),
        stone);
    canvas.drawRect(Rect.fromLTWH(cx - 25, base - 80, 50, 30), stone);
    canvas.drawRect(Rect.fromLTWH(cx - 13, base - 108, 26, 32), stone);
    for (var i = -1; i <= 1; i++) {
      canvas.drawRect(Rect.fromLTWH(cx + i * 24 - 7, base - 66, 14, 13), stone);
    }
    final roof = Path()
      ..moveTo(cx - 19, base - 107)
      ..lineTo(cx, base - 134)
      ..lineTo(cx + 19, base - 107)
      ..close();
    canvas.drawPath(roof, Paint()..color = highlight);
    canvas.drawRect(Rect.fromLTWH(cx - 5, base - 45, 11, 17), edge);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(cx - 8, base - 22, 16, 26), const Radius.circular(8)),
        edge);
    canvas.drawLine(
        Offset(cx, base - 134),
        Offset(cx, base - 153),
        Paint()
          ..color = const Color(0xFF5D647F)
          ..strokeWidth = 2);
    final flag = Path()
      ..moveTo(cx, base - 153)
      ..lineTo(cx + 22, base - 147)
      ..lineTo(cx, base - 140)
      ..close();
    canvas.drawPath(flag, Paint()..color = const Color(0xFFD66E6B));

    // Two rows of original stylized trees, no external sprites.
    for (final tree in const <Offset>[
      Offset(.07, .81),
      Offset(.14, .85),
      Offset(.25, .83),
      Offset(.79, .85),
      Offset(.87, .80),
      Offset(.95, .89)
    ]) {
      final x = w * tree.dx, y = h * tree.dy;
      canvas.drawRect(Rect.fromLTWH(x - 2, y - 16, 4, 21),
          Paint()..color = const Color(0xFF987B59));
      for (var j = 0; j < 3; j++) {
        canvas.drawCircle(
            Offset(x + (j - 1) * 6, y - 20 - (j % 2) * 8),
            12 + j % 2 * 3,
            Paint()
              ..color =
                  Color.lerp(land, const Color(0xFF167E57), .40 + j * .13)!);
      }
    }
    for (var i = 0; i < 17; i++) {
      final x = w * ((i * 41 % 97) / 100), y = h * (.15 + (i * 23 % 42) / 100);
      final r = 1.0 + (i % 3) * .5;
      canvas.drawCircle(Offset(x, y), r,
          Paint()..color = Colors.white.withValues(alpha: .75));
      if (i % 5 == 0) {
        canvas.drawLine(
            Offset(x - 4, y),
            Offset(x + 4, y),
            Paint()
              ..color = Colors.white.withValues(alpha: .55)
              ..strokeWidth = .8);
        canvas.drawLine(
            Offset(x, y - 4),
            Offset(x, y + 4),
            Paint()
              ..color = Colors.white.withValues(alpha: .55)
              ..strokeWidth = .8);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _KingdomPainter old) =>
      old.sky != sky || old.land != land || old.highlight != highlight;
}
