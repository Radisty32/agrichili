import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../common_widgets.dart';
import '../telemetry_chart.dart';

class FluctuationChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String alertText;

  const FluctuationChartCard({
    super.key,
    this.title = 'Fluktuasi Kelembaban\nTanah',
    this.subtitle = 'Rentang 7 Hari Terakhir (9 Mar - 15 Mar 2024)',
    this.alertText =
        'Kelembaban di bawah 55% selama 1 jam pada 14 Mei 11:00 WIB sebelum irigasi pemulihan 2.4L aktif.',
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
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                  height: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.statusOptimalBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Live Sync',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 10),

          // Chart Legends
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _buildLegendBox(AppTheme.accentGreen.withValues(alpha: 0.35), 'Target Aman (60% - 80%)'),
              _buildLegendLine(AppTheme.primaryGreen, 'Tren Tanaman'),
              _buildLegendLine(AppTheme.statusInfoText, 'Irigasi Tetes'),
            ],
          ),
          const SizedBox(height: 14),

          // Custom Painted Chart
          const TelemetryHistoryChart(height: 170),
          const SizedBox(height: 14),

          // Alert Detection Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.statusDangerBg.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.statusDangerBg),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppTheme.statusDangerText,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7F1D1D),
                        height: 1.35,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Deteksi Kritis: ',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: alertText,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendBox(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLegendLine(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 2.5,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
