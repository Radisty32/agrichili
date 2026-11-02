import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TelemetryHistoryChart extends StatelessWidget {
  final double height;

  const TelemetryHistoryChart({
    super.key,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          child: CustomPaint(
            size: Size(double.infinity, height),
            painter: _TelemetryHistoryPainter(),
          ),
        ),
        const SizedBox(height: 8),
        // X-Axis labels
        const Padding(
          padding: EdgeInsets.only(left: 32, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('9 Mar', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('10 Mar', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('11 Mar', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('12 Mar', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('13 Mar', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('14 Mar', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              Text('15 Mar', style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class _TelemetryHistoryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 32.0;
    const rightPadding = 12.0;
    const topPadding = 12.0;
    const bottomPadding = 16.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Y values: 40% to 100%
    const minY = 40.0;
    const maxY = 100.0;

    double getY(double val) {
      final fraction = (val - minY) / (maxY - minY);
      return topPadding + (1 - fraction) * chartHeight;
    }

    // Grid lines & Y-axis labels
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final yLabels = [100, 80, 60, 40];
    for (final yVal in yLabels) {
      final y = getY(yVal.toDouble());
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );

      final textSpan = TextSpan(
        text: '$yVal%',
        style: const TextStyle(
          color: AppTheme.textMuted,
          fontSize: 9.5,
          fontWeight: FontWeight.w500,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(2, y - 6));
    }

    // Safe zone band: 60% to 80%
    final safeTop = getY(80.0);
    final safeBottom = getY(60.0);
    final safeZoneRect = Rect.fromLTRB(
      leftPadding,
      safeTop,
      size.width - rightPadding,
      safeBottom,
    );
    final safeZonePaint = Paint()
      ..color = AppTheme.accentGreen.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawRect(safeZoneRect, safeZonePaint);

    // Irrigation event marker line on 14 Mar (at around 72% X)
    final irigasiX = leftPadding + chartWidth * (5.2 / 6.0);
    final irigasiPaint = Paint()
      ..color = AppTheme.statusInfoText.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(irigasiX, getY(57.2)),
      Offset(irigasiX, getY(72.0)),
      irigasiPaint,
    );

    // Data points: [dayIndex 0 to 6, value]
    // 9 Mar: 66, 10 Mar: 78.1, 11 Mar: 71, 12 Mar: 66, 13 Mar: 63, 14 Mar: 57.2 -> 65, 15 Mar: 68.0
    final points = <Offset>[
      Offset(leftPadding + chartWidth * (0 / 6.0), getY(65.5)),
      Offset(leftPadding + chartWidth * (1 / 6.0), getY(78.1)), // Peak
      Offset(leftPadding + chartWidth * (2 / 6.0), getY(71.0)),
      Offset(leftPadding + chartWidth * (3 / 6.0), getY(65.8)),
      Offset(leftPadding + chartWidth * (4 / 6.0), getY(62.5)),
      Offset(leftPadding + chartWidth * (5 / 6.0), getY(57.2)), // Low dip
      Offset(leftPadding + chartWidth * (6 / 6.0), getY(68.0)), // Current
    ];

    // Build smooth curve path
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Gradient fill under the curve
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, getY(minY))
      ..lineTo(points.first.dx, getY(minY))
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryGreen.withValues(alpha: 0.25),
          AppTheme.primaryGreen.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTRB(leftPadding, topPadding, size.width - rightPadding, getY(minY)))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Stroke the line
    final strokePaint = Paint()
      ..color = AppTheme.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);

    // Draw active point marker at the latest point (15 Mar, 68%)
    final lastPoint = points.last;
    final dotBg = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotRing = Paint()
      ..color = AppTheme.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final dotCore = Paint()
      ..color = AppTheme.primaryGreen
      ..style = PaintingStyle.fill;

    canvas.drawCircle(lastPoint, 5, dotBg);
    canvas.drawCircle(lastPoint, 5, dotRing);
    canvas.drawCircle(lastPoint, 2.5, dotCore);

    // Floating Tooltip above last point: "68%"
    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(lastPoint.dx - 12, lastPoint.dy - 20), width: 38, height: 20),
      const Radius.circular(5),
    );
    final tooltipPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawRRect(tooltipRect, tooltipPaint);

    final tooltipSpan = const TextSpan(
      text: '68%',
      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
    );
    final tooltipPainter = TextPainter(
      text: tooltipSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    tooltipPainter.paint(
      canvas,
      Offset(lastPoint.dx - 12 - (tooltipPainter.width / 2), lastPoint.dy - 20 - (tooltipPainter.height / 2)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

