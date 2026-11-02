import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/telemetry_data.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = StatusType.optimal,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case StatusType.optimal:
        bg = AppTheme.statusOptimalBg;
        fg = AppTheme.statusOptimalText;
        break;
      case StatusType.warning:
        bg = AppTheme.statusWarningBg;
        fg = AppTheme.statusWarningText;
        break;
      case StatusType.danger:
        bg = AppTheme.statusDangerBg;
        fg = AppTheme.statusDangerText;
        break;
      case StatusType.info:
        bg = AppTheme.statusInfoBg;
        fg = AppTheme.statusInfoText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: fg,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class AgriCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Border? border;
  final VoidCallback? onTap;

  const AgriCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.backgroundColor,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: border ?? Border.all(color: AppTheme.cardBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: content,
      );
    }
    return content;
  }
}

class TargetProgressBar extends StatelessWidget {
  final double value; // 0.0 to 100.0
  final double targetMin;
  final double targetMax;
  final Color progressColor;

  const TargetProgressBar({
    super.key,
    required this.value,
    this.targetMin = 60,
    this.targetMax = 80,
    this.progressColor = AppTheme.primaryGreen,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final clampedValue = (value.clamp(0, 100) / 100) * totalWidth;
        final targetStartX = (targetMin / 100) * totalWidth;
        final targetWidth = ((targetMax - targetMin) / 100) * totalWidth;

        return Stack(
          children: [
            // Background track
            Container(
              height: 7,
              width: totalWidth,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Target Range Zone highlight
            Positioned(
              left: targetStartX,
              child: Container(
                height: 7,
                width: targetWidth,
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Active Progress Fill
            Container(
              height: 7,
              width: clampedValue,
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        );
      },
    );
  }
}
