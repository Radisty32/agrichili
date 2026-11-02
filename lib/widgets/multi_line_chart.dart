import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MultiLineTrendChart extends StatelessWidget {
  final double height;

  const MultiLineTrendChart({
    super.key,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          child: CustomPaint(
            size: Size(double.infinity, height),
            painter: _MultiLineTrendPainter(),
          ),
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('08:00', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('10:00', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('12:00', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('14:00 (Kini)', style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MultiLineTrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 12.0;
    const rightPadding = 12.0;
    const topPadding = 12.0;
    const bottomPadding = 16.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Horizontal grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;

    for (int i = 0; i < 4; i++) {
      final y = topPadding + (chartHeight / 3) * i;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );
    }

    // Line 1: Tanah (Soil moisture) - Cyan / Blue
    final soilPoints = [
      Offset(leftPadding + chartWidth * 0.0, topPadding + chartHeight * 0.45),
      Offset(leftPadding + chartWidth * 0.33, topPadding + chartHeight * 0.55),
      Offset(leftPadding + chartWidth * 0.66, topPadding + chartHeight * 0.62),
      Offset(leftPadding + chartWidth * 1.0, topPadding + chartHeight * 0.48),
    ];
    _drawSmoothLine(canvas, soilPoints, const Color(0xFF0284C7), strokeWidth: 2.2);

    // Line 2: Suhu (Temperature) - Coral / Reddish Orange
    final tempPoints = [
      Offset(leftPadding + chartWidth * 0.0, topPadding + chartHeight * 0.70),
      Offset(leftPadding + chartWidth * 0.33, topPadding + chartHeight * 0.48),
      Offset(leftPadding + chartWidth * 0.66, topPadding + chartHeight * 0.35),
      Offset(leftPadding + chartWidth * 1.0, topPadding + chartHeight * 0.42),
    ];
    _drawSmoothLine(canvas, tempPoints, const Color(0xFFEF4444), strokeWidth: 2.0);

    // Line 3: Udara (Air Humidity) - Teal / Green
    final humPoints = [
      Offset(leftPadding + chartWidth * 0.0, topPadding + chartHeight * 0.30),
      Offset(leftPadding + chartWidth * 0.33, topPadding + chartHeight * 0.38),
      Offset(leftPadding + chartWidth * 0.66, topPadding + chartHeight * 0.45),
      Offset(leftPadding + chartWidth * 1.0, topPadding + chartHeight * 0.36),
    ];
    _drawSmoothLine(canvas, humPoints, const Color(0xFF10B981), strokeWidth: 2.0);
  }

  void _drawSmoothLine(Canvas canvas, List<Offset> points, Color color, {double strokeWidth = 2.0}) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = p0.dx + (p1.dx - p0.dx) / 2;
      path.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

