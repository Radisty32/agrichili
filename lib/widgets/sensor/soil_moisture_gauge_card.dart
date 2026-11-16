import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/telemetry_data.dart';
import '../common_widgets.dart';
import '../arc_gauge.dart';

class SoilMoistureGaugeCard extends StatelessWidget {
  final double moistureValue;
  final String title;
  final String subtitle;
  final String badgeText;

  const SoilMoistureGaugeCard({
    super.key,
    this.moistureValue = 68,
    this.title = 'Kelembaban Tanah Riil',
    this.subtitle = 'Sensor Kedalaman Akar Aktif',
    this.badgeText = 'Optimal Cabai',
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              StatusBadge(
                text: badgeText,
                type: StatusType.optimal,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 14),

          // Arc Speedometer Gauge
          ArcGauge(value: moistureValue),
        ],
      ),
    );
  }
}
