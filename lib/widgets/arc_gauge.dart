import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ArcGauge extends StatelessWidget {
  final double value; // 0 to 100
  final double height;

  const ArcGauge({
    super.key,
    required this.value,
    this.height = 190,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: CustomPaint(
            size: Size(double.infinity, height),
            painter: _ArcGaugePainter(value: value),
            child: Align(
              alignment: const Alignment(0, 0.45),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${value.toInt()}%',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'VOLUMETRIC WATER CONTENT (VWC)',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Legend row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(AppTheme.gaugeDry, '< 60% Kering'),
            const SizedBox(width: 14),
            _buildLegendItem(AppTheme.gaugeIdeal, '60 - 80% Ideal'),
            const SizedBox(width: 14),
            _buildLegendItem(AppTheme.gaugeWet, '> 80% Jenuh'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ArcGaugePainter extends CustomPainter {
  final double value;

  _ArcGaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.78);
    final radius = size.height * 0.65;
    const strokeWidth = 10.0;

    // Angle definitions: semi-circle from 180 deg (math.pi) to 0 deg
    // We can give it a gentle arc, say 190 deg to -10 deg (sweep 200 deg)
    const startAngle = math.pi * 1.05; // ~189 degrees
    const totalSweep = math.pi * 0.90; // sweeps to ~-9 degrees

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Segment 1: 0% - 60%
    final sweep1 = totalSweep * 0.60;
    final paint1 = Paint()
      ..color = AppTheme.gaugeDry.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweep1, false, paint1);

    // Segment 2: 60% - 80%
    final start2 = startAngle + sweep1;
    final sweep2 = totalSweep * 0.20;
    final paint2 = Paint()
      ..color = AppTheme.gaugeIdeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 1.5;
    canvas.drawArc(rect, start2, sweep2, false, paint2);

    // Segment 3: 80% - 100%
    final start3 = start2 + sweep2;
    final sweep3 = totalSweep * 0.20;
    final paint3 = Paint()
      ..color = AppTheme.gaugeWet.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, start3, sweep3, false, paint3);

    // Needle pointer
    final fraction = (value.clamp(0, 100)) / 100.0;
    final needleAngle = startAngle + (totalSweep * fraction);

    final needleLength = radius - 14;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    // Draw needle line
    final needlePaint = Paint()
      ..color = AppTheme.textDark
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleEnd, needlePaint);

    // Needle pivot circle
    final pivotPaint = Paint()
      ..color = AppTheme.textDark
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5.5, pivotPaint);

    final pivotInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 2.5, pivotInner);
  }

  @override
  bool shouldRepaint(covariant _ArcGaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
