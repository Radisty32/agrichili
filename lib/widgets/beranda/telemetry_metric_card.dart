import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/telemetry_data.dart';
import '../common_widgets.dart';

class TelemetryMetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String unit;
  final String target;
  final String badge;
  final StatusType badgeType;
  final double progressValue;
  final VoidCallback? onTap;

  const TelemetryMetricCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.unit,
    required this.target,
    required this.badge,
    required this.badgeType,
    required this.progressValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(icon, size: 18, color: AppTheme.primaryGreen),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  target,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              StatusBadge(
                text: badge,
                type: badgeType,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TargetProgressBar(
            value: progressValue,
            targetMin: 60,
            targetMax: 80,
          ),
        ],
      ),
    );
  }
}
